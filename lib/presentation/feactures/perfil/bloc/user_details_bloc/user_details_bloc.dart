import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '/core/core.dart';
import '/domain/domain.dart';
import '/presentation/bloc/blocs.dart';

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
    on<ResetUserDetails>(_onResetUserDetails);
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    final localUserState = _localUserDataBloc.state;
    if (localUserState is LocalUserDataLoaded) {
      final userId = localUserState.user.id;
      emit(UserDetailsLoading());
      final failureOrUserDetails = await _getUserDetailsUseCase(userId: userId);

      failureOrUserDetails.fold((failure) {
        if (failure is SessionExpiredFailure) {
          emit(UserDetailsSessionExpired(message: failure.message));
        } else {
          emit(_mapFailureToGenericState(failure));
        }
      }, (details) => emit(UserDetailsLoaded(userDetails: details)));
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
    debugPrint(
      'USER DETAILS BLOC - _onFetchUserDetailsById - Fetching by ID: ${event.userId}',
    ); // LOG ID

    final failureOrUserDetails = await _getUserDetailsUseCase(
      userId: event.userId,
    );

    failureOrUserDetails.fold(
      (failure) {
        debugPrint(
          'USER DETAILS BLOC - _onFetchUserDetailsById - Failure Message: ${failure.message}',
        );
        if (failure is ServerFailure) {
          debugPrint(
            'USER DETAILS BLOC - _onFetchUserDetailsById - ServerFailure StatusCode: ${failure.statusCode}',
          );
        }
        // FIN LOG DETALLADO

        if (failure is SessionExpiredFailure) {
          // Esto es un tipo de Failure personalizado que debes haber definido
          emit(UserDetailsSessionExpired(message: failure.message));
        } else {
          emit(
            _mapFailureToGenericState(failure),
          ); // Esto probablemente emite UserDetailsFailure
        }
      },
      (details) {
        debugPrint(
          'USER DETAILS BLOC - _onFetchUserDetailsById - Success. Details: ${details.toString()}',
        ); // O details.toJson() si lo tienes
        emit(UserDetailsLoaded(userDetails: details));
      },
    );
  }

  void _onResetUserDetails(
    ResetUserDetails event,
    Emitter<UserDetailsState> emit,
  ) {
    emit(UserDetailsInitial());
  }

  // Renombrado para claridad
  UserDetailsFailure _mapFailureToGenericState(Failure failure) {
    String message = "Error al cargar detalles del usuario.";
    int? statusCode;

    if (failure is ServerFailure) {
      message = failure.message;
      statusCode = failure.statusCode;
    } else if (failure is NetworkFailure) {
      message = failure.message;
    } else if (failure.message.isNotEmpty) {
      message = failure.message;
    }
    return UserDetailsFailure(message: message, statusCode: statusCode);
  }
}
