part of 'check_session_status_bloc.dart';

sealed class CheckSessionStatusState extends Equatable {
  const CheckSessionStatusState();

  @override
  List<Object> get props => [];
}

final class CheckSessionStatusInitial extends CheckSessionStatusState {}
