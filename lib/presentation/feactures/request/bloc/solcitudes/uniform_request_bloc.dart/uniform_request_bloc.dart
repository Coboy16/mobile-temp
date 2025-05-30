import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'uniform_request_event.dart';
part 'uniform_request_state.dart';

class UniformRequestBloc
    extends Bloc<UniformRequestEvent, UniformRequestState> {
  UniformRequestBloc() : super(UniformRequestInitial()) {
    on<SubmitUniformRequest>(_onSubmitUniformRequest);
    on<ResetUniformRequest>(_onResetUniformRequest);
  }

  Future<void> _onSubmitUniformRequest(
    SubmitUniformRequest event,
    Emitter<UniformRequestState> emit,
  ) async {
    try {
      emit(const UniformRequestLoading());

      debugPrint('=== SOLICITUD DE UNIFORME ===');
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
      debugPrint('============================');

      await Future.delayed(const Duration(seconds: 1));

      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.effectiveDate == null) {
        throw Exception('Debe seleccionar una fecha requerida');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo de la solicitud de uniforme es obligatorio');
      }

      emit(UniformRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de uniforme: ${e.toString()}');
      emit(UniformRequestFailure(e.toString()));
    }
  }

  void _onResetUniformRequest(
    ResetUniformRequest event,
    Emitter<UniformRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de uniforme');
    emit(UniformRequestInitial());
  }
}
