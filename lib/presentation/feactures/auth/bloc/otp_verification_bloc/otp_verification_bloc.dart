import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/core.dart';
import '/domain/domain.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final RequestOtpUseCase _requestOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  OtpVerificationBloc({
    required RequestOtpUseCase requestOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _requestOtpUseCase = requestOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       super(OtpVerificationInitial()) {
    on<OtpRequestSubmitted>(_onOtpRequestSubmitted);
    on<OtpCodeSubmitted>(_onOtpCodeSubmitted);
    on<OtpVerificationReset>(_onOtpVerificationReset);
  }

  Future<void> _onOtpRequestSubmitted(
    OtpRequestSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpRequestInProgress());
    final result = await _requestOtpUseCase(email: event.email);
    result.fold((failure) {
      emit(
        OtpRequestFailure(
          message: failure.message,
          statusCode: (failure is ServerFailure) ? failure.statusCode : null,
        ),
      );
    }, (_) => emit(OtpRequestSuccess(email: event.email)));
  }

  Future<void> _onOtpCodeSubmitted(
    OtpCodeSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpVerifyInProgress(email: event.email));
    final result = await _verifyOtpUseCase(
      email: event.email,
      code: event.code,
    );
    result.fold((failure) {
      emit(
        OtpVerifyFailure(
          email: event.email,
          message: failure.message,
          statusCode: (failure is ServerFailure) ? failure.statusCode : null,
        ),
      );
    }, (_) => emit(OtpVerifySuccess(email: event.email)));
  }

  void _onOtpVerificationReset(
    OtpVerificationReset event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(OtpVerificationInitial());
  }
}
