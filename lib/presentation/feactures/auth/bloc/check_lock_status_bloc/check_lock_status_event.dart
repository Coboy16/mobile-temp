part of 'check_lock_status_bloc.dart';

sealed class CheckLockStatusEvent extends Equatable {
  const CheckLockStatusEvent();

  @override
  List<Object> get props => [];
}

class CheckUserLockStatusRequested extends CheckLockStatusEvent {
  final String email;

  const CheckUserLockStatusRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetCheckLockStatus extends CheckLockStatusEvent {}
