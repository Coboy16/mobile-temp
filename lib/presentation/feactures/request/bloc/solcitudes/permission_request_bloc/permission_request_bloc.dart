import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'permission_request_event.dart';
part 'permission_request_state.dart';

class PermissionRequestBloc
    extends Bloc<PermissionRequestEvent, PermissionRequestState> {
  PermissionRequestBloc() : super(PermissionRequestInitial()) {
    on<SubmitPermissionRequest>(_onSubmitPermissionRequest);
    on<ResetPermissionRequest>(_onResetPermissionRequest);
  }
  Future<void> _onSubmitPermissionRequest(
    SubmitPermissionRequest event,
    Emitter<PermissionRequestState> emit,
  ) async {
    try {
      emit(const PermissionRequestLoading());

      // Imprimir información detallada de la solicitud
      debugPrint('=== SOLICITUD DE PERMISO ===');
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

      // Simular proceso de envío
      await Future.delayed(const Duration(seconds: 1));

      // Validaciones específicas para permisos
      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.startDate == null) {
        throw Exception('Debe seleccionar una fecha de inicio');
      }

      emit(PermissionRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de permiso: ${e.toString()}');
      emit(PermissionRequestFailure(e.toString()));
    }
  }

  void _onResetPermissionRequest(
    ResetPermissionRequest event,
    Emitter<PermissionRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de permiso');
    emit(const PermissionRequestInitial());
  }
}
