part of 'check_lock_status_bloc.dart';

sealed class CheckLockStatusState extends Equatable {
  const CheckLockStatusState();

  @override
  List<Object> get props => [];
}

final class CheckLockStatusInitial extends CheckLockStatusState {}

class CheckLockStatusLoading extends CheckLockStatusState {}

class CheckLockStatusSuccess extends CheckLockStatusState {
  final ValidationResponseEntity validationInfo;

  const CheckLockStatusSuccess({required this.validationInfo});

  @override
  List<Object> get props => [validationInfo];
}

class CheckLockStatusFailure extends CheckLockStatusState {
  final String message;
  final int? statusCode;

  const CheckLockStatusFailure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? ''];
}
