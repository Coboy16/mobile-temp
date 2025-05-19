part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordEmailVerificationInProgress
    extends ForgotPasswordState {
  final String email;
  const ForgotPasswordEmailVerificationInProgress({required this.email});
  @override
  List<Object> get props => [email];
}

final class ForgotPasswordEmailVerificationSuccess extends ForgotPasswordState {
  final String email;
  const ForgotPasswordEmailVerificationSuccess({required this.email});
  @override
  List<Object> get props => [email];
}

final class ForgotPasswordEmailVerificationFailure extends ForgotPasswordState {
  final String email;
  final String message;
  final int? statusCode;
  const ForgotPasswordEmailVerificationFailure({
    required this.email,
    required this.message,
    this.statusCode,
  });
  @override
  List<Object> get props => [email, message, statusCode ?? 0];
}

final class ForgotPasswordOtpVerificationInProgress
    extends ForgotPasswordState {
  final String email;
  const ForgotPasswordOtpVerificationInProgress({required this.email});
  @override
  List<Object> get props => [email];
}

final class ForgotPasswordOtpVerificationSuccess extends ForgotPasswordState {
  final String email;
  final String otp;
  const ForgotPasswordOtpVerificationSuccess({
    required this.email,
    required this.otp,
  });
  @override
  List<Object> get props => [email, otp];
}

final class ForgotPasswordOtpVerificationFailure extends ForgotPasswordState {
  final String email;
  final String message;
  final int? statusCode;
  const ForgotPasswordOtpVerificationFailure({
    required this.email,
    required this.message,
    this.statusCode,
  });
  @override
  List<Object> get props => [email, message, statusCode ?? 0];
}

final class ForgotPasswordChangeInProgress extends ForgotPasswordState {
  final String email;
  const ForgotPasswordChangeInProgress({required this.email});
  @override
  List<Object> get props => [email];
}

final class ForgotPasswordChangeSuccess extends ForgotPasswordState {
  final String email;
  const ForgotPasswordChangeSuccess({required this.email});
  @override
  List<Object> get props => [email];
}

final class ForgotPasswordChangeFailure extends ForgotPasswordState {
  final String email;
  final String message;
  const ForgotPasswordChangeFailure({
    required this.email,
    required this.message,
  });
  @override
  List<Object> get props => [email, message];
}
