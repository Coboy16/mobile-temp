part of 'update_user_bloc.dart';

sealed class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object?> get props => [];
}

final class UpdateUserInitial extends UpdateUserState {}

final class UpdateUserLoading extends UpdateUserState {}

final class UpdateUserSuccess extends UpdateUserState {
  final String message;
  const UpdateUserSuccess({this.message = "Datos actualizados correctamente."});

  @override
  List<Object?> get props => [message];
}

final class UpdateUserFailure extends UpdateUserState {
  final String message;
  final int? statusCode;

  const UpdateUserFailure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
