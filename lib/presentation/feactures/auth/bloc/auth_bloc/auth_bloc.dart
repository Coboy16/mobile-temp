import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/domain/domain.dart';
import '/core/core.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ValidateUserUseCase _validateUserUseCase;
  final LoginUserUseCase _loginUserUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;

  AuthBloc({
    required ValidateUserUseCase validateUserUseCase,
    required LoginUserUseCase loginUserUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUserUseCase logoutUserUseCase,
  }) : _validateUserUseCase = validateUserUseCase,
       _loginUserUseCase = loginUserUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _logoutUserUseCase = logoutUserUseCase,
       super(AuthInitial()) {
    on<AuthCheckStatusRequested>(_onAuthCheckStatusRequested);
    on<AuthValidateUserRequested>(_onAuthValidateUserRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await _getCurrentUserUseCase();
    failureOrUser.fold(
      (failure) => emit(
        AuthUnauthenticated(message: _mapFailureToMessage(failure)),
      ), // O AuthFailure si prefieres
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthValidateUserRequested(
    AuthValidateUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthValidationInProgress());
    final failureOrValidationResponse = await _validateUserUseCase(
      email: event.email,
    );
    failureOrValidationResponse.fold(
      (failure) => emit(
        AuthFailure(
          message: _mapFailureToMessage(failure),
          statusCode: (failure is ServerFailure) ? failure.statusCode : null,
        ),
      ),
      (validationResponse) =>
          emit(AuthValidationSuccess(validationResponse: validationResponse)),
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await _loginUserUseCase(
      email: event.email,
      cedulaOrPassword: event.cedulaOrPassword,
    );
    failureOrUser.fold(
      (failure) => emit(
        AuthFailure(
          message: _mapFailureToMessage(failure),
          statusCode: (failure is ServerFailure) ? failure.statusCode : null,
        ),
      ),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    String? userEmail;

    if (currentState is AuthAuthenticated) {
      userEmail = currentState.user.email;
    } else {
      final failureOrUser = await _getCurrentUserUseCase();
      final potentialUser = failureOrUser.getOrElse(() => null);
      if (potentialUser != null) {
        userEmail = potentialUser.email;
      } else {
        emit(
          const AuthFailure(
            message: "No se pudo determinar el usuario para cerrar sesión.",
          ),
        );
        return;
      }
    }

    if (userEmail.isEmpty) {
      emit(
        const AuthFailure(
          message: "Email de usuario no encontrado para cerrar sesión.",
        ),
      );
      return;
    }

    emit(AuthLoading());

    final failureOrSuccess = await _logoutUserUseCase(userEmail);

    failureOrSuccess.fold(
      (failure) => emit(AuthFailure(message: _mapFailureToMessage(failure))),
      (_) => emit(
        const AuthUnauthenticated(message: "Sesión cerrada correctamente"),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message;
      case CacheFailure _:
        return failure.message;
      case NetworkFailure _:
        return failure.message;
      default:
        return 'Ocurrió un error inesperado: ${failure.message}';
    }
  }
}
