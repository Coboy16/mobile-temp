import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';

import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/resources/resources.dart';

class LeftPanel extends StatelessWidget {
  final AuthView authView;
  const LeftPanel({super.key, required this.authView});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String title;
    String subtitle;
    List<Widget> highlights;

    switch (authView) {
      case AuthView.login:
        title = l10n.leftPanelLoginTitle;
        subtitle = l10n.leftPanelLoginSubtitle;
        highlights = [
          FeatureHighlight(
            icon: LucideIcons.clipboardCheck,
            title: l10n.leftPanelLoginHighlight1Title,
            description: l10n.leftPanelLoginHighlight1Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.users,
            title: l10n.leftPanelLoginHighlight2Title,
            description: l10n.leftPanelLoginHighlight2Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.chartNoAxesColumn,
            title: l10n.leftPanelLoginHighlight3Title,
            description: l10n.leftPanelLoginHighlight3Description,
          ),
        ];
        break;
      case AuthView.register:
        title = l10n.leftPanelRegisterTitle;
        subtitle = l10n.leftPanelRegisterSubtitle;
        highlights = [
          FeatureHighlight(
            icon: LucideIcons.userPlus,
            title: l10n.leftPanelRegisterHighlight1Title,
            description: l10n.leftPanelRegisterHighlight1Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.shieldCheck,
            title: l10n.leftPanelRegisterHighlight2Title,
            description: l10n.leftPanelRegisterHighlight2Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.layoutDashboard,
            title: l10n.leftPanelRegisterHighlight3Title,
            description: l10n.leftPanelRegisterHighlight3Description,
          ),
        ];
        break;
      case AuthView.forgotPasswordEmail:
      case AuthView.forgotPasswordOtp:
        title = l10n.leftPanelForgotPasswordTitle;
        subtitle = l10n.leftPanelForgotPasswordSubtitle;
        highlights = [
          FeatureHighlight(
            icon: LucideIcons.mailQuestion,
            title: l10n.leftPanelForgotPasswordHighlight1Title,
            description: l10n.leftPanelForgotPasswordHighlight1Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.keyRound,
            title: l10n.leftPanelForgotPasswordHighlight2Title,
            description: l10n.leftPanelForgotPasswordHighlight2Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.lockKeyhole,
            title: l10n.leftPanelForgotPasswordHighlight3Title,
            description: l10n.leftPanelForgotPasswordHighlight3Description,
          ),
        ];
        break;
      case AuthView.setNewPassword:
        title = l10n.leftPanelSetNewPasswordTitle;
        subtitle = l10n.leftPanelSetNewPasswordSubtitle;
        highlights = [
          FeatureHighlight(
            icon: LucideIcons.keySquare,
            title: l10n.leftPanelSetNewPasswordHighlight1Title,
            description: l10n.leftPanelSetNewPasswordHighlight1Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.shieldAlert,
            title: l10n.leftPanelSetNewPasswordHighlight2Title,
            description: l10n.leftPanelSetNewPasswordHighlight2Description,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FeatureHighlight(
            icon: LucideIcons.circleCheck,
            title: l10n.leftPanelSetNewPasswordHighlight3Title,
            description: l10n.leftPanelSetNewPasswordHighlight3Description,
          ),
        ];
        break;
    }

    return Container(
      color: AppColors.primaryBlue,
      padding: const EdgeInsets.all(AppDimensions.panelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconCenterWidget(),
          SizedBox(height: AppDimensions.largeSpacing * 1.5),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.itemSpacing / 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.largeSpacing * 1.5),
          ...highlights,
          const Spacer(),
        ],
      ),
    );
  }
}
