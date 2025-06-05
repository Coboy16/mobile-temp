part of 'exit_request_bloc.dart';

sealed class ExitRequestState extends Equatable {
  const ExitRequestState();

  @override
  List<Object> get props => [];
}

final class ExitRequestInitial extends ExitRequestState {}

class ExitRequestLoading extends ExitRequestState {
  const ExitRequestLoading();
}

class ExitRequestSuccess extends ExitRequestState {
  final SimpleRequestData requestData;
  final String message;
  const ExitRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de salida enviada correctamente',
  });
  @override
  List<Object> get props => [requestData, message];
}

class ExitRequestFailure extends ExitRequestState {
  final String errorMessage;
  const ExitRequestFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
