import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/presentation/resources/resources.dart';
import '/presentation/bloc/blocs.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/feactures/auth/views/register_otp_view.dart';
import '/presentation/widgets/widgets.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onGoToLogin;

  const RegisterForm({super.key, required this.onGoToLogin});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _onRequestOtpAttempt() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final email = values['email'] as String;
      context.read<OtpVerificationBloc>().add(
        OtpRequestSubmitted(email: email),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa el formulario correctamente'),
        ),
      );
    }
  }

  void _onGoogleRegisterAttempt() {
    context.read<GoogleIdTokenBloc>().add(FetchGoogleIdToken());
  }

  void _handleOtpRequestState(
    BuildContext context,
    OtpVerificationState otpState,
  ) {
    if (otpState is OtpRequestSuccess) {
      final values = _formKey.currentState!.value;
      context.goNamed(
        AppRoutes.registerOtp,
        extra: RegisterOtpViewArguments(
          email: otpState.email,
          name: values['firstName'] as String,
          fatherLastname: values['paternalLastName'] as String,
          motherLastname: values['maternalLastName'] as String,
          password: values['password'] as String,
        ),
      );
    } else if (otpState is OtpRequestFailure) {
      String dialogMessage = otpState.message;

      if (otpState.statusCode == 401 &&
          otpState.message.toLowerCase().contains("correo no existe")) {
        debugPrint(
          "OTP Request: Correo no existe en BD (401), procediendo a verificación OTP.",
        );
        final values = _formKey.currentState!.value;
        final emailFromForm = values['email'] as String;

        context.goNamed(
          AppRoutes.registerOtp,
          extra: RegisterOtpViewArguments(
            email: emailFromForm,
            name: values['firstName'] as String,
            fatherLastname: values['paternalLastName'] as String,
            motherLastname: values['maternalLastName'] as String,
            password: values['password'] as String,
          ),
        );
        return;
      }
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: dialogMessage),
      );
    }
  }

  void _handleGoogleIdTokenState(
    BuildContext context,
    GoogleIdTokenState googleState,
  ) {
    if (googleState is GoogleIdTokenSuccess) {
      context.read<RegisterBloc>().add(
        RegisterWithGoogleSubmitted(
          email: googleState.email,
          idToken: googleState.idToken,
        ),
      );
    } else if (googleState is GoogleIdTokenFailure) {
      debugPrint('Error obteniendo token de Google: ${googleState.message}');
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: googleState.message),
      );
    } else if (googleState is GoogleIdTokenCancelled) {
      debugPrint('Registro con Google cancelado');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      //TODO: poner un dialog
    }
  }

  void _handleRegisterState(BuildContext context, RegisterState registerState) {
    if (registerState is RegisterSuccess) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registro con Google completado! Iniciando sesión...'),
        ),
      );
    } else if (registerState is RegisterFailure) {
      showDialog(
        context: context,
        builder:
            (_) => RegistrationFailedDialog(message: registerState.message),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width <= 800;
    final InputDecoration baseDecoration = InputDecoration(
      prefixIconConstraints: const BoxConstraints(minWidth: 48),
      suffixIconConstraints: const BoxConstraints(minWidth: 48),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isMobile ? 12 : 16,
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: _handleOtpRequestState,
        ),
        BlocListener<GoogleIdTokenBloc, GoogleIdTokenState>(
          listener: _handleGoogleIdTokenState,
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: _handleRegisterState,
        ),
      ],
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: 'firstName',
              decoration: baseDecoration.copyWith(
                labelText: l10n.registerFormFirstNameLabel,
                hintText: l10n.registerFormFirstNameHint,
                prefixIcon: const Icon(LucideIcons.user),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: l10n.registerFormFirstNameErrorRequired,
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
            FormBuilderTextField(
              name: 'paternalLastName',
              decoration: baseDecoration.copyWith(
                labelText: l10n.registerFormPaternalLastNameLabel,
                hintText: l10n.registerFormPaternalLastNameHint,
                prefixIcon: const Icon(LucideIcons.userCheck),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: l10n.registerFormPaternalLastNameErrorRequired,
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
            FormBuilderTextField(
              name: 'maternalLastName',
              decoration: baseDecoration.copyWith(
                labelText: l10n.registerFormMaternalLastNameLabel,
                hintText: l10n.registerFormMaternalLastNameHint,
                prefixIcon: const Icon(LucideIcons.userCheck),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: l10n.registerFormMaternalLastNameErrorRequired,
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
            FormBuilderTextField(
              name: 'email',
              decoration: baseDecoration.copyWith(
                labelText: l10n.registerFormEmailLabel,
                hintText: l10n.registerFormEmailHint,
                prefixIcon: const Icon(LucideIcons.mail),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: l10n.registerFormEmailErrorRequired,
                ),
                FormBuilderValidators.email(
                  errorText: l10n.registerFormEmailErrorInvalid,
                ),
              ]),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
            FormBuilderTextField(
              name: 'password',
              obscureText: !_isPasswordVisible,
              decoration: baseDecoration.copyWith(
                labelText: l10n.registerFormPasswordLabel,
                hintText: l10n.registerFormPasswordHint,
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
                  errorText: l10n.registerFormPasswordErrorRequired,
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
              decoration: baseDecoration.copyWith(
                labelText: l10n.registerFormConfirmPasswordLabel,
                hintText: l10n.registerFormConfirmPasswordHint,
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
                  errorText: l10n.registerFormConfirmPasswordErrorRequired,
                ),
                (val) {
                  if (_formKey.currentState?.fields['password']?.value != val) {
                    return l10n.registerFormConfirmPasswordErrorMismatch;
                  }
                  return null;
                },
              ]),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onRequestOtpAttempt(),
            ),
            SizedBox(height: isMobile ? 18 : AppDimensions.largeSpacing),
            ElevatedButton(
              onPressed: _onRequestOtpAttempt,
              child: Text(l10n.registerFormContinueButton),
            ),
            SizedBox(height: isMobile ? 8 : AppDimensions.itemSpacing),
            OutlinedButton.icon(
              icon: Image.asset(
                'assets/icons/google.png',
                width: 15,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(LucideIcons.chrome, size: 15),
              ),
              label: Text(
                l10n.registerFormCreateAccountWithGoogleButton,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onPressed: _onGoogleRegisterAttempt,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkTextColor,
                side: BorderSide(color: AppColors.borderColor),
              ),
            ),
            SizedBox(height: isMobile ? 3 : AppDimensions.itemSpacing / 2),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.registerFormAlreadyHaveAccountPrompt,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: widget.onGoToLogin,
                    child: Text(l10n.registerFormLoginButton),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
