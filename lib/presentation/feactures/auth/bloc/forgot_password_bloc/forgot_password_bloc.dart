import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/core.dart';
import '/domain/domain.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  ForgotPasswordBloc({
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
  }) : _requestOtpUseCase = requestOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailSubmitted>(_onForgotPasswordEmailSubmitted);
    on<ForgotPasswordOtpSubmitted>(_onForgotPasswordOtpSubmitted);
    on<ForgotPasswordNewPasswordSubmitted>(
      _onForgotPasswordNewPasswordSubmitted,
    );
    on<ForgotPasswordReset>(_onForgotPasswordReset);
  }

  Future<void> _onForgotPasswordEmailSubmitted(
    ForgotPasswordEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordEmailVerificationInProgress(email: event.email));
    final result = await _requestOtpUseCase(
      email: event.email,
      onlyRequest: false,
    );
    result.fold((failure) {
      emit(
        ForgotPasswordEmailVerificationFailure(
          email: event.email,
          message: failure.message,
          statusCode: (failure is ServerFailure) ? failure.statusCode : null,
        ),
      );
    }, (_) => emit(ForgotPasswordEmailVerificationSuccess(email: event.email)));
  }

  Future<void> _onForgotPasswordOtpSubmitted(
    ForgotPasswordOtpSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordOtpVerificationInProgress(email: event.email));
    final result = await _verifyOtpUseCase(
      email: event.email,
      code: event.otp,
      onlyVerify: false,
    );
    result.fold(
      (failure) {
        emit(
          ForgotPasswordOtpVerificationFailure(
            email: event.email,
            message: failure.message,
            statusCode: (failure is ServerFailure) ? failure.statusCode : null,
          ),
        );
      },
      (_) => emit(
        ForgotPasswordOtpVerificationSuccess(
          email: event.email,
          otp: event.otp,
        ),
      ),
    );
  }

  Future<void> _onForgotPasswordNewPasswordSubmitted(
    ForgotPasswordNewPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordChangeInProgress(email: event.email));
    // El OTP no se envía al endpoint de cambio de contraseña según tu definición,
    // pero lo teníamos en el evento por si acaso. Lo quitamos de la llamada al use case.
    final result = await _changePasswordUseCase(
      email: event.email,
      newPassword: event.newPassword,
    );
    result.fold(
      (failure) => emit(
        ForgotPasswordChangeFailure(
          email: event.email,
          message: failure.message,
          // statusCode: (failure is ServerFailure) ? failure.statusCode : null, // Si el Failure del use case lo tiene
        ),
      ),
      (_) => emit(ForgotPasswordChangeSuccess(email: event.email)),
    );
  }

  void _onForgotPasswordReset(
    ForgotPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(ForgotPasswordInitial());
  }
}
