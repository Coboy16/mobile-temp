import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/core.dart';
import '/domain/domain.dart';

part 'check_lock_status_event.dart';
part 'check_lock_status_state.dart';

class CheckLockStatusBloc
    extends Bloc<CheckLockStatusEvent, CheckLockStatusState> {
  final CheckUserLockStatusUseCase _checkUserLockStatusUseCase;

  CheckLockStatusBloc({
    required CheckUserLockStatusUseCase checkUserLockStatusUseCase,
  }) : _checkUserLockStatusUseCase = checkUserLockStatusUseCase,
       super(CheckLockStatusInitial()) {
    on<CheckUserLockStatusRequested>(_onCheckUserLockStatusRequested);
    on<ResetCheckLockStatus>(_onResetCheckLockStatus);
  }

  Future<void> _onCheckUserLockStatusRequested(
    CheckUserLockStatusRequested event,
    Emitter<CheckLockStatusState> emit,
  ) async {
    emit(CheckLockStatusLoading());
    final result = await _checkUserLockStatusUseCase(email: event.email);

    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(
            CheckLockStatusFailure(
              message: failure.message,
              statusCode: failure.statusCode,
            ),
          );
        } else {
          // Para NetworkFailure, CacheFailure u otros
          emit(CheckLockStatusFailure(message: failure.message));
        }
      },
      (validationInfo) {
        emit(CheckLockStatusSuccess(validationInfo: validationInfo));
      },
    );
  }

  void _onResetCheckLockStatus(
    ResetCheckLockStatus event,
    Emitter<CheckLockStatusState> emit,
  ) {
    emit(CheckLockStatusInitial());
  }
}
