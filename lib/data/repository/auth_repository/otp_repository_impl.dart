import 'package:dartz/dartz.dart';
import '/core/core.dart';
import '/data/data.dart';
import '/domain/domain.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OtpRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> requestOtp({
    required String email,
    bool? onlyRequest,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.requestOtp(
          email: email,
          onlyRequest: onlyRequest,
        );

        if (responseModel.status && responseModel.statusCode == 200) {
          return const Right(null);
        } else {
          String errorMessage =
              responseModel.data?.message ?? "Error al solicitar OTP.";
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
            message: e.message ?? "Error del servidor al solicitar OTP.",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String code,
    bool? onlyVerify,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final responseModel = await remoteDataSource.verifyOtp(
          email: email,
          code: code,
          onlyVerify: onlyVerify,
        );

        if (responseModel.status && responseModel.statusCode == 200) {
          return const Right(null);
        } else {
          String errorMessage =
              responseModel.data?.message ?? "Error al verificar OTP.";
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
            message: e.message ?? "Error del servidor al verificar OTP.",
            statusCode: e.statusCode,
          ),
        );
      }
    } else {
      return Left(NetworkFailure(message: "No hay conexión a internet"));
    }
  }
}
