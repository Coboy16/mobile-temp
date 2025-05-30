part of 'vacation_request_bloc.dart';

sealed class VacationRequestState extends Equatable {
  const VacationRequestState();

  @override
  List<Object> get props => [];
}

class VacationRequestInitial extends VacationRequestState {
  const VacationRequestInitial();
}

class VacationRequestLoading extends VacationRequestState {
  const VacationRequestLoading();
}

class VacationRequestSuccess extends VacationRequestState {
  final RequestFormData requestData;
  final String message;

  const VacationRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de vacaciones enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'VacationRequestSuccess { requestData: $requestData, message: $message }';
}

class VacationRequestFailure extends VacationRequestState {
  final String errorMessage;

  const VacationRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'VacationRequestFailure { errorMessage: $errorMessage }';
}
