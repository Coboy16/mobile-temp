import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/presentation/bloc/blocs.dart';
import '../views/account_view.dart';
import '../views/appearance_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(
      context,
    ).smallerOrEqualTo(MOBILE);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : 40.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _buildHeader(context, localizations, theme),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _buildTabs(context, localizations, theme, isMobile),
              ),
              const SizedBox(height: 10),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black87),
              label: Text(
                localizations.backButton,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.settingsTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              localizations.settingsSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    bool isMobile,
  ) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ToggleButtons(
            isSelected: [
              state.selectedTabIndex == 0,
              state.selectedTabIndex == 1,
              state.selectedTabIndex == 2,
            ],
            onPressed: (index) {
              context.read<SettingsBloc>().add(TabChanged(index));
            },
            borderRadius: BorderRadius.circular(8.0),
            selectedColor: theme.primaryColorDark,
            color: Colors.grey[700],
            fillColor: Colors.white,
            splashColor: theme.primaryColor.withOpacity(0.12),
            hoverColor: theme.primaryColor.withOpacity(0.04),
            constraints: BoxConstraints(
              minHeight: 40.0,
              minWidth: isMobile ? 100.0 : 150.0,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  localizations.accountTab,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  localizations.appearanceTab,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Seguridad',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child:
              state.selectedTabIndex == 0
                  ? const AccountView(key: ValueKey('accountView'))
                  : const AppearanceView(key: ValueKey('appearanceView')),
        );
      },
    );
  }
}
