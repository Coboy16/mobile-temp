import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState.initial()) {
    on<ChangeLocale>(_onChangeLocale);
    on<ClearLocale>(_onClearLocale);
    on<InitializeLocaleFromSystem>(_onInitializeLocaleFromSystem);
  }

  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  void _onChangeLocale(ChangeLocale event, Emitter<LocaleState> emit) {
    emit(state.copyWith(locale: event.locale));
  }

  void _onClearLocale(ClearLocale event, Emitter<LocaleState> emit) {
    emit(const LocaleState());
  }

  void _onInitializeLocaleFromSystem(
    InitializeLocaleFromSystem event,
    Emitter<LocaleState> emit,
  ) {
    if (state.locale == null) {
      final systemLocale = event.systemLocale;
      final supportedLocales = AppLocalizations.supportedLocales;

      final matchingLocale = supportedLocales.firstWhere(
        (supportedLocale) =>
            supportedLocale.languageCode == systemLocale.languageCode,
        orElse: () => supportedLocales.first,
      );

      emit(state.copyWith(locale: matchingLocale));
    }
  }
}
