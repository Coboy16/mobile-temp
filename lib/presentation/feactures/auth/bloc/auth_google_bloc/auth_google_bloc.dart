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
        // Web: usar popup
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
        // Android/iOS: usar google_sign_in + firebase_auth
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
        // Usar el caso de uso para registrar en el backend
        final failureOrUser = await _loginWithGoogleUseCase(
          idToken: idToken,
          email: 'oayoso@gmail.com',
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
      await FirebaseAuth.instance.signOut();

      if (!kIsWeb) {
        await GoogleSignIn().signOut();
      }

      // Usar el caso de uso para logout del backend
      final failureOrSuccess = await _logoutFromGoogleUseCase(
        'oayoso@gmail.com',
      );

      failureOrSuccess.fold(
        (failure) =>
            emit(AuthGoogleError(message: _mapFailureToMessage(failure))),
        (_) => emit(AuthGoogleUnauthenticated()),
      );
    } catch (e) {
      emit(AuthGoogleError(message: 'Error al cerrar sesión: $e'));
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
          // Necesitamos obtener el idToken actual si está disponible
          final currentUser = FirebaseAuth.instance.currentUser;
          currentUser?.getIdToken().then((token) {
            if (token != null) {
              emit(AuthGoogleSuccess(user: user, idToken: token));
            } else {
              emit(const AuthGoogleUnauthenticated());
            }
          });
        } else {
          emit(const AuthGoogleUnauthenticated());
        }
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
