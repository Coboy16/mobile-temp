part of 'vacation_request_bloc.dart';

sealed class VacationRequestEvent extends Equatable {
  const VacationRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitVacationRequest extends VacationRequestEvent {
  final RequestFormData requestData;

  const SubmitVacationRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() => 'SubmitVacationRequest { requestData: $requestData }';
}

class ResetVacationRequest extends VacationRequestEvent {
  const ResetVacationRequest();
}
