import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';

class ForgotPasswordEmailView extends StatelessWidget {
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      authView: AuthView.forgotPasswordEmail,
      rightPanelContent: ForgotPasswordEmailForm(
        onEmailSubmitted: (email) {
          context.goNamed(AppRoutes.otp, extra: email);
        },
        onGoToLogin: () => context.goNamed(AppRoutes.login),
      ),
    );
  }
}
