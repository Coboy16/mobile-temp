part of 'letter_request_bloc.dart';

sealed class LetterRequestState extends Equatable {
  const LetterRequestState();

  @override
  List<Object> get props => [];
}

final class LetterRequestInitial extends LetterRequestState {}

class LetterRequestLoading extends LetterRequestState {
  const LetterRequestLoading();
}

class LetterRequestSuccess extends LetterRequestState {
  final SimpleRequestData requestData;
  final String message;

  const LetterRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de carta enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];
}

class LetterRequestFailure extends LetterRequestState {
  final String errorMessage;

  const LetterRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
