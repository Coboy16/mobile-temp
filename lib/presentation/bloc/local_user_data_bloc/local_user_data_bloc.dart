import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/data/data.dart';
import '/domain/domain.dart';
import '/core/core.dart';

part 'local_user_data_event.dart';
part 'local_user_data_state.dart';

class LocalUserDataBloc extends Bloc<LocalUserDataEvent, LocalUserDataState> {
  final AuthLocalDataSource _authLocalDataSource;

  LocalUserDataBloc({required AuthLocalDataSource authLocalDataSource})
    : _authLocalDataSource = authLocalDataSource,
      super(LocalUserDataInitial()) {
    on<LoadLocalUserData>(_onLoadLocalUserData);
    on<ClearLocalUserData>(_onClearLocalUserData);
  }

  Future<void> _onLoadLocalUserData(
    LoadLocalUserData event,
    Emitter<LocalUserDataState> emit,
  ) async {
    emit(LocalUserDataLoading());
    try {
      final token = await _authLocalDataSource.getToken();
      final userModel = await _authLocalDataSource.getUser();

      if (userModel != null && token != null) {
        emit(LocalUserDataLoaded(user: userModel, token: token));
      } else {
        String message = "No se encontraron datos locales.";
        if (userModel == null && token == null) {
          message = "No se encontraron datos de usuario ni token local.";
        } else if (userModel == null) {
          message = "No se encontraron datos de usuario locales.";
        } else if (token == null) {
          message = "No se encontró token local.";
        }
        emit(NoLocalUserData(message: message));
      }
    } on CacheException catch (e) {
      emit(
        LocalUserDataFailure(
          message: e.message ?? "Error al cargar datos de caché",
        ),
      );
    } catch (e) {
      emit(
        LocalUserDataFailure(
          message: "Error inesperado al cargar datos locales: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onClearLocalUserData(
    ClearLocalUserData event,
    Emitter<LocalUserDataState> emit,
  ) async {
    emit(LocalUserDataLoading());
    try {
      await _authLocalDataSource.clearToken();
      await _authLocalDataSource.clearUser();
      emit(const LocalUserDataCleared(message: "Datos locales eliminados."));
    } on CacheException catch (e) {
      emit(
        LocalUserDataFailure(
          message: e.message ?? "Error al limpiar datos de caché",
        ),
      );
    } catch (e) {
      emit(
        LocalUserDataFailure(
          message: "Error inesperado al limpiar datos locales: ${e.toString()}",
        ),
      );
    }
  }
}
