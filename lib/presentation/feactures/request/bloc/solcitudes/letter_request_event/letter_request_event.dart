part of 'letter_request_bloc.dart';

sealed class LetterRequestEvent extends Equatable {
  const LetterRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitLetterRequest extends LetterRequestEvent {
  final SimpleRequestData requestData;

  const SubmitLetterRequest(this.requestData);

  @override
  List<Object> get props => [requestData];
}

class ResetLetterRequest extends LetterRequestEvent {}
