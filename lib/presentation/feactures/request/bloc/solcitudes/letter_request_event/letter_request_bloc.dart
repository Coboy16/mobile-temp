import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '/data/data.dart';

part 'letter_request_event.dart';
part 'letter_request_state.dart';

class LetterRequestBloc extends Bloc<LetterRequestEvent, LetterRequestState> {
  LetterRequestBloc() : super(LetterRequestInitial()) {
    on<SubmitLetterRequest>(_onSubmitLetterRequest);
    on<ResetLetterRequest>(_onResetLetterRequest);
  }

  Future<void> _onSubmitLetterRequest(
    SubmitLetterRequest event,
    Emitter<LetterRequestState> emit,
  ) async {
    try {
      emit(const LetterRequestLoading());

      debugPrint('=== SOLICITUD DE CARTA ===');
      debugPrint(
        '📝 Empleado: ${event.requestData.employee?.name ?? 'No seleccionado'}',
      );
      debugPrint(
        '🏷️ Tipo de Carta: ${event.requestData.letterType?.displayName ?? 'No especificado'}',
      );
      debugPrint(
        '👤 Destinatario: ${event.requestData.addressee ?? 'No especificado'}',
      );
      debugPrint(
        '📅 Fecha de Efectividad: ${event.requestData.effectiveDate?.toString() ?? 'No seleccionada'}',
      );
      debugPrint('📝 Motivo: ${event.requestData.reason ?? 'No especificado'}');
      debugPrint(
        '📎 Archivos adjuntos: ${event.requestData.attachments?.length ?? 0}',
      );
      debugPrint('🔗 Datos completos: ${event.requestData.toMap()}');
      debugPrint('=========================');

      // Simular proceso de envío
      await Future.delayed(const Duration(seconds: 1));

      // Validaciones específicas (ya deberían estar en el modal, pero es bueno tenerlas en el BLoC también)
      if (event.requestData.employee == null) {
        throw Exception('Debe seleccionar un empleado.');
      }
      if (event.requestData.letterType == null) {
        throw Exception('Debe seleccionar el tipo de carta.');
      }
      if (event.requestData.addressee == null ||
          event.requestData.addressee!.isEmpty) {
        throw Exception('El destinatario es obligatorio.');
      }
      if (event.requestData.effectiveDate == null) {
        throw Exception('La fecha de efectividad es obligatoria.');
      }
      // Motivo no es estrictamente obligatorio según la UI, pero podría serlo
      // if (event.requestData.reason == null || event.requestData.reason!.isEmpty) {
      //   throw Exception('El motivo de la solicitud es obligatorio.');
      // }

      emit(LetterRequestSuccess(requestData: event.requestData));
    } catch (e) {
      debugPrint('❌ Error en solicitud de carta: ${e.toString()}');
      emit(LetterRequestFailure(e.toString()));
    }
  }

  void _onResetLetterRequest(
    ResetLetterRequest event,
    Emitter<LetterRequestState> emit,
  ) {
    debugPrint('🔄 Reiniciando estado de solicitud de carta');
    emit(LetterRequestInitial());
  }
}
