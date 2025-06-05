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
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.minimal,
          title: Text(l10n.emailNotProvidedErrorTitle),
          description: Text(l10n.errorEmailNotProvidedMessage),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 300),
          showIcon: true,
          showProgressBar: false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordOtpVerificationSuccess &&
            state.email == currentEmail) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
            title: Text(l10n.otpVerificationSuccessTitle),
            description: Text(l10n.otpVerificationSuccessMessage),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 3),
            animationDuration: const Duration(milliseconds: 300),
            showIcon: true,
            showProgressBar: false,
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            context.goNamed(
              AppRoutes.newPasswordForm,
              extra: {'email': state.email, 'otp': state.otp},
            );
          });
        } else if (state is ForgotPasswordOtpVerificationFailure &&
            state.email == currentEmail) {
          final l10n = AppLocalizations.of(context)!;

          CustomConfirmationModal.showSimple(
            context: context,
            title: l10n.otpVerificationErrorTitle,
            subtitle: state.message,
            confirmButtonText: l10n.accept,
            confirmButtonColor: const Color(0xFFDC2626),
            width: 420,
          );
        } else if (state is ForgotPasswordEmailVerificationSuccess &&
            state.email == currentEmail) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
            title: Text('Código reenviado'),
            description: Text(l10n.otpResendSuccessMessage(state.email)),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
            animationDuration: const Duration(milliseconds: 300),
            showIcon: true,
            showProgressBar: false,
          );
        } else if (state is ForgotPasswordEmailVerificationFailure &&
            state.email == currentEmail) {
          CustomConfirmationModal.showSimple(
            context: context,
            title: l10n.operationErrorTitle,
            subtitle: state.message,
            confirmButtonText: l10n.accept,
            confirmButtonColor: const Color(0xFFDC2626),
            width: 420,
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
          // onGoBack: () {
          //   context.read<ForgotPasswordBloc>().add(ForgotPasswordReset());
          //   context.goNamed(AppRoutes.forgotPassword);
          // },
        ),
      ),
    );
  }
}
