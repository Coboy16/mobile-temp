import 'package:equatable/equatable.dart';

class UserDetailsEntity extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String? fatherLastname;
  final String? motherLastname;

  const UserDetailsEntity({
    required this.userId,
    required this.email,
    required this.name,
    this.fatherLastname,
    this.motherLastname,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    name,
    fatherLastname,
    motherLastname,
  ];

  String get fullName {
    final parts = [name, fatherLastname, motherLastname];
    return parts.where((s) => s != null && s.isNotEmpty).join(' ').trim();
  }
}
