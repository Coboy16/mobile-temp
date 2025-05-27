import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';

class ForgotPasswordEmailForm extends StatefulWidget {
  final Function(String email) onEmailSubmitted;
  final VoidCallback onGoToLogin;

  const ForgotPasswordEmailForm({
    super.key,
    required this.onEmailSubmitted,
    required this.onGoToLogin,
  });

  @override
  State<ForgotPasswordEmailForm> createState() =>
      _ForgotPasswordEmailFormState();
}

class _ForgotPasswordEmailFormState extends State<ForgotPasswordEmailForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final email = _formKey.currentState?.value['email'] as String;
      widget.onEmailSubmitted(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width <= 800;

    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(
              labelText: l10n.forgotPasswordEmailFormLabel,
              hintText: l10n.forgotPasswordEmailFormHint,
              prefixIcon: const Icon(LucideIcons.mail),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: l10n.forgotPasswordEmailFormErrorRequired,
              ),
              FormBuilderValidators.email(
                errorText: l10n.forgotPasswordEmailFormErrorInvalid,
              ),
            ]),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitForm(),
          ),
          SizedBox(height: isMobile ? 20 : AppDimensions.largeSpacing * 1.2),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(l10n.forgotPasswordEmailFormSubmitButton),
          ),
          SizedBox(height: isMobile ? 12 : AppDimensions.itemSpacing),
          // Center(
          //   child: TextButton(
          //     onPressed: widget.onGoToLogin,
          //     child: Text(l10n.forgotPasswordEmailFormBackToLoginButton),
          //   ),
          // ),
        ],
      ),
    );
  }
}
