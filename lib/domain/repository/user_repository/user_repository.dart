import 'package:dartz/dartz.dart';
import '/core/errors/failure.dart';
import '/domain/entities/user_entities/user_details_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserDetailsEntity>> getUserDetails({
    required String userId,
  });

  Future<Either<Failure, void>> updateUserDetails({
    required String userId,
    required String name,
    required String fatherLastname,
    required String motherLastname,
  });

  Future<Either<Failure, void>> deleteUser({required String userId});
}
