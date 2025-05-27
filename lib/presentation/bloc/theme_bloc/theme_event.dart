part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final ThemeSetting themeSetting;

  const ChangeTheme(this.themeSetting);

  @override
  List<Object> get props => [themeSetting];
}

class InitializeThemeFromSystem extends ThemeEvent {
  final Brightness systemBrightness;

  const InitializeThemeFromSystem(this.systemBrightness);

  @override
  List<Object> get props => [systemBrightness];
}

class LoadThemeFromPreferences extends ThemeEvent {}

class ResetTheme extends ThemeEvent {}
