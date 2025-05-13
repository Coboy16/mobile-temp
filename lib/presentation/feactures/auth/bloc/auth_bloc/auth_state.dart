part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthValidationInProgress extends AuthState {}

class AuthValidationSuccess extends AuthState {
  final ValidationResponseEntity validationResponse;

  const AuthValidationSuccess({required this.validationResponse});

  @override
  List<Object> get props => [validationResponse];
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

class AuthFailure extends AuthState {
  final String message;
  final int? statusCode;

  const AuthFailure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 500];
}
