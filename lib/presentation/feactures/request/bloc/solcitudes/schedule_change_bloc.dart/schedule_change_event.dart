part of 'schedule_change_bloc.dart';

sealed class ScheduleChangeEvent extends Equatable {
  const ScheduleChangeEvent();

  @override
  List<Object> get props => [];
}

class SubmitScheduleChangeRequest extends ScheduleChangeEvent {
  final SimpleRequestData requestData;

  const SubmitScheduleChangeRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() =>
      'SubmitScheduleChangeRequest { requestData: $requestData }';
}

class ResetScheduleChangeRequest extends ScheduleChangeEvent {
  const ResetScheduleChangeRequest();
}
