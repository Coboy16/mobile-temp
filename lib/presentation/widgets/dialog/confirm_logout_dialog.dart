import 'package:flutter/material.dart';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  const ConfirmLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.confirmLogoutDialogTitle),
      content: Text(l10n.confirmLogoutDialogMessage),
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(l10n.logoutButtonLabel),
        ),
      ],
    );
  }
}
