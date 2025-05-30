import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';

part 'tip_change_event.dart';
part 'tip_change_state.dart';

class TipChangeBloc extends Bloc<TipChangeEvent, TipChangeState> {
  TipChangeBloc() : super(TipChangeInitial()) {
    on<SubmitTipChangeRequest>(_onSubmitTipChangeRequest);
    on<ResetTipChangeRequest>(_onResetTipChangeRequest);
  }

  Future<void> _onSubmitTipChangeRequest(
    SubmitTipChangeRequest event,
    Emitter<TipChangeState> emit,
  ) async {
    try {
      emit(const TipChangeLoading());

      debugPrint('=== SOLICITUD DE CAMBIO DE PROPINA ===');
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

      await Future.delayed(const Duration(seconds: 1));

      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado');
      }
      if (event.requestData.effectiveDate == null) {
        throw Exception('Debe seleccionar una fecha de efectividad');
      }
      if (event.requestData.reason == null ||
          event.requestData.reason!.isEmpty) {
        throw Exception('El motivo del cambio de propina es obligatorio');
      }

      emit(TipChangeSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de cambio de propina: ${e.toString()}');
      emit(TipChangeFailure(e.toString()));
    }
  }

  void _onResetTipChangeRequest(
    ResetTipChangeRequest event,
    Emitter<TipChangeState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de cambio de propina');
    emit(TipChangeInitial());
  }
}
