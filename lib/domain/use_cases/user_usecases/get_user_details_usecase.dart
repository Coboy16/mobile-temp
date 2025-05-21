import 'package:dartz/dartz.dart';
import '/core/errors/failure.dart';
import '/domain/entities/user_entities/user_details_entity.dart';
import '/domain/repository/user_repository/user_repository.dart';

class GetUserDetailsUseCase {
  final UserRepository repository;

  GetUserDetailsUseCase(this.repository);

  Future<Either<Failure, UserDetailsEntity>> call({
    required String userId,
  }) async {
    return await repository.getUserDetails(userId: userId);
  }
}
