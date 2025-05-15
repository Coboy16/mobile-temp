import 'package:dartz/dartz.dart';
import '/core/errors/failure.dart';

abstract class OtpRepository {
  Future<Either<Failure, void>> requestOtp({required String email});
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String code,
  });
}
