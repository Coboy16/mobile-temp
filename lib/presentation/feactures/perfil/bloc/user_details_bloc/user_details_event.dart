part of 'user_details_bloc.dart';

sealed class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetails extends UserDetailsEvent {
  const FetchUserDetails();
}

// Evento opcional si quieres permitir refrescar con un ID específico
class FetchUserDetailsById extends UserDetailsEvent {
  final String userId;
  const FetchUserDetailsById({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ResetUserDetails extends UserDetailsEvent {
  const ResetUserDetails();
}
