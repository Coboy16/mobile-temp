part of 'exit_request_bloc.dart';

sealed class ExitRequestEvent extends Equatable {
  const ExitRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitExitRequest extends ExitRequestEvent {
  final SimpleRequestData requestData;
  const SubmitExitRequest(this.requestData);
  @override
  List<Object> get props => [requestData];
}

class ResetExitRequest extends ExitRequestEvent {}
