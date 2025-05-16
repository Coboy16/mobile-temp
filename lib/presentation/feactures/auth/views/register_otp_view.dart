import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/bloc/blocs.dart'; // Asegúrate que AuthBloc esté exportado aquí

class RegisterOtpViewArguments {
  final String email;
  final String name;
  final String fatherLastname;
  final String motherLastname;
  final String password;

  RegisterOtpViewArguments({
    required this.email,
    required this.name,
    required this.fatherLastname,
    required this.motherLastname,
    required this.password,
  });
}

class RegisterOtpView extends StatelessWidget {
  final RegisterOtpViewArguments registrationArgs;

  const RegisterOtpView({super.key, required this.registrationArgs});

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  void _handleOtpVerificationState(
    BuildContext context,
    OtpVerificationState otpState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (otpState is OtpVerifySuccess && otpState.wasOnlyVerify == true) {
      _showSnackBar(context, l10n.otpVerificationSuccessMessageRegister);
      context.read<RegisterBloc>().add(
        RegisterUserSubmitted(
          name: registrationArgs.name,
          fatherLastname: registrationArgs.fatherLastname,
          motherLastname: registrationArgs.motherLastname,
          email: registrationArgs.email,
          password: registrationArgs.password,
        ),
      );
    } else if (otpState is OtpVerifyFailure && otpState.wasOnlyVerify == true) {
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: otpState.message),
      );
    } else if (otpState is OtpRequestSuccess &&
        otpState.email == registrationArgs.email &&
        otpState.wasOnlyRequest == true) {
      _showSnackBar(context, l10n.otpResendSuccessMessage(otpState.email));
    } else if (otpState is OtpRequestFailure &&
        otpState.wasOnlyRequest == true) {
      // Si el reenvío falla durante el proceso de registro OTP
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: otpState.message),
      );
    }
  }

  void _handleRegisterState(BuildContext context, RegisterState registerState) {
    final l10n = AppLocalizations.of(context)!;
    if (registerState is RegisterSuccess) {
      debugPrint(l10n.registrationCompleteMessage);
      // Intentar login automático
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: registrationArgs.email,
          cedulaOrPassword: registrationArgs.password,
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

  void _handleAuthState(BuildContext context, AuthState authState) {
    if (authState is AuthAuthenticated) {
      context.goNamed(AppRoutes.home);
    } else if (authState is AuthFailure) {
      _showSnackBar(
        context,
        '${AppLocalizations.of(context)!.autoLoginFailedMessage}: ${authState.message}',
        isError: true,
      );
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Asegurarse que el OtpVerificationBloc se resetea al entrar si es necesario,
    // o que el estado de OtpRequestSuccess de RegisterForm no interfiera.
    // El reset ya se hace en RegisterForm antes de navegar aquí.

    return MultiBlocListener(
      listeners: [
        BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: _handleOtpVerificationState,
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: _handleRegisterState,
        ),
        BlocListener<AuthBloc, AuthState>(
          // Para el login automático
          listener: _handleAuthState,
        ),
      ],
      child: AuthLayout(
        authView: AuthView.forgotPasswordOtp, // Reutiliza el layout visual
        emailForOtp: registrationArgs.email,
        rightPanelContent: OtpFormWidget(
          email: registrationArgs.email,
          onOtpVerified: (otp) {
            context.read<OtpVerificationBloc>().add(
              OtpCodeSubmitted(
                email: registrationArgs.email,
                code: otp,
                onlyVerify: true, // Crucial para el flujo de registro
              ),
            );
          },
          onResendOtp: () {
            context.read<OtpVerificationBloc>().add(
              OtpRequestSubmitted(
                email: registrationArgs.email,
                onlyRequest: true, // Crucial para el flujo de registro
              ),
            );
          },
          onGoBack: () {
            context.read<OtpVerificationBloc>().add(OtpVerificationReset());
            context.goNamed(AppRoutes.register);
          },
          descriptionText: l10n.otpVerificationDescriptionForRegistration(
            registrationArgs.email,
          ),
          buttonText: l10n.otpVerificationButtonForRegistration,
          resendOtpButtonText: l10n.otpVerificationResendButtonForRegistration,
        ),
      ),
    );
  }
}
