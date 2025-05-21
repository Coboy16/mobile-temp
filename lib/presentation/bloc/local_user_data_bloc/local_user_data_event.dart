part of 'local_user_data_bloc.dart';

sealed class LocalUserDataEvent extends Equatable {
  const LocalUserDataEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocalUserData extends LocalUserDataEvent {
  const LoadLocalUserData();
}

class ClearLocalUserData extends LocalUserDataEvent {
  const ClearLocalUserData();
}
