import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/widgets/widgets.dart';
import '/presentation/resources/resources.dart';
import '/presentation/bloc/blocs.dart';

// Estados del flujo de login
enum LoginStep {
  initial,
  verifyingEmailExists,
  attemptingLogin,
  performingSecurityChecks,
}

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

  // Estados para coordinar todos los checks
  bool emailVerificationCompleted = false;
  bool _loginAttemptCompleted = false;
  bool _lockCheckCompleted = false;
  bool _sessionCheckCompleted = false;
  bool _canFinishLogin = false;
  bool _isCheckingStatus = false;

  // Estado para el flujo de login
  LoginStep _currentLoginStep = LoginStep.initial;

  // Variables para almacenar credenciales durante el flujo
  String? _pendingEmail;
  String? _pendingPassword;

  void _onLoginAttempt() {
    debugPrint("🚀 Iniciando intento de login...");

    // Validar y guardar el formulario
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      debugPrint("❌ Formulario no válido - validación falló");
      return;
    }

    // Obtener referencias a los campos de forma segura
    final formState = _formKey.currentState;
    if (formState == null) {
      debugPrint("❌ Error: FormState es null");
      return;
    }

    final usernameField = formState.fields['username'];
    final passwordField = formState.fields['password'];

    if (usernameField == null || passwordField == null) {
      debugPrint("❌ Error: Campos del formulario no encontrados");
      return;
    }

    // Obtener valores de forma segura
    final usernameValue = usernameField.value;
    final passwordValue = passwordField.value;

    // Verificar que los valores no sean null
    if (usernameValue == null || passwordValue == null) {
      debugPrint("❌ Error: Valores del formulario son null");
      return;
    }

    // Convertir a String de forma segura
    final username = usernameValue.toString().trim();
    final password = passwordValue.toString();

    // Verificar que no estén vacíos después de la conversión
    if (username.isEmpty || password.isEmpty) {
      debugPrint("❌ Error: Email o contraseña están vacíos");
      return;
    }

    debugPrint(
      "✅ Datos del formulario válidos: email='$username', password='[***]'",
    );

    // Reset de todos los estados ANTES de almacenar credenciales
    _resetAllChecks();

    // Almacenar credenciales para usar después
    _pendingEmail = username;
    _pendingPassword = password;

    // Verificar que se almacenaron correctamente
    if (_pendingEmail == null || _pendingPassword == null) {
      debugPrint("❌ Error: Fallo al almacenar credenciales");
      return;
    }

    setState(() {
      _currentLoginStep = LoginStep.verifyingEmailExists;
      _isCheckingStatus = true;
    });

    debugPrint("🔍 PASO 1: Verificando si el email '$_pendingEmail' existe...");

    // PASO 1: Verificar si el email existe antes de hacer login
    try {
      context.read<OtpVerificationBloc>().add(
        OtpRequestSubmitted(email: _pendingEmail!, onlyRequest: false),
      );
    } catch (e) {
      debugPrint("❌ Error al enviar OtpRequestSubmitted: $e");
      _resetAllAndClearCredentials();
    }
  }

  // PASO 2: Proceder con el login real después de verificar email
  void _proceedWithLogin() {
    if (_pendingEmail != null &&
        _pendingPassword != null &&
        _pendingEmail!.isNotEmpty &&
        _pendingPassword!.isNotEmpty) {
      setState(() {
        _currentLoginStep = LoginStep.attemptingLogin;
        emailVerificationCompleted = true;
      });

      debugPrint("🔐 PASO 2: Email verificado. Procediendo con login real...");
      // Hacer el login real con las credenciales
      widget.onLogin?.call(_pendingEmail!, _pendingPassword!);
      _resetAllAndClearCredentials();
    } else {
      debugPrint("❌ Error: Credenciales pendientes inválidas");
      _resetAllAndClearCredentials();
    }
  }

  // PASO 3: Proceder con checks de seguridad después de login exitoso
  void _proceedWithSecurityChecks() {
    if (_pendingEmail != null && _pendingEmail!.isNotEmpty) {
      setState(() {
        _currentLoginStep = LoginStep.performingSecurityChecks;
        _loginAttemptCompleted = true;
      });

      debugPrint("🛡️ PASO 3: Login exitoso. Iniciando checks de seguridad...");
      context.read<CheckLockStatusBloc>().add(
        CheckUserLockStatusRequested(email: _pendingEmail!),
      );
      context.read<CheckSessionStatusBloc>().add(
        CheckSessionStatusRequested(email: _pendingEmail!),
      );
    } else {
      debugPrint("❌ Error: Email pendiente inválido para checks de seguridad");
      _resetAllAndClearCredentials();
    }
  }

  void _checkIfCanFinishLogin() {
    if (_loginAttemptCompleted &&
        _lockCheckCompleted &&
        _sessionCheckCompleted &&
        _canFinishLogin) {
      debugPrint(
        "✅ Todos los checks completados. Login finalizado correctamente.",
      );
      setState(() {
        _isCheckingStatus = false;
        _currentLoginStep = LoginStep.initial;
      });
      // Limpiar credenciales después del login exitoso
      _pendingEmail = null;
      _pendingPassword = null;
      // El login se completa automáticamente por AuthBloc
    }
  }

  void _resetAllChecks() {
    debugPrint("🔄 Reseteando todos los checks...");
    setState(() {
      emailVerificationCompleted = false;
      _loginAttemptCompleted = false;
      _lockCheckCompleted = false;
      _sessionCheckCompleted = false;
      _canFinishLogin = false;
      _isCheckingStatus = false;
      _currentLoginStep = LoginStep.initial;
    });

    // NO limpiar credenciales pendientes aquí - se limpiarán al final
    // _pendingEmail = null;
    // _pendingPassword = null;

    // Reset de todos los blocs
    context.read<OtpVerificationBloc>().add(OtpVerificationReset());
    context.read<CheckLockStatusBloc>().add(ResetCheckLockStatus());
    context.read<CheckSessionStatusBloc>().add(ResetCheckSessionStatus());
  }

  void _resetAllAndClearCredentials() {
    debugPrint("🔄 Reseteando completamente y limpiando credenciales...");
    setState(() {
      emailVerificationCompleted = false;
      _loginAttemptCompleted = false;
      _lockCheckCompleted = false;
      _sessionCheckCompleted = false;
      _canFinishLogin = false;
      _isCheckingStatus = false;
      _currentLoginStep = LoginStep.initial;
    });

    // Limpiar credenciales pendientes
    _pendingEmail = null;
    _pendingPassword = null;

    // Reset de todos los blocs
    context.read<OtpVerificationBloc>().add(OtpVerificationReset());
    context.read<CheckLockStatusBloc>().add(ResetCheckLockStatus());
    context.read<CheckSessionStatusBloc>().add(ResetCheckSessionStatus());
  }

  /// Maneja el caso cuando el usuario no existe en la plataforma
  void _handleUserNotFound(String email) {
    CustomConfirmationModal.show(
      context: context,
      title: "Usuario no encontrado",
      subtitle:
          "Usuario no existe, ¿desea registrarse en nuestra plataforma Ho-tech del Caribe?",
      confirmButtonText: "Registrarme",
      cancelButtonText: "Cancelar",
      confirmButtonColor: AppColors.primaryBlue,
      width: 480,
      onConfirm: () {
        Navigator.of(context).pop();
        widget.onGoToRegister();
      },
      onCancel: () {
        Navigator.of(context).pop();
        _resetAllAndClearCredentials();
      },
    ).then((result) {
      if (result == null) {
        _resetAllAndClearCredentials();
      }
    });
  }

  /// Verifica si el error indica que el usuario no existe
  bool _isUserNotFoundError(String errorMessage, int? statusCode) {
    final userNotFoundIndicators = [
      "correo no existe",
      "user not found",
      "usuario no encontrado",
      "email not found",
      "no existe",
      "not found",
      "usuario no existe",
      "correo electrónico no encontrado",
    ];

    final message = errorMessage.toLowerCase();
    final isNotFoundStatusCode =
        statusCode == 404 || statusCode == 401 || statusCode == 400;
    final hasNotFoundMessage = userNotFoundIndicators.any(
      (indicator) => message.contains(indicator),
    );

    return isNotFoundStatusCode && hasNotFoundMessage;
  }

  /// Maneja la verificación de existencia del email (PASO 1)
  void _handleEmailVerificationState(
    BuildContext context,
    OtpVerificationState otpState,
  ) {
    if (_currentLoginStep != LoginStep.verifyingEmailExists) return;

    final emailFromForm = _pendingEmail ?? '';

    // Validar que tengamos un email válido
    if (emailFromForm.isEmpty) {
      debugPrint("❌ Error: Email pendiente está vacío en verificación");
      _resetAllAndClearCredentials();
      return;
    }

    debugPrint("📧 Procesando estado de verificación para: $emailFromForm");

    if (otpState is OtpRequestSuccess &&
        otpState.email == emailFromForm &&
        otpState.wasOnlyRequest == false) {
      // El usuario SÍ existe - proceder con login real
      debugPrint(
        "✅ PASO 1 completado: Usuario existe. Procediendo con login...",
      );
      _proceedWithLogin();
    } else if (otpState is OtpRequestFailure &&
        otpState.email == emailFromForm &&
        otpState.wasOnlyRequest == false) {
      if (_isUserNotFoundError(otpState.message, otpState.statusCode)) {
        // El usuario NO existe
        debugPrint("❌ PASO 1: Usuario no existe. Mostrando modal de registro.");
        _handleUserNotFound(emailFromForm);
      } else {
        // Otro tipo de error en la verificación del email
        debugPrint("⚠️ Error en verificación de email: ${otpState.message}");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => UserBlockedDialog(errorMessage: otpState.message),
        ).then((_) {
          _resetAllAndClearCredentials();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = ResponsiveBreakpoints.of(context);

    return MultiBlocListener(
      listeners: [
        // LISTENER 1: Verificación de existencia del email (PASO 1)
        BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: _handleEmailVerificationState,
        ),

        // LISTENER 2: Resultado del login real (PASO 2)
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (_currentLoginStep != LoginStep.attemptingLogin) return;

            if (state is AuthAuthenticated) {
              // Login exitoso - proceder con checks de seguridad
              debugPrint(
                "✅ PASO 2 completado: Login exitoso. Iniciando checks de seguridad...",
              );
              _proceedWithSecurityChecks();
            }
          },
        ),

        // LISTENER 3: Check de estado de bloqueo (PASO 3a)
        BlocListener<CheckLockStatusBloc, CheckLockStatusState>(
          listener: (context, state) {
            if (_currentLoginStep != LoginStep.performingSecurityChecks) return;

            if (state is CheckLockStatusSuccess) {
              setState(() {
                _lockCheckCompleted = true;
              });

              if (state.validationInfo.isBlocked) {
                // Usuario bloqueado - mostrar modal
                debugPrint("❌ PASO 3a: Usuario bloqueado detectado");
                CustomConfirmationModal.showSimple(
                  context: context,
                  title: l10n.accountBlockedTitle,
                  subtitle: l10n.accountBlockedMessage,
                  confirmButtonText: l10n.accept,
                  confirmButtonColor: AppColors.primaryBlue,
                  width: 450,
                ).then((_) {
                  _resetAllAndClearCredentials();
                });
              } else {
                // No bloqueado - marcar como OK para continuar
                debugPrint("✅ PASO 3a: Usuario no bloqueado");
                setState(() {
                  _canFinishLogin = true;
                });
                _checkIfCanFinishLogin();
              }
            } else if (state is CheckLockStatusFailure) {
              debugPrint(
                "⚠️ PASO 3a: Error en check de bloqueo, continuando...",
              );
              setState(() {
                _lockCheckCompleted = true;
                _canFinishLogin = true; // Continuar a pesar del error
              });
              _checkIfCanFinishLogin();
            }
          },
        ),

        // LISTENER 4: Check de sesión activa (PASO 3b)
        BlocListener<CheckSessionStatusBloc, CheckSessionStatusState>(
          listener: (context, state) {
            if (_currentLoginStep != LoginStep.performingSecurityChecks) return;

            if (state is CheckSessionStatusLoaded) {
              setState(() {
                _sessionCheckCompleted = true;
              });

              if (state.hasActiveSession) {
                // Sesión activa detectada - mostrar modal solo después de login exitoso
                debugPrint("⚠️ PASO 3b: Sesión activa detectada");
                CustomConfirmationModal.show(
                  context: context,
                  title: l10n.activeSessionDialogTitle,
                  subtitle: l10n.activeSessionDialogMessage,
                  confirmButtonText: l10n.keepSessionButtonLabel,
                  cancelButtonText: l10n.closeSessionButtonLabel,
                  confirmButtonColor: const Color(0xFFDC2626),
                  width: 450,
                  onConfirm: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _canFinishLogin = true;
                    });
                    _checkIfCanFinishLogin();
                  },
                  onCancel: () {
                    Navigator.of(context).pop();
                    _resetAllAndClearCredentials();
                  },
                ).then((result) {
                  if (result == null) {
                    _resetAllAndClearCredentials();
                  }
                });
              } else {
                // No hay sesión activa - OK para finalizar
                debugPrint("✅ PASO 3b: No hay sesión activa");
                setState(() {
                  _canFinishLogin = true;
                });
                _checkIfCanFinishLogin();
              }
            } else if (state is CheckSessionStatusFailure) {
              debugPrint(
                "⚠️ PASO 3b: Error en check de sesión, continuando...",
              );
              setState(() {
                _sessionCheckCompleted = true;
                _canFinishLogin = true;
              });
              _checkIfCanFinishLogin();
            }
          },
        ),
      ],
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
              enabled: !_isCheckingStatus,
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing,
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
              onSubmitted: (_) => !_isCheckingStatus ? _onLoginAttempt() : null,
              enabled: !_isCheckingStatus,
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing / 2,
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
                onPressed:
                    !_isCheckingStatus ? widget.onGoToForgotPassword : null,
                child: Text(l10n.loginFormForgotPasswordButton),
              ),
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.largeSpacing,
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 4.0),
                    ],
                  ).value,
            ),
            ElevatedButton(
              onPressed: !_isCheckingStatus ? _onLoginAttempt : null,
              child:
                  _isCheckingStatus
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                      : Text(l10n.loginFormLoginButton),
            ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing,
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
                onPressed: !_isCheckingStatus ? widget.onGoogleLogin : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkTextColor,
                  side: BorderSide(color: AppColors.borderColor),
                ),
              ),
            SizedBox(
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: AppDimensions.itemSpacing / 2,
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
                  onPressed: !_isCheckingStatus ? widget.onGoToRegister : null,
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
