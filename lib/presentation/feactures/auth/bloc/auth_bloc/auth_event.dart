part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthValidateUserRequested extends AuthEvent {
  final String email;

  const AuthValidateUserRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String cedulaOrPassword;

  const AuthLoginRequested({
    required this.email,
    required this.cedulaOrPassword,
  });

  @override
  List<Object> get props => [email, cedulaOrPassword];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// Para verificar si ya hay un usuario logueado al inicio
class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}
