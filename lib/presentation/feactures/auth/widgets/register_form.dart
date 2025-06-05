import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:toastification/toastification.dart';

import '/presentation/resources/resources.dart';
import '/presentation/bloc/blocs.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/feactures/auth/views/register_otp_view.dart';
import '/presentation/widgets/widgets.dart';

enum RegistrationStep {
  initial,
  preVerifyingEmail,
  requestingOtpForNewEmail,
  processingGoogleRegistration, // Añadido para Google
}

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
  RegistrationStep _currentStep = RegistrationStep.initial;
  bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Variables para Google
  String? _pendingGoogleIdToken;
  String? _pendingGoogleEmail;
  String? _pendingGoogleName;

  void _initiateRegistrationProcess() {
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final email = (values['email'] as String).trim();
      final password = values['password'] as String;
      final confirmPassword = values['confirmPassword'] as String;
      final l10n = AppLocalizations.of(context)!;

      // Validación adicional de contraseñas coincidentes
      if (password != confirmPassword) {
        CustomConfirmationModal.showSimple(
          context: context,
          title: l10n.passwordMismatchTitle,
          subtitle: l10n.passwordMismatchMessage,
          confirmButtonText: l10n.accept,
          confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
          width: 420,
        );
        return; // Salimos sin continuar con el registro
      }

      setState(() {
        _currentStep = RegistrationStep.preVerifyingEmail;
      });
      context.read<OtpVerificationBloc>().add(
        OtpRequestSubmitted(email: email, onlyRequest: false),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(l10n.formValidationErrorTitle),
        description: Text(l10n.formValidationCompleteCorrectly),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
        animationDuration: const Duration(milliseconds: 300),
        showIcon: true,
        showProgressBar: false,
      );
    }
  }

  void _onGoogleRegisterAttempt() {
    if (_currentStep != RegistrationStep.initial &&
        _currentStep != RegistrationStep.preVerifyingEmail &&
        _currentStep != RegistrationStep.requestingOtpForNewEmail) {
      return;
    }
    setState(() {
      _currentStep = RegistrationStep.initial;
      // Limpiamos las variables de Google
      _pendingGoogleIdToken = null;
      _pendingGoogleEmail = null;
      _pendingGoogleName = null;
    });
    context.read<GoogleIdTokenBloc>().add(FetchGoogleIdToken());
  }

  void _handleOtpRequestState(
    BuildContext context,
    OtpVerificationState otpState,
  ) {
    final values = _formKey.currentState?.value;
    final emailFromForm =
        values != null ? (values['email'] as String).trim() : '';

    if (_currentStep == RegistrationStep.preVerifyingEmail) {
      if (otpState is OtpRequestSuccess &&
          otpState.email == emailFromForm &&
          otpState.wasOnlyRequest == false) {
        final l10n = AppLocalizations.of(context)!;

        CustomConfirmationModal.showSimple(
          context: context,
          title: l10n.userAlreadyExistsTitle,
          subtitle: l10n.emailAlreadyRegisteredError,
          confirmButtonText: l10n.accept,
          confirmButtonColor: const Color(
            0xFFF59E0B,
          ), // Amarillo para advertencia
          width: 420,
          onConfirm: () {
            Navigator.of(context).pop();
            setState(() {
              _currentStep = RegistrationStep.initial;
            });
          },
        );
      } else if (otpState is OtpRequestFailure &&
          otpState.email == emailFromForm &&
          otpState.wasOnlyRequest == false) {
        if (otpState.statusCode == 401 ||
            otpState.statusCode == 400 ||
            otpState.statusCode == 404) {
          if (otpState.message.toLowerCase().contains("correo no existe") ||
              otpState.message.toLowerCase().contains("user not found") ||
              otpState.message.toLowerCase().contains(
                "usuario no encontrado",
              )) {
            debugPrint(
              "Pre-verificación: Correo no existe. Solicitando OTP para registro.",
            );
            setState(() {
              _currentStep = RegistrationStep.requestingOtpForNewEmail;
            });
            context.read<OtpVerificationBloc>().add(
              OtpRequestSubmitted(email: emailFromForm, onlyRequest: true),
            );
            return;
          }
        }
        showDialog(
          context: context,
          builder: (_) => RegistrationFailedDialog(message: otpState.message),
        );
        setState(() {
          _currentStep = RegistrationStep.initial;
        });
      }
    } else if (_currentStep == RegistrationStep.requestingOtpForNewEmail) {
      if (otpState is OtpRequestSuccess &&
          otpState.email == emailFromForm &&
          otpState.wasOnlyRequest == true) {
        if (values != null) {
          // Obtenemos los apellidos directamente de los campos del formulario
          final paternalLastName =
              (values['paternalLastName'] as String).trim();
          final maternalLastName =
              (values['maternalLastName'] as String).trim();

          debugPrint(
            "Enviando al OTP - Paterno: $paternalLastName, Materno: $maternalLastName",
          );

          context.read<OtpVerificationBloc>().add(OtpVerificationReset());
          context.goNamed(
            AppRoutes.registerOtp,
            extra: RegisterOtpViewArguments(
              email: otpState.email,
              name: values['firstName'] as String,
              fatherLastname: paternalLastName,
              motherLastname: maternalLastName,
              password: values['password'] as String,
            ),
          );
        }
        setState(() {
          _currentStep = RegistrationStep.initial;
        });
      } else if (otpState is OtpRequestFailure &&
          otpState.email == emailFromForm &&
          otpState.wasOnlyRequest == true) {
        showDialog(
          context: context,
          builder: (_) => RegistrationFailedDialog(message: otpState.message),
        );
        setState(() {
          _currentStep = RegistrationStep.initial;
        });
      }
    }
  }

  void _handleGoogleIdTokenState(
    BuildContext context,
    GoogleIdTokenState googleState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (googleState is GoogleIdTokenSuccess) {
      // Guardamos los tokens y cambiamos el estado
      setState(() {
        _pendingGoogleIdToken = googleState.idToken;
        _pendingGoogleEmail = googleState.email;
        _pendingGoogleName = googleState.name;
        _currentStep = RegistrationStep.processingGoogleRegistration;
      });
      debugPrint('------------');
      debugPrint('GoogleIdTokenBloc - email: ${googleState.email}');
      debugPrint('GoogleIdTokenBloc - name: ${googleState.name}');
      debugPrint('GoogleIdTokenBloc - idToken: ${googleState.idToken}');
      debugPrint('------------');

      context.read<RegisterBloc>().add(
        RegisterWithGoogleSubmitted(
          email: googleState.email,
          idToken: isMobilePlatform ? googleState.name : googleState.idToken,
        ),
      );
    } else if (googleState is GoogleIdTokenFailure) {
      debugPrint('Error obteniendo token de Google: ${googleState.message}');
      CustomConfirmationModal.showSimple(
        context: context,
        title: l10n.registrationErrorTitle,
        subtitle: l10n.registrationErrorMessage,
        confirmButtonText: l10n.accept,
        confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
        width: 420,
        onConfirm: () {
          Navigator.of(context).pop();
          setState(() {
            _currentStep = RegistrationStep.initial;
            _pendingGoogleIdToken = null;
            _pendingGoogleEmail = null;
            _pendingGoogleName = null;
          });
        },
      );
    } else if (googleState is GoogleIdTokenCancelled) {
      debugPrint('Registro con Google cancelado por el usuario.');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      toastification.show(
        context: context,
        type: ToastificationType.info,
        style: ToastificationStyle.minimal,
        title: Text(l10n.googleSignInCancelledTitle),
        description: Text(l10n.googleSignInCancelled),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 300),
        showIcon: true,
        showProgressBar: false,
      );
      setState(() {
        _currentStep = RegistrationStep.initial;
        _pendingGoogleIdToken = null;
        _pendingGoogleEmail = null;
        _pendingGoogleName = null;
      });
    }
  }

  void _handleRegisterState(BuildContext context, RegisterState registerState) {
    final l10n = AppLocalizations.of(context)!;
    if (registerState is RegisterSuccess) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      debugPrint(l10n.registerWithGoogleSuccessMessage);

      // Si estamos en el flujo de Google y tenemos los tokens, finalizamos el login
      if (_currentStep == RegistrationStep.processingGoogleRegistration &&
          _pendingGoogleIdToken != null &&
          _pendingGoogleEmail != null &&
          _pendingGoogleName != null) {
        debugPrint(
          "Registro en backend con Google OK. Iniciando login final con AuthGoogleBloc.",
        );
        debugPrint('------------');
        debugPrint('AUTH - email: ${_pendingGoogleIdToken!}');
        debugPrint('AUTH - idToken: ${_pendingGoogleEmail!}');
        debugPrint('------------');
        context.read<AuthGoogleBloc>().add(
          FinalizeGoogleLoginWithToken(
            idToken: _pendingGoogleIdToken!,
            email: _pendingGoogleEmail!,
          ),
        );
        setState(() {
          _pendingGoogleIdToken = null;
          _pendingGoogleEmail = null;
          _pendingGoogleName = null;
          _currentStep = RegistrationStep.initial;
        });
      } else {
        // Para el flujo tradicional
        setState(() {
          _currentStep = RegistrationStep.initial;
        });
      }
    } else if (registerState is RegisterFailure) {
      // REEMPLAZO: RegistrationFailedDialog por CustomConfirmationModal
      final l10n = AppLocalizations.of(context)!;
      CustomConfirmationModal.showSimple(
        context: context,
        title: l10n.registrationErrorTitle,
        subtitle: l10n.registrationErrorMessage,
        confirmButtonText: l10n.accept,
        confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
        width: 420,
        onConfirm: () {
          Navigator.of(context).pop();
          setState(() {
            _currentStep = RegistrationStep.initial;
            _pendingGoogleIdToken = null;
            _pendingGoogleEmail = null;
            _pendingGoogleName = null;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = ResponsiveBreakpoints.of(context);

    final InputDecoration baseDecoration = InputDecoration(
      prefixIconConstraints: const BoxConstraints(minWidth: 48),
      suffixIconConstraints: const BoxConstraints(minWidth: 48),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: responsive.isMobile ? 12 : 16,
      ),
    );

    final double formFieldSpacing =
        ResponsiveValue<double>(
          context,
          defaultValue: 15, // Desktop
          conditionalValues: [Condition.equals(name: MOBILE, value: 14.0)],
        ).value;

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
            SizedBox(height: formFieldSpacing),

            // Campo para apellido paterno
            FormBuilderTextField(
              name: 'paternalLastName',
              decoration: baseDecoration.copyWith(
                labelText: 'Apellido Paterno',
                hintText: 'Ingrese su apellido paterno',
                prefixIcon: const Icon(LucideIcons.userCheck),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'El apellido paterno es requerido',
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: formFieldSpacing),

            // Campo para apellido materno
            FormBuilderTextField(
              name: 'maternalLastName',
              decoration: baseDecoration.copyWith(
                labelText: 'Apellido Materno',
                hintText: 'Ingrese su apellido materno',
                prefixIcon: const Icon(LucideIcons.userCheck),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'El apellido materno es requerido',
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: formFieldSpacing),

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
            SizedBox(height: formFieldSpacing),
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
            SizedBox(height: formFieldSpacing),
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
              onSubmitted: (_) => _initiateRegistrationProcess(),
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.largeSpacing, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 18.0),
                    ],
                  ).value,
            ),
            ElevatedButton(
              onPressed: _initiateRegistrationProcess,
              child: Text(l10n.registerFormContinueButton),
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
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing / 2, // Desktop
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 3.0),
                    ],
                  ).value,
            ),
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
