import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/domain/domain.dart';
import '/core/core.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UpdateUserDetailsUseCase _updateUserDetailsUseCase;

  UpdateUserBloc({required UpdateUserDetailsUseCase updateUserDetailsUseCase})
    : _updateUserDetailsUseCase = updateUserDetailsUseCase,
      super(UpdateUserInitial()) {
    on<UpdateUserDataRequested>(_onUpdateUserDataRequested);
    on<ResetUpdateUserState>(_onResetUpdateUserState);
  }

  Future<void> _onUpdateUserDataRequested(
    UpdateUserDataRequested event,
    Emitter<UpdateUserState> emit,
  ) async {
    emit(UpdateUserLoading());
    final result = await _updateUserDetailsUseCase(
      userId: event.userId,
      name: event.name,
      fatherLastname: event.fatherLastname,
      motherLastname: event.motherLastname,
    );

    result.fold((failure) {
      String message = "Error al actualizar los datos.";
      int? statusCode;
      if (failure is ServerFailure) {
        message = failure.message;
        statusCode = failure.statusCode;
      } else if (failure is NetworkFailure) {
        message = failure.message;
      }
      emit(UpdateUserFailure(message: message, statusCode: statusCode));
    }, (_) => emit(const UpdateUserSuccess()));
  }

  void _onResetUpdateUserState(
    ResetUpdateUserState event,
    Emitter<UpdateUserState> emit,
  ) {
    emit(UpdateUserInitial());
  }
}
