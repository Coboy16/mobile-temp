import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'schedule_change_event.dart';
part 'schedule_change_state.dart';

class ScheduleChangeBloc
    extends Bloc<ScheduleChangeEvent, ScheduleChangeState> {
  ScheduleChangeBloc() : super(ScheduleChangeInitial()) {
    on<SubmitScheduleChangeRequest>(_onSubmitScheduleChangeRequest);
    on<ResetScheduleChangeRequest>(_onResetScheduleChangeRequest);
  }

  Future<void> _onSubmitScheduleChangeRequest(
    SubmitScheduleChangeRequest event,
    Emitter<ScheduleChangeState> emit,
  ) async {
    try {
      emit(const ScheduleChangeLoading());

      // Imprimir información detallada de la solicitud
      debugPrint('=== SOLICITUD DE CAMBIO DE HORARIO ===');
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
      debugPrint('=====================================');

      // Simular proceso de envío
      await Future.delayed(const Duration(seconds: 1));

      // Validaciones específicas para cambio de horario
      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.effectiveDate == null) {
        throw Exception('Debe seleccionar una fecha de efectividad');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo del cambio de horario es obligatorio');
      }

      emit(ScheduleChangeSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de cambio de horario: ${e.toString()}');
      emit(ScheduleChangeFailure(e.toString()));
    }
  }

  void _onResetScheduleChangeRequest(
    ResetScheduleChangeRequest event,
    Emitter<ScheduleChangeState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de cambio de horario');
    emit(ScheduleChangeInitial());
  }
}
