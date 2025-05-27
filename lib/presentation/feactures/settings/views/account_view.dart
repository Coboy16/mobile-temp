import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/perfil/perfil.dart';
import '/presentation/resources/colors.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(isMobilePlatform ? 10.0 : 20.0),
      child: Container(
        padding: EdgeInsets.all(isMobilePlatform ? 10.0 : 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Icon(LucideIcons.user, color: AppColors.primaryBlue),
                  const SizedBox(width: 10),
                  AutoSizeText(
                    localizations.userInfoTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: AutoSizeText(
                localizations.userInfoSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[800],
                ),
                maxLines: 2,
              ),
            ),
            PerfilScreen(),
          ],
        ),
      ),
    );
  }
}
