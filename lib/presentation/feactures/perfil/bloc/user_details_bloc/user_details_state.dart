part of 'user_details_bloc.dart';

sealed class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object> get props => [];
}

final class UserDetailsInitial extends UserDetailsState {}

final class UserDetailsLoading extends UserDetailsState {}

// Estado cuando se está esperando el ID del LocalUserDataBloc
final class UserDetailsAwaitingId extends UserDetailsState {}

final class UserDetailsLoaded extends UserDetailsState {
  final UserDetailsEntity userDetails;

  const UserDetailsLoaded({required this.userDetails});

  @override
  List<Object> get props => [userDetails];
}

final class UserDetailsFailure extends UserDetailsState {
  final String message;
  final int? statusCode;

  const UserDetailsFailure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}
