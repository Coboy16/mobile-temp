part of 'otp_verification_bloc.dart';

sealed class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object> get props => [];
}

final class OtpVerificationInitial extends OtpVerificationState {}

final class OtpRequestInProgress extends OtpVerificationState {}

final class OtpRequestSuccess extends OtpVerificationState {
  final String email;

  const OtpRequestSuccess({required this.email});

  @override
  List<Object> get props => [email];
}

final class OtpRequestFailure extends OtpVerificationState {
  final String message;
  final int? statusCode;

  const OtpRequestFailure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

final class OtpVerifyInProgress extends OtpVerificationState {
  final String email;
  const OtpVerifyInProgress({required this.email});
  @override
  List<Object> get props => [email];
}

final class OtpVerifySuccess extends OtpVerificationState {
  final String email;
  const OtpVerifySuccess({required this.email});
  @override
  List<Object> get props => [email];
}

final class OtpVerifyFailure extends OtpVerificationState {
  final String email;
  final String message;
  final int? statusCode;

  const OtpVerifyFailure({
    required this.email,
    required this.message,
    this.statusCode,
  });

  @override
  List<Object> get props => [email, message, statusCode ?? 0];
}
