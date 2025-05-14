import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/domain.dart';

class RegisterUserUseCase {
  final RegisterRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String name,
    required String fatherLastname,
    required String motherLastname,
    required String email,
    required String password,
  }) async {
    return await repository.registerUser(
      name: name,
      fatherLastname: fatherLastname,
      motherLastname: motherLastname,
      email: email,
      password: password,
    );
  }
}
