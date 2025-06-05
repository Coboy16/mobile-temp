import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'housing_change_request_event.dart';
part 'housing_change_request_state.dart';

class HousingChangeRequestBloc
    extends Bloc<HousingChangeRequestEvent, HousingChangeRequestState> {
  HousingChangeRequestBloc() : super(HousingChangeRequestInitial()) {
    on<SubmitHousingChangeRequest>(_onSubmitHousingChangeRequest);
    on<ResetHousingChangeRequest>(_onResetHousingChangeRequest);
  }

  Future<void> _onSubmitHousingChangeRequest(
    SubmitHousingChangeRequest event,
    Emitter<HousingChangeRequestState> emit,
  ) async {
    try {
      emit(const HousingChangeRequestLoading());
      debugPrint('=== SOLICITUD DE CAMBIO DE ALOJAMIENTO ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('=========================================');

      await Future.delayed(const Duration(seconds: 1));

      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado.');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo de la solicitud es obligatorio.');
      }

      emit(HousingChangeRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint(
        '❌ Error en solicitud de cambio de alojamiento: ${e.toString()}',
      );
      emit(HousingChangeRequestFailure(e.toString()));
    }
  }

  void _onResetHousingChangeRequest(
    ResetHousingChangeRequest event,
    Emitter<HousingChangeRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de cambio de alojamiento');
    emit(HousingChangeRequestInitial());
  }
}
