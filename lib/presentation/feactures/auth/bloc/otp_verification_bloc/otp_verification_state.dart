part of 'otp_verification_bloc.dart';

sealed class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object?> get props => [];
}

final class OtpVerificationInitial extends OtpVerificationState {}

final class OtpRequestInProgress extends OtpVerificationState {
  final String email;
  const OtpRequestInProgress({required this.email});
  @override
  List<Object?> get props => [email];
}

final class OtpRequestSuccess extends OtpVerificationState {
  final String email;
  final bool? wasOnlyRequest;

  const OtpRequestSuccess({required this.email, this.wasOnlyRequest});

  @override
  List<Object?> get props => [email, wasOnlyRequest];
}

final class OtpRequestFailure extends OtpVerificationState {
  final String email;
  final String message;
  final int? statusCode;
  final bool? wasOnlyRequest;

  const OtpRequestFailure({
    required this.email,
    required this.message,
    this.statusCode,
    this.wasOnlyRequest,
  });

  @override
  List<Object?> get props => [email, message, statusCode, wasOnlyRequest];
}

final class OtpVerifyInProgress extends OtpVerificationState {
  final String email;
  const OtpVerifyInProgress({required this.email});
  @override
  List<Object?> get props => [email];
}

final class OtpVerifySuccess extends OtpVerificationState {
  final String email;
  final bool? wasOnlyVerify;

  const OtpVerifySuccess({required this.email, this.wasOnlyVerify});

  @override
  List<Object?> get props => [email, wasOnlyVerify];
}

final class OtpVerifyFailure extends OtpVerificationState {
  final String email;
  final String message;
  final int? statusCode;
  final bool? wasOnlyVerify;

  const OtpVerifyFailure({
    required this.email,
    required this.message,
    this.statusCode,
    this.wasOnlyVerify,
  });

  @override
  List<Object?> get props => [email, message, statusCode, wasOnlyVerify];
}
