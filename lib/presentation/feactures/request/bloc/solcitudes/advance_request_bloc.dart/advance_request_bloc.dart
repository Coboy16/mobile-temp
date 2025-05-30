import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'advance_request_event.dart';
part 'advance_request_state.dart';

class AdvanceRequestBloc
    extends Bloc<AdvanceRequestEvent, AdvanceRequestState> {
  AdvanceRequestBloc() : super(AdvanceRequestInitial()) {
    on<SubmitAdvanceRequest>(_onSubmitAdvanceRequest);
    on<ResetAdvanceRequest>(_onResetAdvanceRequest);
  }

  Future<void> _onSubmitAdvanceRequest(
    SubmitAdvanceRequest event,
    Emitter<AdvanceRequestState> emit,
  ) async {
    try {
      emit(const AdvanceRequestLoading());

      debugPrint('=== SOLICITUD DE AVANCE ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint(
        '📅 Fecha requerida: ${event.requestData.effectiveDate?.toString() ?? 'No seleccionada'}',
      );
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('==========================');

      await Future.delayed(const Duration(seconds: 1));

      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.effectiveDate == null) {
        throw Exception('Debe seleccionar una fecha requerida');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo del avance es obligatorio');
      }

      emit(AdvanceRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de avance: ${e.toString()}');
      emit(AdvanceRequestFailure(e.toString()));
    }
  }

  void _onResetAdvanceRequest(
    ResetAdvanceRequest event,
    Emitter<AdvanceRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de avance');
    emit(AdvanceRequestInitial());
  }
}
