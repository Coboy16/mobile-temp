import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/core/core.dart';
import '/domain/domain.dart';

part 'auth_google_event.dart';
part 'auth_google_state.dart';

class AuthGoogleBloc extends Bloc<AuthGoogleEvent, AuthGoogleState> {
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LogoutFromGoogleUseCase _logoutFromGoogleUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthGoogleBloc({
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required LogoutFromGoogleUseCase logoutFromGoogleUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginWithGoogleUseCase = loginWithGoogleUseCase,
       _logoutFromGoogleUseCase = logoutFromGoogleUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(AuthGoogleInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckGoogleAuthStatus>(_onCheckGoogleAuthStatus);
    on<FinalizeGoogleLoginWithToken>(_onFinalizeGoogleLoginWithToken);
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthGoogleState> emit,
  ) async {
    emit(AuthGoogleLoading());

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      String? idToken;
      String? email;

      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        final UserCredential userCredential = await auth.signInWithPopup(
          googleProvider,
        );
        idToken = await userCredential.user?.getIdToken();
        email = userCredential.user?.email;
        debugPrint('idToken: $idToken');
        debugPrint('email: $email');
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          emit(
            AuthGoogleUnauthenticated(
              message: 'Inicio de sesión cancelado por el usuario.',
            ),
          );
          return;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await auth.signInWithCredential(
          credential,
        );
        idToken = await userCredential.user?.getIdToken();
        email = userCredential.user?.email;
      }

      if (idToken != null && email != null) {
        final failureOrUser = await _loginWithGoogleUseCase(
          idToken: idToken,
          email: email, // Usar el email obtenido de Google
        );
        failureOrUser.fold(
          (failure) => emit(
            AuthGoogleError(
              message: _mapFailureToMessage(failure),
              statusCode:
                  (failure is ServerFailure) ? failure.statusCode : null,
            ),
          ),
          (googleUser) => emit(
            AuthGoogleAuthenticated(idToken: idToken!, googleUser: googleUser),
          ),
        );
      } else {
        emit(
          AuthGoogleError(message: 'No se pudo obtener el idToken o email.'),
        );
      }
    } catch (e) {
      emit(AuthGoogleError(message: 'Error al iniciar sesión con Google.'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthGoogleState> emit,
  ) async {
    emit(AuthGoogleLoading());
    try {
      String? userEmail;
      final currentState = state;

      if (currentState is AuthGoogleAuthenticated) {
        userEmail = currentState.googleUser.email;
      } else if (currentState is AuthGoogleSuccess) {
        userEmail = currentState.user.email;
      }

      if (userEmail == null || userEmail.isEmpty) {
        final User? firebaseUser = FirebaseAuth.instance.currentUser;
        userEmail = firebaseUser?.email;
      }

      if (userEmail == null || userEmail.isEmpty) {
        final failureOrUser = await _getCurrentUserUseCase();
        final potentialUser = failureOrUser.getOrElse(() => null);
        if (potentialUser != null) {
          userEmail = potentialUser.email;
        }
      }

      if (userEmail == null || userEmail.isEmpty) {
        emit(
          AuthGoogleError(
            message:
                'No se pudo determinar el email del usuario para cerrar sesión.',
          ),
        );
        return;
      }

      await FirebaseAuth.instance.signOut();
      if (!kIsWeb) {
        await GoogleSignIn().signOut();
      }

      final failureOrSuccess = await _logoutFromGoogleUseCase(userEmail);

      failureOrSuccess.fold(
        (failure) =>
            emit(AuthGoogleError(message: _mapFailureToMessage(failure))),
        (_) => emit(
          AuthGoogleUnauthenticated(message: "Sesión cerrada correctamente"),
        ),
      );
    } catch (e) {
      emit(AuthGoogleError(message: 'Error al cerrar sesión: ${e.toString()}'));
    }
  }

  Future<void> _onCheckGoogleAuthStatus(
    CheckGoogleAuthStatus event,
    Emitter<AuthGoogleState> emit,
  ) async {
    emit(AuthGoogleLoading());

    final failureOrUser = await _getCurrentUserUseCase();
    failureOrUser.fold(
      (failure) => emit(
        AuthGoogleUnauthenticated(message: _mapFailureToMessage(failure)),
      ),
      (user) {
        if (user != null) {
          final currentUser = FirebaseAuth.instance.currentUser;
          currentUser
              ?.getIdToken()
              .then((token) {
                if (token != null) {
                  emit(AuthGoogleSuccess(user: user, idToken: token));
                } else {
                  emit(const AuthGoogleUnauthenticated());
                }
              })
              .catchError((_) {
                emit(const AuthGoogleUnauthenticated());
              });
        } else {
          emit(const AuthGoogleUnauthenticated());
        }
      },
    );
  }

  Future<void> _onFinalizeGoogleLoginWithToken(
    FinalizeGoogleLoginWithToken event,
    Emitter<AuthGoogleState> emit,
  ) async {
    emit(AuthGoogleLoading());
    final failureOrUser = await _loginWithGoogleUseCase(
      idToken: event.idToken,
      email: event.email,
    );
    failureOrUser.fold(
      (failure) => emit(
        AuthGoogleError(
          message: _mapFailureToMessage(failure),
          statusCode: (failure is ServerFailure) ? failure.statusCode : null,
        ),
      ),
      (googleUser) {
        emit(
          AuthGoogleAuthenticated(
            idToken: event.idToken,
            googleUser: googleUser,
          ),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message;
      case CacheFailure _:
        return failure.message;
      case NetworkFailure _:
        return failure.message;
      default:
        return 'Ocurrió un error inesperado: ${failure.message}';
    }
  }
}
