part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class TabChanged extends SettingsEvent {
  final int tabIndex;

  const TabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
