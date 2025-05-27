import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';

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
      listener: (context, state) {
        if (state is ForgotPasswordOtpVerificationSuccess &&
            state.email == currentEmail) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpVerificationSuccessMessage)),
          );
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
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpResendSuccessMessage(state.email))),
          );
        } else if (state is ForgotPasswordEmailVerificationFailure &&
            state.email == currentEmail) {
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
            context.read<ForgotPasswordBloc>().add(
              ForgotPasswordOtpSubmitted(email: currentEmail, otp: otp),
            );
          },
          onResendOtp: () {
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
