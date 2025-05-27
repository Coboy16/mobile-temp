import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:fe_core_vips/core/core.dart';
import 'package:fe_core_vips/domain/domain.dart';
import 'package:flutter/foundation.dart';

part 'check_session_status_event.dart';
part 'check_session_status_state.dart';

class CheckSessionStatusBloc
    extends Bloc<CheckSessionStatusEvent, CheckSessionStatusState> {
  final CheckSessionStatusUseCase _checkSessionStatusUseCase;

  CheckSessionStatusBloc({
    required CheckSessionStatusUseCase checkSessionStatusUseCase,
  }) : _checkSessionStatusUseCase = checkSessionStatusUseCase,
       super(CheckSessionStatusInitial()) {
    on<CheckSessionStatusRequested>(_onCheckSessionStatusRequested);
    on<ResetCheckSessionStatus>(_onResetCheckSessionStatus);
  }

  Future<void> _onCheckSessionStatusRequested(
    CheckSessionStatusRequested event,
    Emitter<CheckSessionStatusState> emit,
  ) async {
    debugPrint(
      'Evento recibido: CheckSessionStatusRequested con email: ${event.email}',
    );
    emit(CheckSessionStatusLoading());

    final failureOrSessionStatus = await _checkSessionStatusUseCase(
      email: event.email,
    );

    debugPrint(
      'Resultado de _checkSessionStatusUseCase: $failureOrSessionStatus',
    );

    failureOrSessionStatus.fold(
      (failure) {
        debugPrint('Fallo detectado: $failure');

        if (failure is ServerFailure) {
          debugPrint(
            'Fallo del servidor con mensaje: ${failure.message}, código: ${failure.statusCode}',
          );
          emit(
            CheckSessionStatusFailure(
              message: failure.message,
              statusCode: failure.statusCode,
            ),
          );
        } else if (failure is NetworkFailure) {
          debugPrint('Fallo de red con mensaje: ${failure.message}');
          emit(CheckSessionStatusFailure(message: failure.message));
        } else {
          debugPrint('Otro tipo de fallo con mensaje: ${failure.message}');
          emit(CheckSessionStatusFailure(message: failure.message));
        }
      },
      (sessionStatus) {
        debugPrint('Estado de sesión recibido: $sessionStatus');
        emit(CheckSessionStatusLoaded(sessionStatus: sessionStatus));
      },
    );
  }

  void _onResetCheckSessionStatus(
    ResetCheckSessionStatus event,
    Emitter<CheckSessionStatusState> emit,
  ) {
    emit(CheckSessionStatusInitial());
  }
}
