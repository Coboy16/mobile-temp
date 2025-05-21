import 'package:equatable/equatable.dart';

class UserDetailsEntity extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String fatherLastname;
  final String motherLastname;

  const UserDetailsEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.fatherLastname,
    required this.motherLastname,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    name,
    fatherLastname,
    motherLastname,
  ];

  // Opcional: un método para obtener el nombre completo
  String get fullName => '$name $fatherLastname $motherLastname'.trim();
}
