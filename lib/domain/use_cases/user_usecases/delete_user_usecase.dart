import 'package:dartz/dartz.dart';

import '/domain/repository/user_repository/user_repository.dart';
import '/core/errors/failure.dart';

class DeleteUserUseCase {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  Future<Either<Failure, void>> call({required String userId}) async {
    return await repository.deleteUser(userId: userId);
  }
}
