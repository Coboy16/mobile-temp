part of 'google_id_token_bloc.dart';

sealed class GoogleIdTokenState extends Equatable {
  const GoogleIdTokenState();

  @override
  List<Object> get props => [];
}

final class GoogleIdTokenInitial extends GoogleIdTokenState {}

final class GoogleIdTokenLoading extends GoogleIdTokenState {}

final class GoogleIdTokenSuccess extends GoogleIdTokenState {
  final String idToken;
  final String email;

  const GoogleIdTokenSuccess({required this.idToken, required this.email});

  @override
  List<Object> get props => [idToken, email];
}

final class GoogleIdTokenFailure extends GoogleIdTokenState {
  final String message;

  const GoogleIdTokenFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class GoogleIdTokenCancelled extends GoogleIdTokenState {}
