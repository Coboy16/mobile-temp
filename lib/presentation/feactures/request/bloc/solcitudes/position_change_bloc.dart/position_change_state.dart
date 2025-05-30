part of 'position_change_bloc.dart';

sealed class PositionChangeState extends Equatable {
  const PositionChangeState();

  @override
  List<Object> get props => [];
}

final class PositionChangeInitial extends PositionChangeState {}

class PositionChangeLoading extends PositionChangeState {
  const PositionChangeLoading();
}

class PositionChangeSuccess extends PositionChangeState {
  final SimpleRequestData requestData;
  final String message;

  const PositionChangeSuccess({
    required this.requestData,
    this.message = 'Solicitud de cambio de posición enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'PositionChangeSuccess { requestData: $requestData, message: $message }';
}

class PositionChangeFailure extends PositionChangeState {
  final String errorMessage;

  const PositionChangeFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'PositionChangeFailure { errorMessage: $errorMessage }';
}
