import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/bloc/blocs.dart';

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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleOtpVerificationState(
    BuildContext context,
    OtpVerificationState otpState,
  ) {
    if (otpState is OtpVerifySuccess) {
      // OTP verificado, ahora proceder con el registro final
      _showSnackBar(context, 'OTP verificado correctamente. Registrando...');
      context.read<RegisterBloc>().add(
        RegisterUserSubmitted(
          name: registrationArgs.name,
          fatherLastname: registrationArgs.fatherLastname,
          motherLastname: registrationArgs.motherLastname,
          email: registrationArgs.email,
          password: registrationArgs.password,
        ),
      );
    } else if (otpState is OtpVerifyFailure) {
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: otpState.message),
      );
    } else if (otpState is OtpRequestSuccess &&
        otpState.email == registrationArgs.email) {
      // Esto podría ser después de un reenvío exitoso
      _showSnackBar(
        context,
        'Se ha reenviado un nuevo código OTP a ${otpState.email}',
      );
    } else if (otpState is OtpRequestFailure) {
      showDialog(
        context: context,
        builder: (_) => RegistrationFailedDialog(message: otpState.message),
      );
    }
  }

  void _handleRegisterState(BuildContext context, RegisterState registerState) {
    // Este listener es para el resultado del registro *final*
    if (registerState is RegisterSuccess) {
      // El flujo de login post-registro y navegación a home se maneja en RegisterView
      // o en un nivel superior si AuthBloc/AuthGoogleBloc lo hacen globalmente.
      // Aquí solo confirmamos que el registro (la llamada al endpoint /auth/user) fue exitosa.
      // La navegación a login o home ya está configurada en RegisterView.
      // Podríamos mostrar un mensaje y luego dejar que RegisterView maneje la navegación.
      _showSnackBar(context, '¡Registro completado! Iniciando sesión...');
      // No necesitamos navegar desde aquí si RegisterView ya lo hace al escuchar AuthBloc/AuthGoogleBloc
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
    return MultiBlocListener(
      listeners: [
        BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener:
              (context, state) => _handleOtpVerificationState(context, state),
        ),
        BlocListener<RegisterBloc, RegisterState>(
          // Para el resultado del registro final
          listener: (context, state) => _handleRegisterState(context, state),
        ),
      ],
      child: AuthLayout(
        authView: AuthView.forgotPasswordOtp,
        emailForOtp: registrationArgs.email,
        rightPanelContent: OtpFormWidget(
          email: registrationArgs.email,
          onOtpVerified: (otp) {
            context.read<OtpVerificationBloc>().add(
              OtpCodeSubmitted(email: registrationArgs.email, code: otp),
            );
          },
          onResendOtp: () {
            context.read<OtpVerificationBloc>().add(
              OtpRequestSubmitted(email: registrationArgs.email),
            );
          },
          onGoBack: () {
            context.read<OtpVerificationBloc>().add(OtpVerificationReset());
            context.goNamed(AppRoutes.register);
          },
          descriptionText: l10n.otpVerificationDescriptionForRegistration,
          buttonText: l10n.otpVerificationButtonForRegistration,
          resendOtpButtonText: l10n.otpVerificationResendButtonForRegistration,
        ),
      ),
    );
  }
}
