import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart';
import '/core/l10n/app_localizations.dart';
import '/presentation/bloc/blocs.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void _showToast(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    toastification.show(
      context: context,
      type: isError ? ToastificationType.error : ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: Text(isError ? 'Error' : 'Información'),
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: Duration(seconds: isError ? 5 : 4),
      animationDuration: const Duration(milliseconds: 300),
      showIcon: true,
      showProgressBar: false,
    );
  }

  void _showLoginSuccessToast(
    BuildContext context, {
    bool isGoogleLogin = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(l10n.loginSuccessTitle),
      description: Text(
        isGoogleLogin
            ? l10n.loginSuccessGoogleMessage
            : l10n.loginSuccessMessage,
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      showIcon: true,
      showProgressBar: false,
    );
  }

  void _handleAuthSuccess(BuildContext context) {
    _showLoginSuccessToast(context, isGoogleLogin: false);

    Future.delayed(const Duration(milliseconds: 500), () {
      context.goNamed(AppRoutes.homeRequestName);
    });
  }

  void _handleAuthLoginFailure(BuildContext context, AuthFailure state) {
    debugPrint(
      'Error de login post-registro (AuthBloc): ${state.message}, statusCode: ${state.statusCode}',
    );

    final l10n = AppLocalizations.of(context)!;
    CustomConfirmationModal.showSimple(
      context: context,
      title: l10n.authLoginErrorTitle,
      subtitle:
          'Error al iniciar sesión después del registro: ${state.message}',
      confirmButtonText: l10n.accept,
      confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
      width: 450,
    );
  }

  void _handleGoogleLoginFailure(BuildContext context, AuthGoogleError state) {
    debugPrint(
      'Error de login post-registro (AuthGoogleBloc): ${state.message}, statusCode: ${state.statusCode}',
    );

    final l10n = AppLocalizations.of(context)!;
    CustomConfirmationModal.showSimple(
      context: context,
      title: l10n.googleLoginErrorTitle,
      subtitle:
          'Error al iniciar sesión con Google después del registro: ${state.message}',
      confirmButtonText: l10n.accept,
      confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
      width: 450,
    );
  }

  void _handleGoogleUnauthenticated(
    BuildContext context,
    AuthGoogleUnauthenticated state,
  ) {
    if (state.message != null) {
      _showToast(context, state.message!, isError: true);
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
