import 'package:flutter/material.dart';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

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

      CustomConfirmationModal.showSimple(
        context: context,
        title: l10n.otpVerificationErrorTitle,
        subtitle: l10n.invalidOtpMessage,
        confirmButtonText: l10n.accept,
        confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
        width: 420,
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    } else if (otpState is OtpRequestSuccess &&
        otpState.email == widget.registrationArgs.email &&
        otpState.wasOnlyRequest == true) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
        title: Text('Código reenviado'),
        description: Text(l10n.otpResendSuccessMessage(otpState.email)),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
        animationDuration: const Duration(milliseconds: 300),
        showIcon: true,
        showProgressBar: false,
      );
    } else if (otpState is OtpRequestFailure &&
        otpState.wasOnlyRequest == true) {
      // Si el reenvío falla durante el proceso de registro OTP
      CustomConfirmationModal.showSimple(
        context: context,
        title: l10n.otpVerificationErrorTitle,
        subtitle: l10n.invalidOtpMessage,
        confirmButtonText: l10n.accept,
        confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
        width: 420,
        onConfirm: () {
          Navigator.of(context).pop();
        },
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
      CustomConfirmationModal.showSimple(
        context: context,
        title: l10n.otpVerificationErrorTitle,
        subtitle: l10n.invalidOtpMessage,
        confirmButtonText: l10n.accept,
        confirmButtonColor: const Color(0xFFDC2626),
        width: 420,
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _handleAuthState(BuildContext context, AuthState authState) {
    if (authState is AuthAuthenticated) {
      context.goNamed(AppRoutes.homeRequestName);
    } else if (authState is AuthFailure) {
      final l10n = AppLocalizations.of(context)!;

      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(l10n.autoLoginFailedTitle),
        description: Text(authState.message),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 5),
        showIcon: true,
        showProgressBar: false,
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
