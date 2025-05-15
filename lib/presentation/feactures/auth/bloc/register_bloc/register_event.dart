part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserSubmitted extends RegisterEvent {
  final String name;
  final String fatherLastname;
  final String motherLastname;
  final String email;
  final String password;

  const RegisterUserSubmitted({
    required this.name,
    required this.fatherLastname,
    required this.motherLastname,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
    name,
    fatherLastname,
    motherLastname,
    email,
    password,
  ];
}

class RegisterWithGoogleSubmitted extends RegisterEvent {
  final String email;
  final String idToken;

  const RegisterWithGoogleSubmitted({
    required this.email,
    required this.idToken,
  });

  @override
  List<Object> get props => [email, idToken];
}
