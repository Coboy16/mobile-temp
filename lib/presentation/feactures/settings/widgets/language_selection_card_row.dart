// lib/widgets/language_selection_card_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/presentation/bloc/locale_bloc/locale_bloc.dart'; // Ajusta esta ruta

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

  IconData _getLanguageIcon(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return LucideIcons.messageSquare;
      case 'es':
        return LucideIcons.languages;
      case 'fr':
        return LucideIcons.globe;
      default:
        return LucideIcons.flag;
    }
  }

  Widget _buildLanguageOptionCardWrapper({
    required BuildContext context,
    required IconData icon,
    required Locale locale,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const Color primaryColor = Color(0xFF007AFF);
    final Color unselectedIconColor = Colors.grey.shade600;
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
              Icon(
                icon,
                size: 26.0,
                color: isSelected ? primaryColor : unselectedIconColor,
              ),
              const SizedBox(height: 6.0),
              AutoSizeText(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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
    final localeBloc = BlocProvider.of<LocaleBloc>(context, listen: false);
    final currentLocale =
        context.watch<LocaleBloc>().state.locale ??
        AppLocalizations.supportedLocales.first;
    final List<Locale> supportedLocales = AppLocalizations.supportedLocales;

    if (supportedLocales.isEmpty) {
      return const SizedBox.shrink();
    }

    List<Widget> languageCards =
        supportedLocales.map((locale) {
          final isSelected = locale == currentLocale;
          return _buildLanguageOptionCardWrapper(
            context: context,
            icon: _getLanguageIcon(locale),
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
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween, // O MainAxisAlignment.start si son pocos
      children: rowChildren,
    );
  }
}

class _LanguageCardRenderWidget extends StatelessWidget {
  final Widget child;
  final Locale
  locale; // Aunque no se use directamente, es para la extensión (si la necesitaras)

  const _LanguageCardRenderWidget({required this.child, required this.locale});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
