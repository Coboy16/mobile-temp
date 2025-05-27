// import 'dart:io';

import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

import '/presentation/feactures/settings/widgets/widget.dart';
import '/presentation/resources/resources.dart';
import '/presentation/bloc/blocs.dart';

class AppearanceView extends StatelessWidget {
  const AppearanceView({super.key});

  Widget _buildThemeOptionCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const Color primaryColor = AppColors.primaryBlue;
    final Color unselectedIconColor = Colors.grey.shade600;
    final Color unselectedTextColor = Colors.grey.shade700;
    final Color selectedTextColor = primaryColor;
    final Color borderColor = Colors.grey.shade300;
    final Color selectedBorderColor = primaryColor;
    final Color cardBackgroundColor =
        isSelected ? primaryColor.withOpacity(0.05) : Colors.white;

    return Expanded(
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
                size: 30.0,
                color: isSelected ? primaryColor : unselectedIconColor,
              ),
              const SizedBox(height: 6.0),
              AutoSizeText(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                minFontSize: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    final theme = Theme.of(context);

    const TextStyle sectionLabelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color(0xFF343A40),
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.eye,
                  size: 25,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Apariencia",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    AutoSizeText(
                      'Personaliza la apariencia visual del sistema',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text("Tema", style: sectionLabelStyle),
            const SizedBox(height: 12.0),

            // BlocBuilder para reaccionar a cambios de tema
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final themeBloc = BlocProvider.of<ThemeBloc>(
                  context,
                  listen: false,
                );
                final currentTheme = state.themeSetting;

                return Row(
                  children: [
                    _buildThemeOptionCard(
                      icon: LucideIcons.sun,
                      label: "Claro",
                      isSelected: currentTheme == ThemeSetting.light,
                      onTap: () {
                        themeBloc.add(const ChangeTheme(ThemeSetting.light));
                      },
                    ),
                    const SizedBox(width: 12.0),
                    _buildThemeOptionCard(
                      icon: LucideIcons.moon,
                      label: "Oscuro",
                      isSelected: currentTheme == ThemeSetting.dark,
                      onTap: () {
                        themeBloc.add(const ChangeTheme(ThemeSetting.dark));
                      },
                    ),
                    const SizedBox(width: 12.0),
                    _buildThemeOptionCard(
                      icon: LucideIcons.settings,
                      label: "Sistema",
                      isSelected: currentTheme == ThemeSetting.system,
                      onTap: () {
                        themeBloc.add(const ChangeTheme(ThemeSetting.system));
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24.0),
            const Text("Idioma", style: sectionLabelStyle),
            const SizedBox(height: 12.0),
            LanguageSelectionCardRow(),
          ],
        ),
      ),
    );
  }
}
