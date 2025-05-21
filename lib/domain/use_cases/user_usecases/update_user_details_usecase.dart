import 'package:dartz/dartz.dart';

import '/domain/repository/user_repository/user_repository.dart';
import '/core/errors/failure.dart';

class UpdateUserDetailsUseCase {
  final UserRepository repository;

  UpdateUserDetailsUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String name,
    required String fatherLastname,
    required String motherLastname,
  }) async {
    return await repository.updateUserDetails(
      userId: userId,
      name: name,
      fatherLastname: fatherLastname,
      motherLastname: motherLastname,
    );
  }
}
