import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/domain.dart';

class RegisterWithGoogleUseCase {
  final RegisterRepository repository;

  RegisterWithGoogleUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String idToken,
  }) async {
    return await repository.registerWithGoogle(email: email, idToken: idToken);
  }
}
