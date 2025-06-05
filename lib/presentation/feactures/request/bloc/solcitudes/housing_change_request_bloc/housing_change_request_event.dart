part of 'housing_change_request_bloc.dart';

sealed class HousingChangeRequestEvent extends Equatable {
  const HousingChangeRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitHousingChangeRequest extends HousingChangeRequestEvent {
  final SimpleRequestData requestData;
  const SubmitHousingChangeRequest(this.requestData);
  @override
  List<Object> get props => [requestData];
}

class ResetHousingChangeRequest extends HousingChangeRequestEvent {}
