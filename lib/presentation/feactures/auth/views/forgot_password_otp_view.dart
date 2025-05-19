import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/presentation/feactures/auth/bloc/blocs.dart';
import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart';

class ForgotPasswordOtpView extends StatelessWidget {
  final String? emailForOtp;

  const ForgotPasswordOtpView({super.key, this.emailForOtp});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String currentEmail = emailForOtp ?? '';

    if (currentEmail.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Asegurarse de que el BLoC se resetea si se navega hacia atrás por error
        context.read<ForgotPasswordBloc>().add(ForgotPasswordReset());
        context.goNamed(AppRoutes.forgotPassword);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorEmailNotProvidedMessage)),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      // listenWhen: (previous, current) { // Opcional: para ser más específico
      //   // Solo escuchar si el estado pertenece a este email o es un estado inicial/de carga general
      //   if (current is ForgotPasswordOtpVerificationSuccess && current.email == currentEmail) return true;
      //   if (current is ForgotPasswordOtpVerificationFailure && current.email == currentEmail) return true;
      //   if (current is ForgotPasswordEmailVerificationSuccess && current.email == currentEmail) return true; // Para reenvío
      //   if (current is ForgotPasswordEmailVerificationFailure && current.email == currentEmail) return true; // Para reenvío
      //   // Considera si quieres que el loading global maneje los InProgress o si quieres reaccionar aquí
      //   return false;
      // },
      listener: (context, state) {
        // Asegúrate que el estado corresponde al email actual para evitar reacciones a flujos de otros emails si el usuario navega rápido
        if (state is ForgotPasswordOtpVerificationSuccess &&
            state.email == currentEmail) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpVerificationSuccessMessage)),
          );
          // Navegar a la vista de cambio de contraseña
          context.goNamed(
            AppRoutes.newPasswordForm,
            extra: {'email': state.email, 'otp': state.otp},
          );
        } else if (state is ForgotPasswordOtpVerificationFailure &&
            state.email == currentEmail) {
          showDialog(
            context: context,
            builder: (_) => RegistrationFailedDialog(message: state.message),
          );
        } else if (state is ForgotPasswordEmailVerificationSuccess &&
            state.email == currentEmail) {
          // Esto es para el reenvío de OTP
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpResendSuccessMessage(state.email))),
          );
        } else if (state is ForgotPasswordEmailVerificationFailure &&
            state.email == currentEmail) {
          // Para errores durante el reenvío de OTP
          showDialog(
            context: context,
            builder: (_) => RegistrationFailedDialog(message: state.message),
          );
        }
      },
      child: AuthLayout(
        authView: AuthView.forgotPasswordOtp,
        emailForOtp: currentEmail,
        rightPanelContent: ForgotPasswordOtpForm(
          email: currentEmail,
          onOtpVerified: (otp) {
            // Esto dispara el evento para verificar el OTP
            context.read<ForgotPasswordBloc>().add(
              ForgotPasswordOtpSubmitted(email: currentEmail, otp: otp),
            );
          },
          onResendOtp: () {
            // Esto dispara el evento para reenviar/re-solicitar el OTP
            context.read<ForgotPasswordBloc>().add(
              ForgotPasswordEmailSubmitted(email: currentEmail),
            );
          },
          onGoBack: () {
            context.read<ForgotPasswordBloc>().add(ForgotPasswordReset());
            context.goNamed(AppRoutes.forgotPassword);
          },
        ),
      ),
    );
  }
}
