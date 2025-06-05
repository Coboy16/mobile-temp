import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

import '/presentation/feactures/auth/bloc/blocs.dart';
import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/resources/resources.dart';

class ForgotPasswordEmailView extends StatelessWidget {
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordEmailVerificationSuccess) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
            title: Text('Código enviado'),
            description: Text(l10n.otpSentSuccessMessage(state.email)),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 5),
            animationDuration: const Duration(milliseconds: 300),
            showIcon: true,
            showProgressBar: false,
          );
          // Pasa el email a la vista de OTP
          context.goNamed(AppRoutes.otp, extra: state.email);
        } else if (state is ForgotPasswordEmailVerificationFailure) {
          CustomConfirmationModal.showSimple(
            context: context,
            title: l10n.passwordRecoveryErrorTitle,
            subtitle: l10n.passwordRecoveryErrorMessage,
            confirmButtonText: l10n.accept,
            confirmButtonColor: AppColors.primaryBlue,
            width: 420,
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
            final l10n = AppLocalizations.of(context)!;

            toastification.show(
              context: context,
              type: ToastificationType.info,
              style: ToastificationStyle.minimal,
              title: Text(l10n.returnToLoginTitle),
              description: Text(l10n.returnToLoginMessage),
              alignment: Alignment.topCenter,
              autoCloseDuration: const Duration(seconds: 2),
              animationDuration: const Duration(milliseconds: 300),
              showIcon: true,
              showProgressBar: false,
            );

            context.read<ForgotPasswordBloc>().add(ForgotPasswordReset());

            // Pequeño delay para que se vea el toast
            Future.delayed(const Duration(milliseconds: 300), () {
              context.goNamed(AppRoutes.login);
            });
          },
        ),
      ),
    );
  }
}
