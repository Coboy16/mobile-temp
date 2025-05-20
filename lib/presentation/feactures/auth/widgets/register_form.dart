import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

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

  // Variables para Google
  String? _pendingGoogleIdToken;
  String? _pendingGoogleEmail;
  String? _pendingGoogleName;

  // Método para extraer apellidos paterno y materno del campo unificado
  Map<String, String> _extractLastNames(String fullLastNames) {
    final List<String> parts = fullLastNames.trim().split(' ');
    String paternalLastName = '';
    String maternalLastName = '';

    if (parts.isNotEmpty) {
      paternalLastName = parts[0];

      if (parts.length > 1) {
        // Combina el resto de palabras como apellido materno
        maternalLastName = parts.sublist(1).join(' ');
      }
    }

    return {
      'paternalLastName': paternalLastName,
      'maternalLastName': maternalLastName,
    };
  }

  void _initiateRegistrationProcess() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final email = (values['email'] as String).trim();

      // Extraer apellidos del campo unificado
      final String fullLastNames = (values['lastNames'] as String).trim();
      final extractedLastNames = _extractLastNames(fullLastNames);

      // NO modificamos el mapa de valores directamente, solo actualizamos los campos del formulario
      _formKey.currentState!.fields['paternalLastName']?.didChange(
        extractedLastNames['paternalLastName'],
      );
      _formKey.currentState!.fields['maternalLastName']?.didChange(
        extractedLastNames['maternalLastName'],
      );
      _formKey.currentState!.save();

      debugPrint("Apellido paterno: ${extractedLastNames['paternalLastName']}");
      debugPrint("Apellido materno: ${extractedLastNames['maternalLastName']}");

      setState(() {
        _currentStep = RegistrationStep.preVerifyingEmail;
      });
      context.read<OtpVerificationBloc>().add(
        OtpRequestSubmitted(email: email, onlyRequest: false),
      );
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.formValidationCompleteCorrectly,
          ),
        ),
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
    final l10n = AppLocalizations.of(context)!;
    final values = _formKey.currentState?.value;
    final emailFromForm =
        values != null ? (values['email'] as String).trim() : '';

    if (_currentStep == RegistrationStep.preVerifyingEmail) {
      if (otpState is OtpRequestSuccess &&
          otpState.email == emailFromForm &&
          otpState.wasOnlyRequest == false) {
        showDialog(
          context: context,
          builder:
              (_) => RegistrationFailedDialog(
                message: l10n.emailAlreadyRegisteredError,
              ),
        );
        setState(() {
          _currentStep = RegistrationStep.initial;
        });
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
          // Obtenemos los valores actualizados del formulario después de haber hecho didChange y save
          final paternalLastName =
              _formKey.currentState?.fields['paternalLastName']?.value
                  as String? ??
              '';
          final maternalLastName =
              _formKey.currentState?.fields['maternalLastName']?.value
                  as String? ??
              '';

          // Verificación de seguridad: si los campos están vacíos, volvemos a extraer de lastNames
          String finalPaternal = paternalLastName;
          String finalMaternal = maternalLastName;

          if (finalPaternal.isEmpty || finalMaternal.isEmpty) {
            final String fullLastNames = (values['lastNames'] as String).trim();
            final extractedLastNames = _extractLastNames(fullLastNames);
            finalPaternal = extractedLastNames['paternalLastName'] ?? '';
            finalMaternal = extractedLastNames['maternalLastName'] ?? '';
          }

          debugPrint(
            "Enviando al OTP - Paterno: $finalPaternal, Materno: $finalMaternal",
          );

          context.read<OtpVerificationBloc>().add(OtpVerificationReset());
          context.goNamed(
            AppRoutes.registerOtp,
            extra: RegisterOtpViewArguments(
              email: otpState.email,
              name: values['firstName'] as String,
              fatherLastname: finalPaternal,
              motherLastname: finalMaternal,
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
          idToken: googleState.name,
        ),
      );
    } else if (googleState is GoogleIdTokenFailure) {
      debugPrint('Error obteniendo token de Google: ${googleState.message}');
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: googleState.message),
      );
      setState(() {
        _currentStep = RegistrationStep.initial;
        _pendingGoogleIdToken = null;
        _pendingGoogleEmail = null;
        _pendingGoogleName = null;
      });
    } else if (googleState is GoogleIdTokenCancelled) {
      debugPrint('Registro con Google cancelado por el usuario.');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.googleSignInCancelled)));
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
      showDialog(
        context: context,
        builder:
            (_) => RegistrationFailedDialog(message: registerState.message),
      );
      setState(() {
        _currentStep = RegistrationStep.initial;
        _pendingGoogleIdToken = null;
        _pendingGoogleEmail = null;
        _pendingGoogleName = null;
      });
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
            // Campo unificado de apellidos
            FormBuilderTextField(
              name: 'lastNames',
              decoration: baseDecoration.copyWith(
                labelText: 'Apellidos',
                hintText: 'Ingrese sus apellidos',
                prefixIcon: const Icon(LucideIcons.userCheck),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Los apellidos son requeridos',
                ),
              ]),
              textInputAction: TextInputAction.next,
            ),

            // Campos ocultos para mantener la compatibilidad
            SizedBox(
              height: 0,
              child: FormBuilderTextField(
                name: 'paternalLastName',
                initialValue: '',
                enabled: true,
              ),
            ),
            SizedBox(
              height: 0,
              child: FormBuilderTextField(
                name: 'maternalLastName',
                initialValue: '',
                enabled: true,
              ),
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
