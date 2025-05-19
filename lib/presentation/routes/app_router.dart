import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:fe_core_vips/core/injection/di.dart';
import 'package:fe_core_vips/domain/use_cases/use_cases.dart';

import '/presentation/feactures/splash/splash.dart';
import '/presentation/feactures/auth/auth.dart';
import '/presentation/feactures/home/home.dart';
import 'go_router_refresh_stream.dart';

class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String authRegister = 'register';
  static const String authRegisterOtp = 'register-otp';
  static const String authForgotPassword = 'forgot-password';
  static const String authOtp = 'otp';
  static const String home = '/home';
  static const String authNewPassword = 'new-password';

  static const String login = auth;
  static const String register = '$auth/$authRegister';
  static const String registerOtp = '$auth/$authRegisterOtp';
  static const String forgotPassword = '$auth/$authForgotPassword';
  static const String otp = '$auth/$authOtp';
  static const String newPasswordForm = '$auth/$authNewPassword';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (BuildContext context, GoRouterState state) async {
      final getCurrentUserUseCase = sl<GetCurrentUserUseCase>();
      final failureOrUser = await getCurrentUserUseCase();
      final bool loggedIn = failureOrUser.fold(
        (l) => false,
        (user) => user != null,
      );

      final String location = state.uri.toString();

      final authRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.registerOtp,
        AppRoutes.forgotPassword,
        AppRoutes.otp,
        AppRoutes.newPasswordForm,
      ];

      authRoutes.any((authRoute) {
        if (location == authRoute) return true;
        if (authRoute.startsWith(AppRoutes.auth) &&
            location.startsWith(authRoute)) {
          return true;
        }
        return false;
      });
      final bool isTryingToAccessAuthPath = location.startsWith(AppRoutes.auth);

      final bool isGoingToSplash = location == AppRoutes.splash;

      if (isGoingToSplash) {
        return null;
      }

      // Caso 1: Usuario logueado intenta acceder a rutas de autenticación
      if (loggedIn && isTryingToAccessAuthPath) {
        // Redirigir a home
        return AppRoutes.home;
      }

      // Caso 2: Usuario NO logueado intenta acceder a rutas protegidas (que no son de autenticación ni splash)
      if (!loggedIn && !isTryingToAccessAuthPath && !isGoingToSplash) {
        // Redirigir a login
        return AppRoutes.login;
      }

      // En cualquier otro caso, permitir la navegación (retornar null)
      return null;
    },
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
        name: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginView();
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.authRegister,
            name: AppRoutes.register,
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterView();
            },
          ),
          GoRoute(
            path: AppRoutes.authRegisterOtp,
            name: AppRoutes.registerOtp,
            builder: (BuildContext context, GoRouterState state) {
              final args = state.extra as RegisterOtpViewArguments?;
              if (args == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(AppRoutes.register);
                });
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return RegisterOtpView(registrationArgs: args);
            },
          ),
          GoRoute(
            path: AppRoutes.authForgotPassword,
            name: AppRoutes.forgotPassword,
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordEmailView();
            },
          ),
          GoRoute(
            path: AppRoutes.authOtp,
            name: AppRoutes.otp,
            builder: (BuildContext context, GoRouterState state) {
              final email = state.extra as String?;
              return ForgotPasswordOtpView(emailForOtp: email);
            },
          ),
          GoRoute(
            // NUEVA RUTA AÑADIDA AQUÍ
            path: AppRoutes.authNewPassword, // new-password (relativo a /auth)
            name: AppRoutes.newPasswordForm, // Nombre para /auth/new-password
            builder: (BuildContext context, GoRouterState state) {
              final extra = state.extra as Map<String, String>?;
              if (extra != null &&
                  extra.containsKey('email') &&
                  extra.containsKey('otp')) {
                return NewPasswordFormView(
                  args: NewPasswordFormViewArguments(
                    email: extra['email']!,
                    otp: extra['otp']!,
                  ),
                );
              }
              // Redirigir si los argumentos no son válidos
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  AppRoutes.forgotPassword,
                ); // Usar nombre de ruta
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
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
