import 'package:dartz/dartz.dart';
import '/core/errors/failure.dart';
import '/domain/repository/auth_repository/otp_repository.dart';

class VerifyOtpUseCase {
  final OtpRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String code,
    bool? onlyVerify,
  }) async {
    return await repository.verifyOtp(
      email: email,
      code: code,
      onlyVerify: onlyVerify,
    );
  }
}
