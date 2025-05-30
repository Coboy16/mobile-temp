import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'suspension_request_event.dart';
part 'suspension_request_state.dart';

class SuspensionRequestBloc
    extends Bloc<SuspensionRequestEvent, SuspensionRequestState> {
  SuspensionRequestBloc() : super(SuspensionRequestInitial()) {
    on<SubmitSuspensionRequest>(_onSubmitSuspensionRequest);
    on<ResetSuspensionRequest>(_onResetSuspensionRequest);
  }

  Future<void> _onSubmitSuspensionRequest(
    SubmitSuspensionRequest event,
    Emitter<SuspensionRequestState> emit,
  ) async {
    try {
      emit(const SuspensionRequestLoading());

      // Imprimir información detallada de la solicitud
      debugPrint('=== SOLICITUD DE SUSPENSIÓN ===');
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
      debugPrint('==============================');

      // Simular proceso de envío
      await Future.delayed(const Duration(seconds: 1));

      // Validaciones específicas para suspensión
      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.startDate == null) {
        throw Exception('Debe seleccionar una fecha de inicio');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo de suspensión es obligatorio');
      }

      emit(SuspensionRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de suspensión: ${e.toString()}');
      emit(SuspensionRequestFailure(e.toString()));
    }
  }

  void _onResetSuspensionRequest(
    ResetSuspensionRequest event,
    Emitter<SuspensionRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de suspensión');
    emit(const SuspensionRequestInitial());
  }
}
