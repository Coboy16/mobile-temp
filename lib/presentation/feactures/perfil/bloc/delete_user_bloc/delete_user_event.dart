part of 'delete_user_bloc.dart';

sealed class DeleteUserEvent extends Equatable {
  const DeleteUserEvent();

  @override
  List<Object?> get props => [];
}

class DeleteUserRequested extends DeleteUserEvent {
  final String userId;

  const DeleteUserRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ResetDeleteUserState extends DeleteUserEvent {
  const ResetDeleteUserState();
}
