import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/bloc/blocs.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleAuthSuccess(BuildContext context) {
    context.goNamed(AppRoutes.homeRequestName);
  }

  void _handleAuthLoginFailure(BuildContext context, AuthFailure state) {
    debugPrint(
      'Error de login post-registro (AuthBloc): ${state.message}, statusCode: ${state.statusCode}',
    );
    showDialog(
      context: context,
      builder:
          (_) => RegistrationFailedDialog(
            message:
                'Error al iniciar sesión después del registro: ${state.message}',
          ),
    );
  }

  void _handleGoogleLoginFailure(BuildContext context, AuthGoogleError state) {
    debugPrint(
      'Error de login post-registro (AuthGoogleBloc): ${state.message}, statusCode: ${state.statusCode}',
    );
    showDialog(
      context: context,
      builder:
          (_) => RegistrationFailedDialog(
            message:
                'Error al iniciar sesión con Google después del registro: ${state.message}',
          ),
    );
  }

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
              _handleAuthLoginFailure(context, state);
            }
          },
        ),
        BlocListener<AuthGoogleBloc, AuthGoogleState>(
          listener: (context, state) {
            if (state is AuthGoogleAuthenticated) {
              _handleAuthSuccess(context);
            } else if (state is AuthGoogleError) {
              _handleGoogleLoginFailure(context, state);
            } else if (state is AuthGoogleUnauthenticated) {
              _handleGoogleUnauthenticated(context, state);
            }
          },
        ),
      ],
      child: AuthLayout(
        authView: AuthView.register,
        rightPanelContent: RegisterForm(
          onGoToLogin: () => context.goNamed(AppRoutes.login),
        ),
      ),
    );
  }
}
