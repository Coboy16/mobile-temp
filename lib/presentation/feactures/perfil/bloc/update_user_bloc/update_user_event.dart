part of 'update_user_bloc.dart';

sealed class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserDataRequested extends UpdateUserEvent {
  final String userId;
  final String name;
  final String fatherLastname;
  final String motherLastname;

  const UpdateUserDataRequested({
    required this.userId,
    required this.name,
    required this.fatherLastname,
    required this.motherLastname,
  });

  @override
  List<Object?> get props => [userId, name, fatherLastname, motherLastname];
}

class ResetUpdateUserState extends UpdateUserEvent {
  const ResetUpdateUserState();
}
