part of 'fcm_bloc.dart';

sealed class FcmEvent extends Equatable {
  const FcmEvent();

  @override
  List<Object> get props => [];
}

class FcmGetToken extends FcmEvent {}

class FcmRefreshToken extends FcmEvent {}

class FcmTokenChanged extends FcmEvent {
  final String token;

  const FcmTokenChanged(this.token);

  @override
  List<Object> get props => [token];
}
