part of 'auth_google_bloc.dart';

sealed class AuthGoogleEvent extends Equatable {
  const AuthGoogleEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthGoogleEvent {}

class SignOutRequested extends AuthGoogleEvent {}

class CheckGoogleAuthStatus extends AuthGoogleEvent {}

class FinalizeGoogleLoginWithToken extends AuthGoogleEvent {
  final String idToken;
  final String email;

  const FinalizeGoogleLoginWithToken({
    required this.idToken,
    required this.email,
  });

  @override
  List<Object> get props => [idToken, email];
}
