import 'package:flutter/material.dart';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';
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

class RegisterOtpView extends StatefulWidget {
  final RegisterOtpViewArguments registrationArgs;

  const RegisterOtpView({super.key, required this.registrationArgs});

  @override
  State<RegisterOtpView> createState() => _RegisterOtpViewState();
}

class _RegisterOtpViewState extends State<RegisterOtpView> {
  final GlobalKey<OtpFormWidgetState> _otpFormKey =
      GlobalKey<OtpFormWidgetState>();

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
      debugPrint(l10n.otpVerificationSuccessMessageRegister);
      context.read<RegisterBloc>().add(
        RegisterUserSubmitted(
          name: widget.registrationArgs.name,
          fatherLastname: widget.registrationArgs.fatherLastname,
          motherLastname: widget.registrationArgs.motherLastname,
          email: widget.registrationArgs.email,
          password: widget.registrationArgs.password,
        ),
      );
    } else if (otpState is OtpVerifyFailure && otpState.wasOnlyVerify == true) {
      // Limpiar el formulario OTP cuando hay un error
      _otpFormKey.currentState?.clearOtpField();

      showDialog(
        context: context,
        builder:
            (_) => RegistrationFailedDialog(message: l10n.invalidOtpMessage),
      );
    } else if (otpState is OtpRequestSuccess &&
        otpState.email == widget.registrationArgs.email &&
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
          email: widget.registrationArgs.email,
          cedulaOrPassword: widget.registrationArgs.password,
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
      context.goNamed(AppRoutes.homeRequestName);
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

    return MultiBlocListener(
      listeners: [
        BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: _handleOtpVerificationState,
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: _handleRegisterState,
        ),
        BlocListener<AuthBloc, AuthState>(listener: _handleAuthState),
      ],
      child: AuthLayout(
        authView: AuthView.forgotPasswordOtp,
        emailForOtp: widget.registrationArgs.email,
        rightPanelContent: OtpFormWidget(
          key: _otpFormKey,
          email: widget.registrationArgs.email,
          onOtpVerified: (otp) {
            context.read<OtpVerificationBloc>().add(
              OtpCodeSubmitted(
                email: widget.registrationArgs.email,
                code: otp,
                onlyVerify: true,
              ),
            );
          },
          onResendOtp: () {
            context.read<OtpVerificationBloc>().add(
              OtpRequestSubmitted(
                email: widget.registrationArgs.email,
                onlyRequest: true,
              ),
            );
          },
          onGoBack: () {
            context.read<OtpVerificationBloc>().add(OtpVerificationReset());
            context.goNamed(AppRoutes.register);
          },
          descriptionText: l10n.otpVerificationDescriptionForRegistration(
            widget.registrationArgs.email,
          ),
          buttonText: l10n.otpVerificationButtonForRegistration,
          resendOtpButtonText: l10n.otpVerificationResendButtonForRegistration,
        ),
      ),
    );
  }
}
