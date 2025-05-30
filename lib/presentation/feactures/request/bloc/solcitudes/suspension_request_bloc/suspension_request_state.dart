part of 'suspension_request_bloc.dart';

sealed class SuspensionRequestState extends Equatable {
  const SuspensionRequestState();

  @override
  List<Object> get props => [];
}

class SuspensionRequestInitial extends SuspensionRequestState {
  const SuspensionRequestInitial();
}

class SuspensionRequestLoading extends SuspensionRequestState {
  const SuspensionRequestLoading();
}

class SuspensionRequestSuccess extends SuspensionRequestState {
  final RequestFormData requestData;
  final String message;

  const SuspensionRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de suspensión enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'SuspensionRequestSuccess { requestData: $requestData, message: $message }';
}

class SuspensionRequestFailure extends SuspensionRequestState {
  final String errorMessage;

  const SuspensionRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() =>
      'SuspensionRequestFailure { errorMessage: $errorMessage }';
}
