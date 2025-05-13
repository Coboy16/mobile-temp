import 'package:dartz/dartz.dart';

import '/core/errors/failure.dart';
import '/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, ValidationResponseEntity>> validateUser({
    required String email,
  });

  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String cedulaOrPassword,
  });

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> logout({required String email});

  Future<Either<Failure, GoogleUserEntity>> loginWithGoogle({
    required String idToken,
    required String email,
  });
}
