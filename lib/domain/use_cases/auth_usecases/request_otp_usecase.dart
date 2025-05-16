import 'package:dartz/dartz.dart';
import '/core/errors/failure.dart';
import '/domain/repository/auth_repository/otp_repository.dart';

class RequestOtpUseCase {
  final OtpRepository repository;

  RequestOtpUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    bool? onlyRequest,
  }) async {
    return await repository.requestOtp(email: email, onlyRequest: onlyRequest);
  }
}
