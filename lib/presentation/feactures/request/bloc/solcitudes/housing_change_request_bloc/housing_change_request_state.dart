part of 'housing_change_request_bloc.dart';

sealed class HousingChangeRequestState extends Equatable {
  const HousingChangeRequestState();

  @override
  List<Object> get props => [];
}

final class HousingChangeRequestInitial extends HousingChangeRequestState {}

class HousingChangeRequestLoading extends HousingChangeRequestState {
  const HousingChangeRequestLoading();
}

class HousingChangeRequestSuccess extends HousingChangeRequestState {
  final SimpleRequestData requestData;
  final String message;
  const HousingChangeRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de cambio de alojamiento enviada correctamente',
  });
  @override
  List<Object> get props => [requestData, message];
}

class HousingChangeRequestFailure extends HousingChangeRequestState {
  final String errorMessage;
  const HousingChangeRequestFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
