part of 'check_session_status_bloc.dart';

sealed class CheckSessionStatusEvent extends Equatable {
  const CheckSessionStatusEvent();

  @override
  List<Object> get props => [];
}

class CheckSessionStatusRequested extends CheckSessionStatusEvent {
  final String email;

  const CheckSessionStatusRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetCheckSessionStatus extends CheckSessionStatusEvent {}

final class CheckSessionStatusLoading extends CheckSessionStatusState {}

final class CheckSessionStatusLoaded extends CheckSessionStatusState {
  final SessionStatusEntity sessionStatus;

  const CheckSessionStatusLoaded({required this.sessionStatus});

  @override
  List<Object> get props => [sessionStatus];

  bool get hasActiveSession => sessionStatus.hasActiveSession;
}

final class CheckSessionStatusFailure extends CheckSessionStatusState {
  final String message;
  final int? statusCode;

  const CheckSessionStatusFailure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}
