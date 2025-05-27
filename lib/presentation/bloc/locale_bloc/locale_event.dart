part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class ChangeLocale extends LocaleEvent {
  final Locale locale;

  const ChangeLocale(this.locale);

  @override
  List<Object> get props => [locale];
}

class ClearLocale extends LocaleEvent {}

class InitializeLocaleFromSystem extends LocaleEvent {
  final Locale systemLocale;

  const InitializeLocaleFromSystem(this.systemLocale);

  @override
  List<Object> get props => [systemLocale];
}
