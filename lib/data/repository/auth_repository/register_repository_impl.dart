import 'package:dartz/dartz.dart';

import '/domain/domain.dart';

import '/core/core.dart';
import '/data/data.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl({
    required this.registerRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> registerUser({
    required String name,
    required String fatherLastname,
    required String motherLastname,
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await registerRemoteDataSource.registerUser(
          name: name,
          fatherLastname: fatherLastname,
          motherLastname: motherLastname,
          email: email,
          password: password,
        );

        if (responseModel.status && responseModel.statusCode == 200) {
          return const Right(null);
        } else {
          String errorMessage =
              "Error al registrar usuario. Código: ${responseModel.statusCode}";
          if (responseModel.data.containsKey('message')) {
            errorMessage = responseModel.data['message'].toString();
          } else if (responseModel.data.containsKey('MESSAGES')) {
            errorMessage = responseModel.data['MESSAGES'].toString();
          }
          return Left(
            ServerFailure(
              message: errorMessage,
              statusCode: responseModel.statusCode,
            ),
          );
        }
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: e.message ?? "Error del servidor durante el registro",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, void>> registerWithGoogle({
    required String email,
    required String idToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await registerRemoteDataSource.registerWithGoogle(
          email: email,
          idToken: idToken,
        );

        if (responseModel.status && responseModel.statusCode == 200) {
          return const Right(null);
        } else {
          String errorMessage =
              "Error al registrar con Google. Código: ${responseModel.statusCode}";
          if (responseModel.data.containsKey('message')) {
            errorMessage = responseModel.data['message'].toString();
          } else if (responseModel.data.containsKey('MESSAGES')) {
            errorMessage = responseModel.data['MESSAGES'].toString();
          }
          return Left(
            ServerFailure(
              message: errorMessage,
              statusCode: responseModel.statusCode,
            ),
          );
        }
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message:
                e.message ??
                "Error del servidor durante el registro con Google",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }
}
