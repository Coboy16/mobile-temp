import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/widgets/widgets.dart';
import '/presentation/resources/resources.dart';
import '/presentation/bloc/blocs.dart';

class LoginForm extends StatefulWidget {
  final void Function()? onGoogleLogin;
  final void Function(String email, String passOrCedula)? onLogin;
  final VoidCallback onGoToRegister;
  final VoidCallback onGoToForgotPassword;

  const LoginForm({
    super.key,
    this.onGoogleLogin,
    this.onLogin,
    required this.onGoToRegister,
    required this.onGoToForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;

  void _onLoginAttempt() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final username =
          _formKey.currentState?.fields['username']?.value as String;
      context.read<CheckLockStatusBloc>().add(
        CheckUserLockStatusRequested(email: username.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = ResponsiveBreakpoints.of(context);

    return BlocListener<CheckLockStatusBloc, CheckLockStatusState>(
      listener: (context, state) {
        if (state is CheckLockStatusSuccess) {
          if (state.validationInfo.isBlocked) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => UserBlockedDialog(
                    minutesBlocked: state.validationInfo.minutesBlocked,
                  ),
            );
          } else {
            final username =
                _formKey.currentState?.fields['username']?.value as String;
            final password =
                _formKey.currentState?.fields['password']?.value as String;
            widget.onLogin?.call(username.trim(), password);
          }
        } else if (state is CheckLockStatusFailure) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => UserBlockedDialog(errorMessage: state.message),
          );
        }
      },
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: 'username',
              decoration: InputDecoration(
                labelText: l10n.loginFormUsernameLabel,
                hintText: l10n.loginFormUsernameHint,
                prefixIcon: const Icon(LucideIcons.user),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: l10n.loginFormUsernameErrorRequired,
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 14.0),
                    ],
                  ).value,
            ),
            FormBuilderTextField(
              name: 'password',
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: l10n.loginFormPasswordLabel,
                hintText: l10n.loginFormPasswordHint,
                prefixIcon: const Icon(LucideIcons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? LucideIcons.eyeOff : LucideIcons.eye,
                    color: AppColors.greyTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: l10n.loginFormPasswordErrorRequired,
                ),
                FormBuilderValidators.minLength(
                  6,
                  errorText: l10n.loginFormPasswordErrorMinLength,
                ),
              ]),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onLoginAttempt(),
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing / 2, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 0),
                    ],
                  ).value,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding:
                      responsive.isMobile
                          ? const EdgeInsets.symmetric(vertical: 8.0)
                          : null,
                  overlayColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: widget.onGoToForgotPassword,
                child: Text(l10n.loginFormForgotPasswordButton),
              ),
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.largeSpacing, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 4.0),
                    ],
                  ).value,
            ),
            ElevatedButton(
              onPressed: _onLoginAttempt,
              child: Text(l10n.loginFormLoginButton),
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 8.0),
                    ],
                  ).value,
            ),
            if (widget.onGoogleLogin != null)
              OutlinedButton.icon(
                icon: Image.asset(
                  'assets/icons/google.png',
                  width: 15,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(LucideIcons.chrome, size: 15),
                ),
                label: Text(
                  l10n.loginFormLoginWithGoogleButton,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onPressed: widget.onGoogleLogin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkTextColor,
                  side: BorderSide(color: AppColors.borderColor),
                ),
              ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing / 2, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 10.0),
                    ],
                  ).value,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4.0,
              runSpacing: 0,
              children: [
                Text(
                  l10n.loginFormNoAccountPrompt,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: widget.onGoToRegister,
                  child: Text(l10n.loginFormCreateAccountButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
