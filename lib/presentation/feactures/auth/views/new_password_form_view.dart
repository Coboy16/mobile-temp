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

class NewPasswordFormViewArguments {
  final String email;
  final String otp;

  NewPasswordFormViewArguments({required this.email, required this.otp});
}

class NewPasswordFormView extends StatelessWidget {
  final NewPasswordFormViewArguments args;

  const NewPasswordFormView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordChangeSuccess && state.email == args.email) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
            title: Text(l10n.passwordChangeSuccessTitle),
            description: Text(l10n.passwordChangeSuccessMessage),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
            animationDuration: const Duration(milliseconds: 300),
            showIcon: true,
            showProgressBar: false,
          );
          context.read<ForgotPasswordBloc>().add(ForgotPasswordReset());
          context.goNamed(AppRoutes.login);
        } else if (state is ForgotPasswordChangeFailure &&
            state.email == args.email) {
          showDialog(
            context: context,
            builder: (_) => RegistrationFailedDialog(message: state.message),
          );
        }
      },
      child: AuthLayout(
        authView: AuthView.setNewPassword, // Cambio aquí
        emailForOtp: args.email,
        rightPanelContent: NewPasswordFormWidget(
          email: args.email,
          otp: args.otp,
          onSubmit: (newPassword) {
            context.read<ForgotPasswordBloc>().add(
              ForgotPasswordNewPasswordSubmitted(
                email: args.email,
                newPassword: newPassword,
              ),
            );
          },
        ),
      ),
    );
  }
}
