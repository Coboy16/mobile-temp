part of 'google_id_token_bloc.dart';

sealed class GoogleIdTokenEvent extends Equatable {
  const GoogleIdTokenEvent();

  @override
  List<Object> get props => [];
}

class FetchGoogleIdToken extends GoogleIdTokenEvent {}
