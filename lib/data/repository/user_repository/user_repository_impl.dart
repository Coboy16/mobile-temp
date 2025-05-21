import 'package:dartz/dartz.dart';

import '/domain/domain.dart';
import '/data/data.dart';
import '/core/core.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserDetailsEntity>> getUserDetails({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userDetailsResponseModel = await remoteDataSource.getUserDetails(
          userId: userId,
        );
        final userDataModel = userDetailsResponseModel.userData;

        if (userDataModel != null) {
          return Right(userDataModel.toEntity());
        } else {
          return Left(
            ServerFailure(
              message: "Datos de usuario no encontrados en la respuesta.",
              statusCode: userDetailsResponseModel.statusCode,
            ),
          );
        }
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message.toString(),
            statusCode: e.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ServerFailure(message: "Error inesperado: ${e.toString()}"),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserDetails({
    required String userId,
    required String name,
    required String fatherLastname,
    required String motherLastname,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = UpdateUserRequestModel(
          name: name,
          fatherLastname: fatherLastname,
          motherLastname: motherLastname,
        );
        await remoteDataSource.updateUserDetails(
          userId: userId,
          updateUserRequest: requestModel,
        );
        return const Right(null); // Éxito
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message.toString(),
            statusCode: e.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ServerFailure(
            message: "Error inesperado al actualizar: ${e.toString()}",
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser({required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUser(userId: userId);
        return const Right(null); // Éxito
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message.toString(),
            statusCode: e.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ServerFailure(
            message: "Error inesperado al eliminar: ${e.toString()}",
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }
}
