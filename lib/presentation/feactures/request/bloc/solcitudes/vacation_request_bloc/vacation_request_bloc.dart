import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'vacation_request_event.dart';
part 'vacation_request_state.dart';

class VacationRequestBloc
    extends Bloc<VacationRequestEvent, VacationRequestState> {
  VacationRequestBloc() : super(VacationRequestInitial()) {
    on<SubmitVacationRequest>(_onSubmitVacationRequest);
    on<ResetVacationRequest>(_onResetVacationRequest);
  }

  Future<void> _onSubmitVacationRequest(
    SubmitVacationRequest event,
    Emitter<VacationRequestState> emit,
  ) async {
    try {
      emit(const VacationRequestLoading());

      // Imprimir información detallada de la solicitud
      debugPrint('=== SOLICITUD DE VACACIONES ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint(
        '📅 Fecha de inicio: ${event.requestData.startDate?.toString() ?? 'No seleccionada'}',
      );
      debugPrint(
        '🗓️ Cantidad de días: ${event.requestData.numberOfDays ?? 'No especificada'}',
      );
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('===========================');

      // Simular proceso de envío (puedes reemplazar con tu lógica de API)
      await Future.delayed(const Duration(seconds: 1));

      // Simular validaciones específicas para vacaciones
      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.startDate == null) {
        throw Exception('Debe seleccionar una fecha de inicio');
      }
      if (event.requestData.numberOfDays == null ||
          event.requestData.numberOfDays! <= 0) {
        throw Exception('Debe especificar la cantidad de días');
      }

      emit(VacationRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de vacaciones: ${e.toString()}');
      emit(VacationRequestFailure(e.toString()));
    }
  }

  void _onResetVacationRequest(
    ResetVacationRequest event,
    Emitter<VacationRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de vacaciones');
    emit(const VacationRequestInitial());
  }
}
