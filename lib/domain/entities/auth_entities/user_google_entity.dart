import 'package:equatable/equatable.dart';

class GoogleUserEntity extends Equatable {
  final String name;
  final String email;

  const GoogleUserEntity({required this.name, required this.email});

  @override
  List<Object?> get props => [name, email];
}
