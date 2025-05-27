import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';

import '/presentation/feactures/auth/bloc/blocs.dart';
import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart'; // Para RegistrationFailedDialog

class ForgotPasswordEmailView extends StatelessWidget {
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordEmailVerificationSuccess) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otpSentSuccessMessage(state.email))),
          );
          // Pasa el email a la vista de OTP
          context.goNamed(AppRoutes.otp, extra: state.email);
        } else if (state is ForgotPasswordEmailVerificationFailure) {
          showDialog(
            context: context,
            builder: (_) => RegistrationFailedDialog(message: state.message),
          );
        }
      },
      child: AuthLayout(
        authView: AuthView.forgotPasswordEmail,
        rightPanelContent: ForgotPasswordEmailForm(
          onEmailSubmitted: (email) {
            context.read<ForgotPasswordBloc>().add(
              ForgotPasswordEmailSubmitted(email: email.trim()),
            );
          },
          onGoToLogin: () {
            context.read<ForgotPasswordBloc>().add(ForgotPasswordReset());
            context.goNamed(AppRoutes.login);
          },
        ),
      ),
    );
  }
}
