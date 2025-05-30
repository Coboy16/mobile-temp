part of 'tip_change_bloc.dart';

sealed class TipChangeState extends Equatable {
  const TipChangeState();

  @override
  List<Object> get props => [];
}

final class TipChangeInitial extends TipChangeState {}

class TipChangeLoading extends TipChangeState {
  const TipChangeLoading();
}

class TipChangeSuccess extends TipChangeState {
  final SimpleRequestData requestData;
  final String message;

  const TipChangeSuccess({
    required this.requestData,
    this.message = 'Solicitud de cambio de propina enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'TipChangeSuccess { requestData: $requestData, message: $message }';
}

class TipChangeFailure extends TipChangeState {
  final String errorMessage;

  const TipChangeFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'TipChangeFailure { errorMessage: $errorMessage }';
}
