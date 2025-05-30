part of 'position_change_bloc.dart';

sealed class PositionChangeEvent extends Equatable {
  const PositionChangeEvent();

  @override
  List<Object> get props => [];
}

class SubmitPositionChangeRequest extends PositionChangeEvent {
  final SimpleRequestData requestData;

  const SubmitPositionChangeRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() =>
      'SubmitPositionChangeRequest { requestData: $requestData }';
}

class ResetPositionChangeRequest extends PositionChangeEvent {
  const ResetPositionChangeRequest();
}
