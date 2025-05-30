import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'position_change_event.dart';
part 'position_change_state.dart';

class PositionChangeBloc
    extends Bloc<PositionChangeEvent, PositionChangeState> {
  PositionChangeBloc() : super(PositionChangeInitial()) {
    on<SubmitPositionChangeRequest>(_onSubmitPositionChangeRequest);
    on<ResetPositionChangeRequest>(_onResetPositionChangeRequest);
  }

  Future<void> _onSubmitPositionChangeRequest(
    SubmitPositionChangeRequest event,
    Emitter<PositionChangeState> emit,
  ) async {
    try {
      emit(const PositionChangeLoading());

      debugPrint('=== SOLICITUD DE CAMBIO DE POSICIÓN ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint(
        '📅 Fecha de efectividad: ${event.requestData.effectiveDate?.toString() ?? 'No seleccionada'}',
      );
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('======================================');

      await Future.delayed(const Duration(seconds: 1));

      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.effectiveDate == null) {
        throw Exception('Debe seleccionar una fecha de efectividad');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo del cambio de posición es obligatorio');
      }

      emit(PositionChangeSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de cambio de posición: ${e.toString()}');
      emit(PositionChangeFailure(e.toString()));
    }
  }

  void _onResetPositionChangeRequest(
    ResetPositionChangeRequest event,
    Emitter<PositionChangeState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de cambio de posición');
    emit(PositionChangeInitial());
  }
}
