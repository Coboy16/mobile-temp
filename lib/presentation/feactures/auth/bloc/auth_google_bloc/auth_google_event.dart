part of 'auth_google_bloc.dart';

sealed class AuthGoogleEvent extends Equatable {
  const AuthGoogleEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthGoogleEvent {}

class SignOutRequested extends AuthGoogleEvent {}

class CheckGoogleAuthStatus extends AuthGoogleEvent {}
