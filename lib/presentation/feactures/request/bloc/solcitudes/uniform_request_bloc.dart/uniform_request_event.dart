part of 'uniform_request_bloc.dart';

sealed class UniformRequestEvent extends Equatable {
  const UniformRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitUniformRequest extends UniformRequestEvent {
  final SimpleRequestData requestData;

  const SubmitUniformRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() => 'SubmitUniformRequest { requestData: $requestData }';
}

class ResetUniformRequest extends UniformRequestEvent {
  const ResetUniformRequest();
}
