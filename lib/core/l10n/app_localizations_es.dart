// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get registerTitle => 'Crear Cuenta';

  @override
  String get forgotPasswordEmailTitle => 'Recuperar Contraseña';

  @override
  String get forgotPasswordOtpTitle => 'Verificar Código';

  @override
  String get loginSubtitle =>
      'Ingresa tus credenciales para acceder al sistema';

  @override
  String get registerSubtitle => 'Completa el formulario para unirte a Ho-Tech';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Ingresa tu correo para enviar un código de recuperación.';

  @override
  String forgotPasswordOtpSubtitle(String emailAddress) {
    return 'Ingresa el código de 6 dígitos enviado a $emailAddress.';
  }

  @override
  String copyrightNotice(int year) {
    return '© $year Ho-Tech. Todos los derechos reservados.';
  }

  @override
  String get loadingMessage => 'Cargando...';

  @override
  String get validationSuccessMessage =>
      'Validación exitosa. Continúe con el proceso.';

  @override
  String get yourEmailFallback => 'tu correo';

  @override
  String get errorDialogTitle => 'Error';

  @override
  String get userBlockedDialogTitle => 'Cuenta Bloqueada';

  @override
  String userBlockedDialogMessage(Object minutes) {
    return 'Tu cuenta ha sido bloqueada temporalmente. Por favor, intenta de nuevo en $minutes minutos.';
  }

  @override
  String get userAccountBlockedGeneric =>
      'Tu cuenta se encuentra bloqueada. Por favor, inténtalo más tarde.';

  @override
  String get okButtonLabel => 'Aceptar';

  @override
  String get confirmLogoutDialogTitle => 'Confirmar Cierre de Sesión';

  @override
  String get confirmLogoutDialogMessage =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancelButtonLabel => 'Cancelar';

  @override
  String get logoutButtonLabel => 'Cerrar Sesión';

  @override
  String get loggingOutMessage => 'Cerrando sesión...';

  @override
  String get registrationErrorDialogTitle => 'Error de Registro';

  @override
  String get leftPanelLoginTitle => 'Bienvenido a Ho-Tech';

  @override
  String get leftPanelLoginSubtitle =>
      'Plataforma integral para la gestión de recursos humanos en empresas del sector hotelero.';

  @override
  String get leftPanelLoginHighlight1Title => 'Gestión de solicitudes';

  @override
  String get leftPanelLoginHighlight1Description =>
      'Administra todo tipo de solicitudes desde un solo lugar.';

  @override
  String get leftPanelLoginHighlight2Title => 'Administración de personal';

  @override
  String get leftPanelLoginHighlight2Description =>
      'Contrataciones, evaluaciones, capacitaciones y más.';

  @override
  String get leftPanelLoginHighlight3Title => 'Informes y análisis';

  @override
  String get leftPanelLoginHighlight3Description =>
      'Métricas e indicadores para tomar mejores decisiones.';

  @override
  String get leftPanelRegisterTitle => 'Únete a Ho-Tech';

  @override
  String get leftPanelRegisterSubtitle =>
      'Regístrate para acceder a una gestión hotelera simplificada y eficiente.';

  @override
  String get leftPanelRegisterHighlight1Title => 'Registro Rápido';

  @override
  String get leftPanelRegisterHighlight1Description =>
      'Crea tu cuenta en pocos pasos y comienza a transformar tu gestión.';

  @override
  String get leftPanelRegisterHighlight2Title => 'Seguridad Garantizada';

  @override
  String get leftPanelRegisterHighlight2Description =>
      'Tus datos están protegidos con los más altos estándares.';

  @override
  String get leftPanelRegisterHighlight3Title => 'Acceso Inmediato';

  @override
  String get leftPanelRegisterHighlight3Description =>
      'Una vez registrado, explora todas las funcionalidades que Ho-Tech te ofrece.';

  @override
  String get leftPanelForgotPasswordTitle => 'Recupera tu Acceso';

  @override
  String get leftPanelForgotPasswordSubtitle =>
      'Sigue los pasos para restablecer tu contraseña y volver a gestionar tus recursos humanos de forma eficiente.';

  @override
  String get leftPanelForgotPasswordHighlight1Title => 'Verificación Segura';

  @override
  String get leftPanelForgotPasswordHighlight1Description =>
      'Ingresa tu correo para recibir un código de verificación y proteger tu cuenta.';

  @override
  String get leftPanelForgotPasswordHighlight2Title => 'Restablecimiento Fácil';

  @override
  String get leftPanelForgotPasswordHighlight2Description =>
      'Con el código OTP, podrás crear una nueva contraseña de forma rápida y segura.';

  @override
  String get leftPanelForgotPasswordHighlight3Title => 'Soporte Continuo';

  @override
  String get leftPanelForgotPasswordHighlight3Description =>
      'Si tienes problemas, nuestro equipo de soporte está listo para ayudarte.';

  @override
  String get forgotPasswordEmailFormLabel => 'Correo electrónico';

  @override
  String get forgotPasswordEmailFormHint => 'Ingresa tu correo electrónico';

  @override
  String get forgotPasswordEmailFormErrorRequired => 'El correo es requerido';

  @override
  String get forgotPasswordEmailFormErrorInvalid => 'Ingresa un correo válido';

  @override
  String get forgotPasswordEmailFormSubmitButton =>
      'Enviar código de recuperación';

  @override
  String get forgotPasswordEmailFormBackToLoginButton =>
      'Volver a Iniciar Sesión';

  @override
  String get forgotPasswordOtpFormValidatorError =>
      'El código debe ser de 6 dígitos';

  @override
  String get forgotPasswordOtpFormSubmitButton => 'Verificar Código';

  @override
  String get forgotPasswordOtpFormDidNotReceiveCode =>
      '¿No recibiste el código? ';

  @override
  String get forgotPasswordOtpFormResendCodeButton => 'Reenviar código';

  @override
  String get forgotPasswordOtpFormEnterDifferentEmailButton =>
      'Ingresar otro correo';

  @override
  String get loginFormUsernameLabel => 'Usuario';

  @override
  String get loginFormUsernameHint => 'Ingresa tu nombre de usuario';

  @override
  String get loginFormUsernameErrorRequired => 'El usuario es requerido';

  @override
  String get loginFormPasswordLabel => 'Contraseña';

  @override
  String get loginFormPasswordHint => 'Ingresa tu contraseña';

  @override
  String get loginFormPasswordErrorRequired => 'La contraseña es requerida';

  @override
  String get loginFormPasswordErrorMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginFormForgotPasswordButton => '¿Olvidaste tu contraseña?';

  @override
  String get loginFormLoginButton => 'Iniciar Sesión';

  @override
  String get loginFormLoginWithGoogleButton => 'Iniciar Sesión con Google';

  @override
  String get loginFormNoAccountPrompt => '¿No tienes una cuenta? ';

  @override
  String get loginFormCreateAccountButton => 'Crear cuenta';

  @override
  String get otpFormValidatorError => 'El código debe ser de 6 dígitos';

  @override
  String get otpFormDefaultSubmitButton => 'Verificar Código';

  @override
  String get otpFormDidNotReceiveCodePrompt => '¿No recibiste el código? ';

  @override
  String get otpFormDefaultResendButton => 'Reenviar código';

  @override
  String get registerFormFirstNameLabel => 'Nombres';

  @override
  String get registerFormFirstNameHint => 'Ingresa tus nombres';

  @override
  String get registerFormFirstNameErrorRequired => 'Los nombres son requeridos';

  @override
  String get registerFormPaternalLastNameLabel => 'Apellido Paterno';

  @override
  String get registerFormPaternalLastNameHint => 'Ingresa tu apellido paterno';

  @override
  String get registerFormPaternalLastNameErrorRequired =>
      'El apellido paterno es requerido';

  @override
  String get registerFormMaternalLastNameLabel => 'Apellido Materno';

  @override
  String get registerFormMaternalLastNameHint => 'Ingresa tu apellido materno';

  @override
  String get registerFormMaternalLastNameErrorRequired =>
      'El apellido materno es requerido';

  @override
  String get registerFormEmailLabel => 'Correo electrónico';

  @override
  String get registerFormEmailHint => 'Ingresa tu correo';

  @override
  String get registerFormEmailErrorRequired => 'El correo es requerido';

  @override
  String get registerFormEmailErrorInvalid => 'Ingresa un correo válido';

  @override
  String get registerFormPasswordLabel => 'Contraseña';

  @override
  String get registerFormPasswordHint => 'Ingresa tu contraseña';

  @override
  String get registerFormPasswordErrorRequired => 'La contraseña es requerida';

  @override
  String get registerFormPasswordErrorMinLength => 'Mínimo 8 caracteres';

  @override
  String get registerFormPasswordErrorUppercase =>
      'Debe contener al menos una mayúscula';

  @override
  String get registerFormPasswordErrorDigit =>
      'Debe contener al menos un número';

  @override
  String get registerFormPasswordErrorSpecialChar =>
      'Debe contener al menos un carácter especial';

  @override
  String get registerFormConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get registerFormConfirmPasswordHint =>
      'Vuelve a ingresar tu contraseña';

  @override
  String get registerFormConfirmPasswordErrorRequired =>
      'Confirma tu contraseña';

  @override
  String get registerFormConfirmPasswordErrorMismatch =>
      'Las contraseñas no coinciden';

  @override
  String get registerFormContinueButton => 'Continuar';

  @override
  String get registerFormCreateAccountWithGoogleButton =>
      'Crear cuenta con Google';

  @override
  String get registerFormAlreadyHaveAccountPrompt => '¿Ya tienes una cuenta? ';

  @override
  String get registerFormLoginButton => 'Iniciar Sesión';

  @override
  String get loadingMessageDefault => 'Cargando...';

  @override
  String get formValidationCompleteCorrectly =>
      'Por favor completa el formulario correctamente.';

  @override
  String get googleSignInCancelled =>
      'Inicio de sesión con Google cancelado por el usuario.';

  @override
  String get registerWithGoogleSuccessMessage =>
      '¡Registro con Google completado! Iniciando sesión...';

  @override
  String get otpVerificationSuccessMessageRegister =>
      'OTP verificado correctamente. Procediendo con el registro...';

  @override
  String otpResendSuccessMessage(Object email) {
    return 'Se ha reenviado un nuevo código OTP a $email.';
  }

  @override
  String get registrationCompleteMessage =>
      '¡Registro completado! Iniciando sesión...';

  @override
  String get autoLoginFailedMessage => 'Falló el inicio de sesión automático';

  @override
  String get autoLoginFailedAfterRegisterMessage =>
      'Error al iniciar sesión después del registro';

  @override
  String get autoLoginFailedAfterGoogleRegisterMessage =>
      'Error al iniciar sesión con Google después del registro';

  @override
  String otpVerificationDescriptionForRegistration(Object email) {
    return 'Hemos enviado un código de verificación a tu correo electrónico $email. Por favor, ingrésalo a continuación para completar tu registro.';
  }

  @override
  String get otpVerificationButtonForRegistration => 'Verificar y Registrar';

  @override
  String get otpVerificationResendButtonForRegistration => 'Reenviar Código';

  @override
  String get emailAlreadyRegisteredError =>
      'Este correo electrónico ya está registrado. Por favor, intenta iniciar sesión o usa un correo diferente.';

  @override
  String get otpRequestLoadingMessage => 'Solicitando OTP...';

  @override
  String get otpVerificationLoadingMessage => 'Verificando OTP...';

  @override
  String get registerLoadingMessage => 'Registrando usuario...';

  @override
  String get loginLoadingMessage => 'Iniciando sesión...';

  @override
  String otpSentSuccessMessage(Object email) {
    return 'OTP enviado con éxito a $email.';
  }

  @override
  String get errorEmailNotProvidedMessage =>
      'Error: No se proporcionó el correo para la verificación OTP.';

  @override
  String get otpVerificationSuccessMessage => '¡OTP verificado con éxito!';

  @override
  String get passwordChangeSuccessMessage =>
      '¡Contraseña cambiada con éxito! Por favor, inicia sesión.';

  @override
  String newPasswordFormTitleFor(Object email) {
    return 'Establecer Nueva Contraseña para $email';
  }

  @override
  String get newPasswordFormNewLabel => 'Nueva Contraseña';

  @override
  String get newPasswordFormNewHint => 'Ingresa tu nueva contraseña';

  @override
  String get newPasswordFormNewErrorRequired =>
      'La nueva contraseña es requerida';

  @override
  String get newPasswordFormConfirmLabel => 'Confirmar Nueva Contraseña';

  @override
  String get newPasswordFormConfirmHint => 'Confirma tu nueva contraseña';

  @override
  String get newPasswordFormConfirmErrorRequired =>
      'Por favor, confirma tu nueva contraseña';

  @override
  String get newPasswordFormSubmitButton => 'Cambiar Contraseña';

  @override
  String get leftPanelSetNewPasswordTitle => 'Asegura tu Cuenta';

  @override
  String get leftPanelSetNewPasswordSubtitle =>
      'Elige una contraseña fuerte y única para proteger los datos de gestión de tu hotel.';

  @override
  String get leftPanelSetNewPasswordHighlight1Title => 'Contraseña Fuerte';

  @override
  String get leftPanelSetNewPasswordHighlight1Description =>
      'Usa una mezcla de letras, números y símbolos para mayor seguridad.';

  @override
  String get leftPanelSetNewPasswordHighlight2Title => 'Evita Reutilizar';

  @override
  String get leftPanelSetNewPasswordHighlight2Description =>
      'No uses contraseñas que hayas utilizado en otros sitios.';

  @override
  String get leftPanelSetNewPasswordHighlight3Title => 'Confirmación';

  @override
  String get leftPanelSetNewPasswordHighlight3Description =>
      'Asegúrate de que tu nueva contraseña esté confirmada y guardada de forma segura.';

  @override
  String get setNewPasswordTitle => 'Establecer Nueva Contraseña';

  @override
  String setNewPasswordSubtitle(Object email) {
    return 'Crea una nueva contraseña segura para tu cuenta asociada con $email.';
  }

  @override
  String get forgotPasswordEmailVerificationLoadingMessage =>
      'Verificando correo...';

  @override
  String get forgotPasswordOtpVerificationLoadingMessage =>
      'Verificando OTP...';

  @override
  String get forgotPasswordChangeLoadingMessage => 'Actualizando contraseña...';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsSubtitle =>
      'Administra tus preferencias y ajustes del sistema';

  @override
  String get backButton => 'Volver';

  @override
  String get accountTab => 'Cuenta';

  @override
  String get appearanceTab => 'Apariencia';

  @override
  String get userInfoTitle => 'Información de Usuario';

  @override
  String get userInfoSubtitle =>
      'Información básica sobre tu cuenta y preferencias de usuario';

  @override
  String get appearanceContentPlaceholder => 'Contenido de Apariencia Aquí';

  @override
  String get activeSessionDialogTitle => 'Sesión Activa Detectada';

  @override
  String get activeSessionDialogMessage =>
      'Ya tienes una sesión activa en otro dispositivo o navegador. ¿Deseas cerrar la sesión anterior y continuar con el inicio de sesión actual?';

  @override
  String get keepSessionButtonLabel => 'Mantener Sesión';

  @override
  String get closeSessionButtonLabel => 'Cerrar Sesión Anterior';

  @override
  String get invalidOtpMessage =>
      'El código que ingresaste no es válido. Por favor, revisa e intenta nuevamente.';
}
