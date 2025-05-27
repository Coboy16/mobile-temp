import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/domain/domain.dart';
import '/core/core.dart';

part 'delete_user_event.dart';
part 'delete_user_state.dart';

class DeleteUserBloc extends Bloc<DeleteUserEvent, DeleteUserState> {
  final DeleteUserUseCase _deleteUserUseCase;

  DeleteUserBloc({required DeleteUserUseCase deleteUserUseCase})
    : _deleteUserUseCase = deleteUserUseCase,
      super(DeleteUserInitial()) {
    on<DeleteUserRequested>(_onDeleteUserRequested);
    on<ResetDeleteUserState>(_onResetDeleteUserState);
  }

  Future<void> _onDeleteUserRequested(
    DeleteUserRequested event,
    Emitter<DeleteUserState> emit,
  ) async {
    emit(DeleteUserLoading());
    final result = await _deleteUserUseCase(userId: event.userId);

    result.fold((failure) {
      if (failure is SessionExpiredFailure) {
        emit(DeleteUserSessionExpired(message: failure.message));
      } else {
        String message = "Error al eliminar el usuario.";
        int? statusCode;
        if (failure is ServerFailure) {
          message = failure.message;
          statusCode = failure.statusCode;
        } else if (failure is NetworkFailure) {
          message = failure.message;
        } else if (failure.message.isNotEmpty) {
          message = failure.message;
        }
        emit(DeleteUserFailure(message: message, statusCode: statusCode));
      }
    }, (_) => emit(const DeleteUserSuccess()));
  }

  void _onResetDeleteUserState(
    ResetDeleteUserState event,
    Emitter<DeleteUserState> emit,
  ) {
    emit(DeleteUserInitial());
  }
}
