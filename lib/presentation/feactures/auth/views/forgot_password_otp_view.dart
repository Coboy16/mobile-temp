import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';

class ForgotPasswordOtpView extends StatelessWidget {
  final String? emailForOtp;

  const ForgotPasswordOtpView({super.key, this.emailForOtp});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      authView: AuthView.forgotPasswordOtp,
      emailForOtp: emailForOtp,
      rightPanelContent: ForgotPasswordOtpForm(
        email: emailForOtp ?? '',
        onOtpVerified: (otp) {},
        onResendOtp: () {
          _showSnackBar(context, 'Reenviando OTP...');
        },
        onGoBack: () => context.goNamed(AppRoutes.forgotPassword),
      ),
    );
  }
}
