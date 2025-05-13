import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'fcm_event.dart';
part 'fcm_state.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription? _tokenSubscription;
  FcmBloc() : super(FcmInitial()) {
    on<FcmGetToken>(_onGetToken);
    on<FcmRefreshToken>(_onRefreshToken);
    on<FcmTokenChanged>(_onTokenChanged);

    // Escuchar cambios en el token automáticamente
    _tokenSubscription = _firebaseMessaging.onTokenRefresh.listen((token) {
      add(FcmTokenChanged(token));
    });
  }

  Future<void> _onGetToken(FcmGetToken event, Emitter<FcmState> emit) async {
    try {
      emit(FcmLoading());

      // Solicitar permisos para notificaciones (requerido en iOS)
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(alert: true, badge: true, sound: true);

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Obtener el token FCM
        final token = await _firebaseMessaging.getToken();

        if (token != null) {
          emit(FcmTokenObtained(token));
          debugPrint('Token FCM: $token');
        } else {
          emit(const FcmError('No se pudo obtener el token FCM'));
        }
      } else {
        emit(const FcmError('Permisos de notificación denegados'));
      }
    } catch (e) {
      emit(FcmError('Error al obtener el token FCM: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshToken(
    FcmRefreshToken event,
    Emitter<FcmState> emit,
  ) async {
    try {
      emit(FcmLoading());
      await _firebaseMessaging.deleteToken();
      final token = await _firebaseMessaging.getToken();

      if (token != null) {
        emit(FcmTokenObtained(token));
      } else {
        emit(const FcmError('No se pudo refrescar el token FCM'));
      }
    } catch (e) {
      emit(FcmError('Error al refrescar el token FCM: ${e.toString()}'));
    }
  }

  void _onTokenChanged(FcmTokenChanged event, Emitter<FcmState> emit) {
    emit(FcmTokenObtained(event.token));
  }

  @override
  Future<void> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }
}
