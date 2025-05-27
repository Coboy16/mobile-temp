import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

enum ThemeSetting { light, dark, system }

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'theme_setting';

  ThemeBloc() : super(ThemeState.initial()) {
    on<ChangeTheme>(_onChangeTheme);
    on<InitializeThemeFromSystem>(_onInitializeThemeFromSystem);
    on<LoadThemeFromPreferences>(_onLoadThemeFromPreferences);
    on<ResetTheme>(_onResetTheme);

    // Cargar tema guardado al inicializar
    add(LoadThemeFromPreferences());
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeSetting: event.themeSetting));
    await _saveThemePreference(event.themeSetting);
  }

  void _onInitializeThemeFromSystem(
    InitializeThemeFromSystem event,
    Emitter<ThemeState> emit,
  ) {
    // Solo inicializar si no hay un tema ya establecido
    if (state.themeSetting == ThemeSetting.system) {
      final brightness = event.systemBrightness;
      final themeSetting =
          brightness == Brightness.dark
              ? ThemeSetting.dark
              : ThemeSetting.light;

      emit(state.copyWith(themeSetting: themeSetting));
    }
  }

  Future<void> _onLoadThemeFromPreferences(
    LoadThemeFromPreferences event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themePreferenceKey);

      if (themeString != null) {
        final themeSetting = _stringToThemeSetting(themeString);
        emit(state.copyWith(themeSetting: themeSetting));
      }
      // Si no hay preferencia guardada, mantiene el valor inicial (system)
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      // En caso de error, mantiene el tema por defecto
    }
  }

  Future<void> _onResetTheme(ResetTheme event, Emitter<ThemeState> emit) async {
    emit(ThemeState.initial());
    await _clearThemePreference();
  }

  /// Guarda la preferencia de tema en SharedPreferences
  Future<void> _saveThemePreference(ThemeSetting themeSetting) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _themePreferenceKey,
        _themeSettingToString(themeSetting),
      );
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Elimina la preferencia de tema guardada
  Future<void> _clearThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themePreferenceKey);
    } catch (e) {
      debugPrint('Error clearing theme preference: $e');
    }
  }

  /// Convierte ThemeSetting a String para guardado
  String _themeSettingToString(ThemeSetting themeSetting) {
    switch (themeSetting) {
      case ThemeSetting.light:
        return 'light';
      case ThemeSetting.dark:
        return 'dark';
      case ThemeSetting.system:
        return 'system';
    }
  }

  /// Convierte String a ThemeSetting para carga
  ThemeSetting _stringToThemeSetting(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeSetting.light;
      case 'dark':
        return ThemeSetting.dark;
      case 'system':
        return ThemeSetting.system;
      default:
        return ThemeSetting.system; // Fallback
    }
  }

  /// Convierte ThemeSetting a ThemeMode para MaterialApp
  ThemeMode get themeMode {
    switch (state.themeSetting) {
      case ThemeSetting.light:
        return ThemeMode.light;
      case ThemeSetting.dark:
        return ThemeMode.dark;
      case ThemeSetting.system:
        return ThemeMode.system;
    }
  }
}
