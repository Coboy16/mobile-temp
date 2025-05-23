import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_core_vips/core/core.dart';
import 'package:fe_core_vips/domain/domain.dart';
import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:flutter/material.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetUserDetailsUseCase _getUserDetailsUseCase;
  final LocalUserDataBloc _localUserDataBloc;

  UserDetailsBloc({
    required GetUserDetailsUseCase getUserDetailsUseCase,
    required LocalUserDataBloc localUserDataBloc,
  }) : _getUserDetailsUseCase = getUserDetailsUseCase,
       _localUserDataBloc = localUserDataBloc,
       super(UserDetailsInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
    on<FetchUserDetailsById>(_onFetchUserDetailsById);
    on<ResetUserDetails>(
      _onResetUserDetails,
    ); // Nuevo evento para limpiar el estado
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    // Accedemos al estado actual de LocalUserDataBloc
    final localUserState = _localUserDataBloc.state;

    if (localUserState is LocalUserDataLoaded) {
      final userId = localUserState.user.id;
      debugPrint("_-----------------------");
      debugPrint("ID de usuario local: $userId");
      debugPrint("_-----------------------");

      emit(UserDetailsLoading());
      final failureOrUserDetails = await _getUserDetailsUseCase(userId: userId);

      failureOrUserDetails.fold(
        (failure) => emit(_mapFailureToState(failure)),
        (details) => emit(UserDetailsLoaded(userDetails: details)),
      );
    } else {
      emit(
        const UserDetailsFailure(
          message:
              "ID de usuario local no disponible. Asegúrate de haber iniciado sesión.",
        ),
      );
    }
  }

  Future<void> _onFetchUserDetailsById(
    FetchUserDetailsById event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());
    final failureOrUserDetails = await _getUserDetailsUseCase(
      userId: event.userId,
    );

    failureOrUserDetails.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (details) => emit(UserDetailsLoaded(userDetails: details)),
    );
  }

  void _onResetUserDetails(
    ResetUserDetails event,
    Emitter<UserDetailsState> emit,
  ) {
    emit(UserDetailsInitial());
  }

  UserDetailsFailure _mapFailureToState(Failure failure) {
    String message = "Error al cargar detalles del usuario.";
    int? statusCode;
    if (failure is ServerFailure) {
      message = failure.message;
      statusCode = failure.statusCode;
    } else if (failure is NetworkFailure) {
      message = failure.message;
    }
    return UserDetailsFailure(message: message, statusCode: statusCode);
  }
}
