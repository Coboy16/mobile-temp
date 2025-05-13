import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';

import '/domain/domain.dart';

class ValidateUserUseCase {
  final AuthRepository repository;

  ValidateUserUseCase(this.repository);

  Future<Either<Failure, ValidationResponseEntity>> call({
    required String email,
  }) async {
    return await repository.validateUser(email: email);
  }
}
