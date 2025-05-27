import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/domain.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String idToken,
    required String email,
  }) async {
    return await repository.loginWithGoogle(idToken: idToken, email: email);
  }
}
