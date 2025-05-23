part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final int selectedTabIndex;

  const SettingsState({this.selectedTabIndex = 0});

  SettingsState copyWith({int? selectedTabIndex}) {
    return SettingsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object> get props => [selectedTabIndex];
}
