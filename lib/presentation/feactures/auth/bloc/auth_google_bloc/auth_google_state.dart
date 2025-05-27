part of 'auth_google_bloc.dart';

sealed class AuthGoogleState extends Equatable {
  const AuthGoogleState();

  @override
  List<Object> get props => [];
}

final class AuthGoogleInitial extends AuthGoogleState {}

class AuthGoogleLoading extends AuthGoogleState {}

class AuthGoogleAuthenticated extends AuthGoogleState {
  final String idToken;
  final UserEntity googleUser;

  const AuthGoogleAuthenticated({
    required this.idToken,
    required this.googleUser,
  });

  @override
  List<Object> get props => [idToken, googleUser];
}

class AuthGoogleSuccess extends AuthGoogleState {
  final UserEntity user;
  final String idToken;

  const AuthGoogleSuccess({required this.user, required this.idToken});

  @override
  List<Object> get props => [user, idToken];
}

class AuthGoogleUnauthenticated extends AuthGoogleState {
  final String? message;
  const AuthGoogleUnauthenticated({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

class AuthGoogleError extends AuthGoogleState {
  final String message;
  final int? statusCode;

  const AuthGoogleError({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? ''];
}
