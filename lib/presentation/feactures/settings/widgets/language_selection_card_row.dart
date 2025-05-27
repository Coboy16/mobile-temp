import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/presentation/bloc/locale_bloc/locale_bloc.dart';

class LanguageSelectionCardRow extends StatelessWidget {
  const LanguageSelectionCardRow({super.key});

  String _getLanguageName(BuildContext context, Locale locale) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return locale.languageCode.toUpperCase();

    switch (locale.languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'es':
        return l10n.languageSpanish;
      case 'fr':
        return l10n.languageFrench;
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  String _getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'assets/flags/usa.svg';
      case 'es':
        return 'assets/flags/spain.svg';
      case 'fr':
        return 'assets/flags/france.svg';
      default:
        return 'assets/flags/usa.svg'; // Fallback
    }
  }

  /// Determina el idioma actual basándose en el contexto y el bloc
  Locale _getCurrentLocale(BuildContext context) {
    // 1. Intentar obtener del bloc
    final localeFromBloc = context.read<LocaleBloc>().state.locale;
    if (localeFromBloc != null) {
      return localeFromBloc;
    }

    // 2. Fallback al locale del sistema si está soportado
    final systemLocale = Localizations.localeOf(context);
    final supportedLocales = AppLocalizations.supportedLocales;

    // Verificar si el idioma del sistema está soportado
    final matchingLocale = supportedLocales.firstWhere(
      (supportedLocale) =>
          supportedLocale.languageCode == systemLocale.languageCode,
      orElse:
          () => supportedLocales.first, // Fallback al primer idioma soportado
    );

    return matchingLocale;
  }

  Widget _buildLanguageOptionCardWrapper({
    required BuildContext context,
    required String flagAssetPath,
    required Locale locale,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const Color primaryColor = Color(0xFF007AFF);
    final Color unselectedTextColor = Colors.grey.shade700;
    final Color selectedTextColor = primaryColor;
    final Color borderColor = Colors.grey.shade300;
    final Color selectedBorderColor = primaryColor;
    final Color cardBackgroundColor =
        isSelected ? primaryColor.withOpacity(0.05) : Colors.white;

    Widget cardContent = Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: isSelected ? selectedBorderColor : borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG Flag Icon
              Container(
                width: 32,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: SvgPicture.asset(
                    flagAssetPath,
                    width: 32,
                    height: 24,
                    fit: BoxFit.cover,
                    // Fallback en caso de error
                    placeholderBuilder:
                        (context) => Container(
                          width: 32,
                          height: 24,
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.flag,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              AutoSizeText(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: 10,
              ),
            ],
          ),
        ),
      ),
    );
    return _LanguageCardRenderWidget(locale: locale, child: cardContent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        final localeBloc = BlocProvider.of<LocaleBloc>(context, listen: false);
        final currentLocale = _getCurrentLocale(context);
        final List<Locale> supportedLocales = AppLocalizations.supportedLocales;

        if (supportedLocales.isEmpty) {
          return const SizedBox.shrink();
        }

        List<Widget> languageCards =
            supportedLocales.map((locale) {
              final isSelected =
                  locale.languageCode == currentLocale.languageCode;
              return _buildLanguageOptionCardWrapper(
                context: context,
                flagAssetPath: _getLanguageFlag(locale),
                locale: locale,
                label: _getLanguageName(context, locale),
                isSelected: isSelected,
                onTap: () {
                  if (!isSelected) {
                    localeBloc.add(ChangeLocale(locale));
                  }
                },
              );
            }).toList();

        List<Widget> rowChildren = [];
        for (int i = 0; i < languageCards.length; i++) {
          rowChildren.add(languageCards[i]);
          if (i < languageCards.length - 1) {
            rowChildren.add(const SizedBox(width: 12.0));
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        );
      },
    );
  }
}

class _LanguageCardRenderWidget extends StatelessWidget {
  final Widget child;
  final Locale locale;

  const _LanguageCardRenderWidget({required this.child, required this.locale});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
