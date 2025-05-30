part of 'tip_change_bloc.dart';

sealed class TipChangeEvent extends Equatable {
  const TipChangeEvent();

  @override
  List<Object> get props => [];
}

class SubmitTipChangeRequest extends TipChangeEvent {
  final SimpleRequestData requestData;

  const SubmitTipChangeRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() => 'SubmitTipChangeRequest { requestData: $requestData }';
}

class ResetTipChangeRequest extends TipChangeEvent {
  const ResetTipChangeRequest();
}
