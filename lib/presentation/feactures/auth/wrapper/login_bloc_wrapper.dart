import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/presentation/bloc/blocs.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';

class LoginBlocWrapper extends StatelessWidget {
  final VoidCallback onGoToRegister;
  final VoidCallback onGoToForgotPassword;

  const LoginBlocWrapper({
    super.key,
    required this.onGoToRegister,
    required this.onGoToForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final googleBloc = context.read<AuthGoogleBloc>();
    final fcmBloc = context.read<FcmBloc>();

    return LoginForm(
      onGoogleLogin: () {
        googleBloc.add(GoogleSignInRequested());
        fcmBloc.add(FcmGetToken());
      },
      onGoToRegister: onGoToRegister,
      onLogin: (email, passOrCedula) {
        authBloc.add(
          AuthLoginRequested(email: email, cedulaOrPassword: passOrCedula),
        );
      },
      onGoToForgotPassword: onGoToForgotPassword,
    );
  }
}
