import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/core.dart';
import '/domain/domain.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase _registerUserUseCase;
  final RegisterWithGoogleUseCase _registerWithGoogleUseCase;

  RegisterBloc({
    required RegisterUserUseCase registerUserUseCase,
    required RegisterWithGoogleUseCase registerWithGoogleUseCase,
  }) : _registerUserUseCase = registerUserUseCase,
       _registerWithGoogleUseCase = registerWithGoogleUseCase,
       super(RegisterInitial()) {
    on<RegisterUserSubmitted>(_onRegisterUserSubmitted);
    on<RegisterWithGoogleSubmitted>(_onRegisterWithGoogleSubmitted);
  }

  Future<void> _onRegisterUserSubmitted(
    RegisterUserSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final result = await _registerUserUseCase(
      name: event.name,
      fatherLastname: event.fatherLastname,
      motherLastname: event.motherLastname,
      email: event.email,
      password: event.password,
    );

    result.fold((failure) {
      emit(_mapFailureToState(failure, "Error durante el registro."));
    }, (_) => emit(RegisterSuccess()));
  }

  Future<void> _onRegisterWithGoogleSubmitted(
    RegisterWithGoogleSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final result = await _registerWithGoogleUseCase(
      email: event.email,
      idToken: event.idToken,
    );

    result.fold((failure) {
      emit(
        _mapFailureToState(failure, "Error durante el registro con Google."),
      );
    }, (_) => emit(RegisterSuccess()));
  }

  RegisterFailure _mapFailureToState(Failure failure, String defaultMessage) {
    String errorMessage = defaultMessage;
    int? statusCode;
    if (failure is ServerFailure) {
      errorMessage = failure.message;
      statusCode = failure.statusCode;
    } else if (failure is NetworkFailure) {
      errorMessage = failure.message;
    }
    return RegisterFailure(message: errorMessage, statusCode: statusCode);
  }
}
