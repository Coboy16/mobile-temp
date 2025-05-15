part of 'otp_verification_bloc.dart';

sealed class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object> get props => [];
}

class OtpRequestSubmitted extends OtpVerificationEvent {
  final String email;

  const OtpRequestSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}

class OtpCodeSubmitted extends OtpVerificationEvent {
  final String email;
  final String code;

  const OtpCodeSubmitted({required this.email, required this.code});

  @override
  List<Object> get props => [email, code];
}

class OtpVerificationReset extends OtpVerificationEvent {}
