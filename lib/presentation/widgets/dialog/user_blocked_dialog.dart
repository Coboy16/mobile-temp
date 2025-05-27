import 'package:flutter/material.dart';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';

class UserBlockedDialog extends StatelessWidget {
  final int minutesBlocked;
  final String? errorMessage;

  const UserBlockedDialog({
    super.key,
    this.minutesBlocked = 0,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isErrorDialog = errorMessage != null;

    String title;
    String contentText;

    if (isErrorDialog) {
      title = l10n.errorDialogTitle;
      contentText = errorMessage!;
    } else {
      title = l10n.userBlockedDialogTitle;
      contentText =
          minutesBlocked > 0
              ? l10n.userBlockedDialogMessage(minutesBlocked)
              : l10n.userAccountBlockedGeneric;
    }

    return AlertDialog(
      title: Text(title),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          child: Text(l10n.okButtonLabel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
