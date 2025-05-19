import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';

class NewPasswordFormWidget extends StatefulWidget {
  final String email;
  final String otp;
  final Function(String newPassword) onSubmit;

  const NewPasswordFormWidget({
    super.key,
    required this.email,
    required this.otp,
    required this.onSubmit,
  });

  @override
  State<NewPasswordFormWidget> createState() => _NewPasswordFormWidgetState();
}

class _NewPasswordFormWidgetState extends State<NewPasswordFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final newPassword = _formKey.currentState?.value['newPassword'] as String;
      widget.onSubmit(newPassword);
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
          Text(
            l10n.newPasswordFormTitleFor(widget.email),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          FormBuilderTextField(
            name: 'newPassword',
            obscureText: !_isNewPasswordVisible,
            decoration: InputDecoration(
              labelText: l10n.newPasswordFormNewLabel,
              hintText: l10n.newPasswordFormNewHint,
              prefixIcon: const Icon(LucideIcons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _isNewPasswordVisible ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppColors.greyTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: l10n.newPasswordFormNewErrorRequired,
              ),
              FormBuilderValidators.minLength(
                8,
                errorText: l10n.registerFormPasswordErrorMinLength,
              ),
              FormBuilderValidators.match(
                RegExp(r'^(?=.*[A-Z])'),
                errorText: l10n.registerFormPasswordErrorUppercase,
              ),
              FormBuilderValidators.match(
                RegExp(r'^(?=.*\d)'),
                errorText: l10n.registerFormPasswordErrorDigit,
              ),
              FormBuilderValidators.match(
                RegExp(r'^(?=.*[!@#\$%^&*()_+={}\[\]:;<>,.?~\\-])'),
                errorText: l10n.registerFormPasswordErrorSpecialChar,
              ),
            ]),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'confirmPassword',
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: l10n.newPasswordFormConfirmLabel,
              hintText: l10n.newPasswordFormConfirmHint,
              prefixIcon: const Icon(LucideIcons.lockKeyhole),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? LucideIcons.eyeOff
                      : LucideIcons.eye,
                  color: AppColors.greyTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: l10n.newPasswordFormConfirmErrorRequired,
              ),
              (val) {
                if (_formKey.currentState?.fields['newPassword']?.value !=
                    val) {
                  return l10n.registerFormConfirmPasswordErrorMismatch;
                }
                return null;
              },
            ]),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitForm(),
          ),
          SizedBox(height: isMobile ? 20 : AppDimensions.largeSpacing * 1.2),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(l10n.newPasswordFormSubmitButton),
          ),
        ],
      ),
    );
  }
}
