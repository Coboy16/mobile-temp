import 'package:dartz/dartz.dart';

import '/domain/domain.dart';
import '/data/data.dart';
import '/core/core.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });
  Future<Either<Failure, T>> _executeCall<T>(Future<T> Function() call) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await call();
        return Right(result);
      } on UnauthorizedException catch (e) {
        try {
          await localDataSource.clearToken();
          await localDataSource.clearUser();
        } catch (_) {}
        return Left(
          SessionExpiredFailure(message: e.message ?? "Tu sesión ha expirado."),
        );
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? "Error del servidor",
            statusCode: e.statusCode,
          ),
        );
      } on CacheException catch (e) {
        // Aunque menos probable aquí, por completitud
        return Left(CacheFailure(message: e.message ?? "Error de caché"));
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
  Future<Either<Failure, UserDetailsEntity>> getUserDetails({
    required String userId,
  }) async {
    return _executeCall<UserDetailsEntity>(() async {
      final userDetailsResponseModel = await remoteDataSource.getUserDetails(
        userId: userId,
      );
      // La validación de userDataModel != null ahora se hace dentro de _handleUserResponse
      // o se lanza una excepción si no es válido, que _executeCall manejará.
      return userDetailsResponseModel.userData!.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> updateUserDetails({
    required String userId,
    required String name,
    required String fatherLastname,
    required String motherLastname,
  }) async {
    return _executeCall<void>(() async {
      final requestModel = UpdateUserRequestModel(
        name: name,
        fatherLastname: fatherLastname,
        motherLastname: motherLastname,
      );
      await remoteDataSource.updateUserDetails(
        userId: userId,
        updateUserRequest: requestModel,
      );
      // No es necesario retornar nada explícitamente para void
    });
  }

  @override
  Future<Either<Failure, void>> deleteUser({required String userId}) async {
    return _executeCall<void>(() async {
      await remoteDataSource.deleteUser(userId: userId);
      // No es necesario retornar nada explícitamente para void
    });
  }
}
