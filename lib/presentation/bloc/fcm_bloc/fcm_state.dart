part of 'fcm_bloc.dart';

sealed class FcmState extends Equatable {
  const FcmState();

  @override
  List<Object> get props => [];
}

final class FcmInitial extends FcmState {}

class FcmLoading extends FcmState {}

class FcmTokenObtained extends FcmState {
  final String token;

  const FcmTokenObtained(this.token);

  @override
  List<Object> get props => [token];
}

class FcmError extends FcmState {
  final String message;

  const FcmError(this.message);

  @override
  List<Object> get props => [message];
}
