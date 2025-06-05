import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '/data/data.dart';

part 'exit_request_event.dart';
part 'exit_request_state.dart';

class ExitRequestBloc extends Bloc<ExitRequestEvent, ExitRequestState> {
  ExitRequestBloc() : super(ExitRequestInitial()) {
    on<SubmitExitRequest>(_onSubmitExitRequest);
    on<ResetExitRequest>(_onResetExitRequest);
  }

  Future<void> _onSubmitExitRequest(
    SubmitExitRequest event,
    Emitter<ExitRequestState> emit,
  ) async {
    try {
      emit(const ExitRequestLoading());
      debugPrint('=== SOLICITUD DE SALIDA ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint(
        '🏷️ Tipo de Salida: ${event.requestData.exitType?.displayName ?? 'No especificado'}',
      );
      debugPrint(
        '📅 Fecha de Salida: ${event.requestData.effectiveDate?.toString() ?? 'No seleccionada'}',
      ); // Reutilizamos effectiveDate como fecha de salida
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('==========================');

      await Future.delayed(const Duration(seconds: 1));

      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado.');
      }
      if (event.requestData.exitType == null) {
        throw Exception('Debe seleccionar el tipo de salida.');
      }
      if (event.requestData.effectiveDate == null) {
        // effectiveDate es la fecha de salida
        throw Exception('Debe seleccionar la fecha de salida.');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo de la solicitud es obligatorio.');
      }

      emit(ExitRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de salida: ${e.toString()}');
      emit(ExitRequestFailure(e.toString()));
    }
  }

  void _onResetExitRequest(
    ResetExitRequest event,
    Emitter<ExitRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de salida');
    emit(ExitRequestInitial());
  }
}
