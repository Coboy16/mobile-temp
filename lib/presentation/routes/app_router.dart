import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/splash/splash.dart';
import '/presentation/feactures/auth/auth.dart';
import '/presentation/feactures/home/home.dart';

class AppRoutes {
  static const String splash = '/'; // Ruta raíz
  static const String auth = '/auth';
  static const String authRegister = 'register';
  static const String authForgotPassword = 'forgot-password';
  static const String authOtp = 'otp';
  static const String home = '/home';

  // Nombres completos para goNamed
  static const String login = auth;
  static const String register = '$auth/$authRegister';
  static const String forgotPassword = '$auth/$authForgotPassword';
  static const String otp = '$auth/$authOtp';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    // --- Definición de las rutas ---
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRoutes.login, // Usar nombre específico
        builder: (BuildContext context, GoRouterState state) {
          // Redirige a LoginView directamente
          return const LoginView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.authRegister,
            name: AppRoutes.register, // Usar nombre específico
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterView();
            },
          ),
          GoRoute(
            path: AppRoutes.authForgotPassword,
            name: AppRoutes.forgotPassword, // Usar nombre específico
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordEmailView();
            },
          ),
          GoRoute(
            path: AppRoutes.authOtp,
            name: AppRoutes.otp, // Usar nombre específico
            builder: (BuildContext context, GoRouterState state) {
              // Pasa el email como parámetro de ruta (o extra)
              // Usaremos extra aquí por simplicidad
              final email = state.extra as String?;
              return ForgotPasswordOtpView(emailForOtp: email);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],

    // --- Manejo de Errores  ---
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Página no encontrada')),
          body: Center(
            child: Text(
              'Error: ${state.error?.message ?? 'Ruta no encontrada'}',
            ),
          ),
        ),
  );
}
