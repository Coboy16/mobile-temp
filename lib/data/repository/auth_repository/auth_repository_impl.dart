import 'package:dartz/dartz.dart';

import '/domain/domain.dart';
import '/core/core.dart';
import '/data/data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ValidationResponseEntity>> validateUser({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final validationResponseModel = await remoteDataSource.validateUser(
          email: email,
        );
        final entity = ValidationResponseEntity(
          isBlocked: validationResponseModel.data.blocked.state,
          minutesBlocked: validationResponseModel.data.blocked.minute,
        );
        return Right(entity);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? "Error del servidor al validar usuario",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String cedulaOrPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final loginResponseModel = await remoteDataSource.login(
          email: email,
          cedulaOrPassword: cedulaOrPassword,
        );

        final UserModel userModel = loginResponseModel.user;

        await localDataSource.saveToken(loginResponseModel.token);
        await localDataSource.saveUser(userModel); // Guardamos el UserModel

        return Right(userModel);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? "Error del servidor durante el login",
            statusCode: e.statusCode,
          ),
        );
      } on CacheException catch (e) {
        return Left(
          CacheFailure(message: e.message ?? "Error al guardar datos en caché"),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null || token.isEmpty) {
        return const Right(null);
      }
      final userModel = await localDataSource.getUser(); // Retorna UserModel?
      return Right(userModel);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(message: e.message ?? "Error al obtener usuario de caché"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        final logoutResponse = await remoteDataSource.logout(email: email);

        if (logoutResponse.status && logoutResponse.statusCode == 200) {
          await localDataSource.clearToken();
          await localDataSource.clearUser();
          return const Right(null);
        } else {
          String messageFromServer = "Error al cerrar sesión en el servidor";
          if (logoutResponse.data.containsKey('message')) {
            messageFromServer = logoutResponse.data['message'].toString();
          }

          return Left(
            ServerFailure(
              message: messageFromServer,
              statusCode: logoutResponse.statusCode,
            ),
          );
        }
      } on ServerException catch (e) {
        if (e.statusCode == 401) {
          await localDataSource.clearToken();
          await localDataSource.clearUser();
          return const Right(null);
        }
        return Left(
          ServerFailure(
            message: e.message ?? "Error desconocido al cerrar sesión",
            statusCode: e.statusCode,
          ),
        );
      } on CacheException catch (e) {
        return Left(
          CacheFailure(message: e.message ?? "Error al limpiar la caché local"),
        );
      }
    } else {
      try {
        await localDataSource.clearToken();
        await localDataSource.clearUser();
        return const Right(null);
      } on CacheException catch (e) {
        return Left(
          CacheFailure(
            message: e.message ?? "Error al limpiar la caché sin conexión",
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle({
    required String idToken,
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.loginWithGoogle(
          idToken: idToken,
          email: email,
        ); // response es LoginResponseModel

        //Guarda de token y usuario en caché
        await localDataSource.saveToken(response.token);
        await localDataSource.saveUser(response.user);

        return Right(response.user);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? "Error del servidor durante login con Google",
            statusCode: e.statusCode,
          ),
        );
      } on CacheException catch (e) {
        return Left(
          CacheFailure(message: e.message ?? "Error al guardar datos en caché"),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, ValidationResponseEntity>> checkUserLockStatus({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final validationResponseModel = await remoteDataSource
            .checkUserLockStatus(email: email);
        final entity = ValidationResponseEntity(
          isBlocked: validationResponseModel.data.blocked.state,
          minutesBlocked: validationResponseModel.data.blocked.minute,
        );
        return Right(entity);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message:
                e.message ??
                "Error del servidor al verificar estado de bloqueo",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String email,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.changePassword(
          email: email,
          newPassword: newPassword,
        );
        if (response.status && response.statusCode == 200) {
          return const Right(null);
        } else {
          return Left(
            ServerFailure(
              message: response.message ?? "Error al cambiar la contraseña.",
              statusCode: response.statusCode,
            ),
          );
        }
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message:
                e.message ?? "Error del servidor al cambiar la contraseña.",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, SessionStatusEntity>> checkSessionStatus({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.checkSessionStatus(
          email: email,
        );
        final entity = SessionStatusEntity(
          hasActiveSession: responseModel.data.session,
        );
        return Right(entity);
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
            message: e.message ?? "Error del servidor al verificar la sesión.",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }
}
