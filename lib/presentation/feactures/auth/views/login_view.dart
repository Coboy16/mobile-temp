import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

import '/presentation/bloc/blocs.dart';
import '/presentation/feactures/auth/views/auth_layout.dart';
import '/presentation/routes/app_router.dart';

import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/feactures/auth/wrapper/wrappers.dart';
import '/presentation/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _resetChecks(BuildContext context) {
    context.read<CheckLockStatusBloc>().add(ResetCheckLockStatus());
    context.read<CheckSessionStatusBloc>().add(ResetCheckSessionStatus());
  }

  void _showSnackBar(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    CustomConfirmationModal.showSimple(
      context: context,
      title: l10n.invalidCredentialsTitle,
      subtitle: l10n.invalidCredentialsMessage,
      confirmButtonText: l10n.accept,
      confirmButtonColor: const Color(0xFFDC2626), // Rojo para error
      width: 420,
    ).then((value) {
      if (value == true) {
        _resetChecks(context);
      }
    });
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

  // Maneja el éxito de la autenticación
  void _handleAuthSuccess(BuildContext context) {
    _showLoginSuccessToast(context, isGoogleLogin: false);

    Future.delayed(const Duration(milliseconds: 500), () {
      context.goNamed(AppRoutes.homeRequestName);
    });
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
    _showLoginSuccessToast(context, isGoogleLogin: true);

    Future.delayed(const Duration(milliseconds: 500), () {
      context.goNamed(AppRoutes.homeRequestName);
    });
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
