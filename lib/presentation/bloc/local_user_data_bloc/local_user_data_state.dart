part of 'local_user_data_bloc.dart';

sealed class LocalUserDataState extends Equatable {
  const LocalUserDataState();

  @override
  List<Object?> get props => [];
}

final class LocalUserDataInitial extends LocalUserDataState {}

final class LocalUserDataLoading extends LocalUserDataState {}

final class LocalUserDataLoaded extends LocalUserDataState {
  final UserEntity user;
  final String token;

  const LocalUserDataLoaded({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

final class NoLocalUserData extends LocalUserDataState {
  final String? message;
  const NoLocalUserData({this.message});

  @override
  List<Object?> get props => [message];
}

final class LocalUserDataCleared extends LocalUserDataState {
  final String? message;
  const LocalUserDataCleared({this.message});

  @override
  List<Object?> get props => [message];
}

final class LocalUserDataFailure extends LocalUserDataState {
  final String message;

  const LocalUserDataFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
