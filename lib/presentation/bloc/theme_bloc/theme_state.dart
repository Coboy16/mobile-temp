part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeSetting themeSetting;

  const ThemeState({required this.themeSetting});

  factory ThemeState.initial() =>
      const ThemeState(themeSetting: ThemeSetting.system);

  @override
  List<Object> get props => [themeSetting];

  ThemeState copyWith({ThemeSetting? themeSetting}) {
    return ThemeState(themeSetting: themeSetting ?? this.themeSetting);
  }
}
