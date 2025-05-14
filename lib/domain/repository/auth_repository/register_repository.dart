import 'package:dartz/dartz.dart';
import '/core/core.dart';

abstract class RegisterRepository {
  Future<Either<Failure, void>> registerUser({
    required String name,
    required String fatherLastname,
    required String motherLastname,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> registerWithGoogle({
    required String email,
    required String idToken,
  });
}
