part of 'locale_bloc.dart';

class LocaleState extends Equatable {
  final Locale? locale;

  const LocaleState({this.locale});

  factory LocaleState.initial() => const LocaleState();

  @override
  List<Object?> get props => [locale];

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }
}
