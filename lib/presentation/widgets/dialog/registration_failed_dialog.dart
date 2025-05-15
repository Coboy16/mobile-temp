import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationFailedDialog extends StatelessWidget {
  final String message;

  const RegistrationFailedDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.registrationErrorDialogTitle),
      content: Text(message),
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
