import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'medical_leave_request_event.dart';
part 'medical_leave_request_state.dart';

class MedicalLeaveRequestBloc
    extends Bloc<MedicalLeaveRequestEvent, MedicalLeaveRequestState> {
  MedicalLeaveRequestBloc() : super(MedicalLeaveRequestInitial()) {
    on<SubmitMedicalLeaveRequest>(_onSubmitMedicalLeaveRequest);
    on<ResetMedicalLeaveRequest>(_onResetMedicalLeaveRequest);
  }

  Future<void> _onSubmitMedicalLeaveRequest(
    SubmitMedicalLeaveRequest event,
    Emitter<MedicalLeaveRequestState> emit,
  ) async {
    try {
      emit(const MedicalLeaveRequestLoading());

      // Imprimir información detallada de la solicitud
      debugPrint('=== SOLICITUD DE LICENCIA MÉDICA ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint(
        '📅 Fecha de inicio: ${event.requestData.startDate?.toString() ?? 'No seleccionada'}',
      );
      debugPrint(
        '🗓️ Cantidad de días: ${event.requestData.numberOfDays ?? 'No especificada'}',
      );
      debugPrint(
        '🏥 Tipo de licencia: ${event.requestData.medicalLicenseType?.displayName ?? 'No especificado'}',
      );
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '🩺 Información médica: ${event.requestData.medicalInfo ?? 'No especificada'}',
      );
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('===================================');

      // Simular proceso de envío
      await Future.delayed(const Duration(seconds: 1));

      // Validaciones específicas para licencia médica
      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.startDate == null) {
        throw Exception('Debe seleccionar una fecha de inicio');
      }
      if (event.requestData.medicalLicenseType == null) {
        throw Exception('Debe seleccionar el tipo de licencia médica');
      }
      if (event.requestData.medicalInfo == null ||
          event.requestData.medicalInfo!.isEmpty) {
        throw Exception('La información médica es obligatoria');
      }

      emit(MedicalLeaveRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de licencia médica: ${e.toString()}');
      emit(MedicalLeaveRequestFailure(e.toString()));
    }
  }

  void _onResetMedicalLeaveRequest(
    ResetMedicalLeaveRequest event,
    Emitter<MedicalLeaveRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de licencia médica');
    emit(const MedicalLeaveRequestInitial());
  }
}
