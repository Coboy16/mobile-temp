import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';

import '/domain/domain.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String cedulaOrPassword,
  }) async {
    return await repository.login(
      email: email,
      cedulaOrPassword: cedulaOrPassword,
    );
  }
}
