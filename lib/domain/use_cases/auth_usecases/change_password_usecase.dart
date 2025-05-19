import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/repository/auth_repository/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      email: email,
      newPassword: newPassword,
    );
  }
}
