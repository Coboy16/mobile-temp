import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/domain.dart';

class LogoutFromGoogleUseCase {
  final AuthRepository repository;

  LogoutFromGoogleUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.logout(email: email);
  }
}
