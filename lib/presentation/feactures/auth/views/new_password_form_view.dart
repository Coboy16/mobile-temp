import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.passwordChangeSuccessMessage)),
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
