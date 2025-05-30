part of 'uniform_request_bloc.dart';

sealed class UniformRequestState extends Equatable {
  const UniformRequestState();

  @override
  List<Object> get props => [];
}

final class UniformRequestInitial extends UniformRequestState {}

class UniformRequestLoading extends UniformRequestState {
  const UniformRequestLoading();
}

class UniformRequestSuccess extends UniformRequestState {
  final SimpleRequestData requestData;
  final String message;

  const UniformRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de uniforme enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'UniformRequestSuccess { requestData: $requestData, message: $message }';
}

class UniformRequestFailure extends UniformRequestState {
  final String errorMessage;

  const UniformRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'UniformRequestFailure { errorMessage: $errorMessage }';
}
