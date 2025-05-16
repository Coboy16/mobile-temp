part of 'otp_verification_bloc.dart';

sealed class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class OtpRequestSubmitted extends OtpVerificationEvent {
  final String email;
  final bool? onlyRequest;

  const OtpRequestSubmitted({required this.email, this.onlyRequest});

  @override
  List<Object?> get props => [email, onlyRequest];
}

class OtpCodeSubmitted extends OtpVerificationEvent {
  final String email;
  final String code;
  final bool? onlyVerify;

  const OtpCodeSubmitted({
    required this.email,
    required this.code,
    this.onlyVerify,
  });

  @override
  List<Object?> get props => [email, code, onlyVerify];
}

class OtpVerificationReset extends OtpVerificationEvent {}
