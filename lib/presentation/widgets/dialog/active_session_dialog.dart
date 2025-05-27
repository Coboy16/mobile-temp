import 'package:flutter/material.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';

class ActiveSessionDialog extends StatelessWidget {
  final VoidCallback? onCloseSession;
  final VoidCallback? onKeepSession;

  const ActiveSessionDialog({
    super.key,
    this.onCloseSession,
    this.onKeepSession,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.activeSessionDialogTitle),
      content: Text(l10n.activeSessionDialogMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onKeepSession?.call();
          },
          child: Text(l10n.keepSessionButtonLabel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCloseSession?.call();
          },
          child: Text(l10n.closeSessionButtonLabel),
        ),
      ],
    );
  }
}
