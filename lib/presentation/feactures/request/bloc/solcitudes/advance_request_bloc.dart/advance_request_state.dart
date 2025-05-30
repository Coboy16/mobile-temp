part of 'advance_request_bloc.dart';

sealed class AdvanceRequestState extends Equatable {
  const AdvanceRequestState();

  @override
  List<Object> get props => [];
}

final class AdvanceRequestInitial extends AdvanceRequestState {}

class AdvanceRequestLoading extends AdvanceRequestState {
  const AdvanceRequestLoading();
}

class AdvanceRequestSuccess extends AdvanceRequestState {
  final SimpleRequestData requestData;
  final String message;

  const AdvanceRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de avance enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'AdvanceRequestSuccess { requestData: $requestData, message: $message }';
}

class AdvanceRequestFailure extends AdvanceRequestState {
  final String errorMessage;

  const AdvanceRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'AdvanceRequestFailure { errorMessage: $errorMessage }';
}
