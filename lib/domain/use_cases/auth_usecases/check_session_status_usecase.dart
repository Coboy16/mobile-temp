import 'package:dartz/dartz.dart';
import '/core/errors/failure.dart';
import '/domain/entities/auth_entities/session_status_entity.dart';
import '/domain/repository/auth_repository/auth_repository.dart';

class CheckSessionStatusUseCase {
  final AuthRepository repository;

  CheckSessionStatusUseCase(this.repository);

  Future<Either<Failure, SessionStatusEntity>> call({
    required String email,
  }) async {
    return await repository.checkSessionStatus(email: email);
  }
}
