part of 'suspension_request_bloc.dart';

sealed class SuspensionRequestEvent extends Equatable {
  const SuspensionRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitSuspensionRequest extends SuspensionRequestEvent {
  final RequestFormData requestData;

  const SubmitSuspensionRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() => 'SubmitSuspensionRequest { requestData: $requestData }';
}

class ResetSuspensionRequest extends SuspensionRequestEvent {
  const ResetSuspensionRequest();
}
