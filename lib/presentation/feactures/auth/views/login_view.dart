import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/presentation/bloc/blocs.dart';
import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/routes/app_router.dart';

import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/feactures/auth/wrapper/wrappers.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Maneja el éxito de la autenticación
  void _handleAuthSuccess(BuildContext context) {
    context.goNamed(AppRoutes.home);
  }

  // Maneja fallos generales de AuthBloc durante el login
  void _handleAuthFailure(BuildContext context, AuthFailure state) {
    // Acción: Mostrar mensaje de error
    _showSnackBar(context, state.message);
  }

  // Maneja el éxito inicial de Google Sign In
  void _handleGoogleSuccess(
    BuildContext context,
    AuthGoogleAuthenticated state,
  ) {
    context.goNamed(AppRoutes.home);
  }

  // Maneja fallos durante el proceso de Google Sign In
  void _handleGoogleFailure(BuildContext context, AuthGoogleError state) {
    //TODO:  cambiar por modal
    _showSnackBar(context, state.message);
  }

  // Maneja la cancelación o desautenticación de Google
  void _handleGoogleUnauthenticated(
    BuildContext context,
    AuthGoogleUnauthenticated state,
  ) {
    if (state.message != null) {
      _showSnackBar(context, state.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              _handleAuthSuccess(context);
            } else if (state is AuthFailure) {
              _handleAuthFailure(context, state);
            }
          },
        ),
        BlocListener<AuthGoogleBloc, AuthGoogleState>(
          listener: (context, state) {
            if (state is AuthGoogleAuthenticated) {
              _handleGoogleSuccess(context, state);
            } else if (state is AuthGoogleError) {
              _handleGoogleFailure(context, state);
            } else if (state is AuthGoogleUnauthenticated) {
              _handleGoogleUnauthenticated(context, state);
            }
          },
        ),
      ],
      child: AuthLayout(
        authView: AuthView.login,
        rightPanelContent: LoginBlocWrapper(
          onGoToRegister: () => context.goNamed(AppRoutes.register),
          onGoToForgotPassword: () => context.goNamed(AppRoutes.forgotPassword),
        ),
      ),
    );
  }
}
