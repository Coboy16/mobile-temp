import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:google_sign_in/google_sign_in.dart';

part 'google_id_token_event.dart';
part 'google_id_token_state.dart';

class GoogleIdTokenBloc extends Bloc<GoogleIdTokenEvent, GoogleIdTokenState> {
  GoogleIdTokenBloc() : super(GoogleIdTokenInitial()) {
    on<FetchGoogleIdToken>(_onFetchGoogleIdToken);
  }

  Future<void> _onFetchGoogleIdToken(
    FetchGoogleIdToken event,
    Emitter<GoogleIdTokenState> emit,
  ) async {
    emit(GoogleIdTokenLoading());
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
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          emit(GoogleIdTokenCancelled());
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
        debugPrint('GoogleIdTokenBloc - idToken: $idToken');
        debugPrint('GoogleIdTokenBloc - email: $email');
        emit(GoogleIdTokenSuccess(idToken: idToken, email: email));
      } else {
        emit(
          const GoogleIdTokenFailure(
            message: 'No se pudo obtener el idToken o el email desde Google.',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        emit(GoogleIdTokenCancelled());
      } else if (e.code == 'network-request-failed') {
        emit(
          const GoogleIdTokenFailure(
            message:
                'Error de red. Por favor, verifica tu conexión e inténtalo de nuevo.',
          ),
        );
      } else {
        debugPrint(
          'GoogleIdTokenBloc - FirebaseAuthException: ${e.toString()}, code: ${e.code}',
        );
        emit(
          GoogleIdTokenFailure(
            message:
                'Error de autenticación con Google: ${e.message ?? e.code}',
          ),
        );
      }
    } catch (e) {
      debugPrint('GoogleIdTokenBloc - Error: ${e.toString()}');
      emit(
        GoogleIdTokenFailure(
          message: 'Ocurrió un error inesperado: ${e.toString()}',
        ),
      );
    }
  }
}
