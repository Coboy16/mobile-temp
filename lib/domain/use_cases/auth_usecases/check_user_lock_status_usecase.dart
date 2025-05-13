import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/domain.dart';

class CheckUserLockStatusUseCase {
  final AuthRepository repository;

  CheckUserLockStatusUseCase(this.repository);

  Future<Either<Failure, ValidationResponseEntity>> call({
    required String email,
  }) async {
    return await repository.checkUserLockStatus(email: email);
  }
}
