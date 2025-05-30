part of 'advance_request_bloc.dart';

sealed class AdvanceRequestEvent extends Equatable {
  const AdvanceRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitAdvanceRequest extends AdvanceRequestEvent {
  final SimpleRequestData requestData;

  const SubmitAdvanceRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() => 'SubmitAdvanceRequest { requestData: $requestData }';
}

class ResetAdvanceRequest extends AdvanceRequestEvent {
  const ResetAdvanceRequest();
}
