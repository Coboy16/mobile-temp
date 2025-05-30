part of 'schedule_change_bloc.dart';

sealed class ScheduleChangeState extends Equatable {
  const ScheduleChangeState();

  @override
  List<Object> get props => [];
}

final class ScheduleChangeInitial extends ScheduleChangeState {}

class ScheduleChangeLoading extends ScheduleChangeState {
  const ScheduleChangeLoading();
}

class ScheduleChangeSuccess extends ScheduleChangeState {
  final SimpleRequestData requestData;
  final String message;

  const ScheduleChangeSuccess({
    required this.requestData,
    this.message = 'Solicitud de cambio de horario enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'ScheduleChangeSuccess { requestData: $requestData, message: $message }';
}

class ScheduleChangeFailure extends ScheduleChangeState {
  final String errorMessage;

  const ScheduleChangeFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'ScheduleChangeFailure { errorMessage: $errorMessage }';
}
