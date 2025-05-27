part of 'delete_user_bloc.dart';

sealed class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object?> get props => [];
}

final class DeleteUserInitial extends DeleteUserState {}

final class DeleteUserLoading extends DeleteUserState {}

final class DeleteUserSuccess extends DeleteUserState {
  final String message;
  const DeleteUserSuccess({this.message = "Usuario eliminado correctamente."});

  @override
  List<Object?> get props => [message];
}

final class DeleteUserFailure extends DeleteUserState {
  final String message;
  final int? statusCode;

  const DeleteUserFailure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

final class DeleteUserSessionExpired extends DeleteUserState {
  final String message;
  const DeleteUserSessionExpired({required this.message});
  @override
  List<Object?> get props => [message];
}
