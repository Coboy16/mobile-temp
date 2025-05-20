// lib/presentation/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:fe_core_vips/core/injection/di.dart';
import 'package:fe_core_vips/domain/use_cases/use_cases.dart';

import '/presentation/feactures/splash/splash.dart';
import '/presentation/feactures/auth/auth.dart';
import '/presentation/feactures/home/home.dart';
// Asegúrate que PerfilScreen esté importada si usas la ruta /profile original
// import '/presentation/feactures/perfil/perfil.dart';
import '/presentation/widgets/sidebar/sidebar_menu_constants.dart';
import 'go_router_refresh_stream.dart';

class AppRoutes {
  // --- Tus constantes originales de paths y segmentos (SIN CAMBIOS) ---
  static const String splash = '/';
  static const String auth = '/auth';
  static const String authRegister = 'register';
  static const String authRegisterOtp = 'register-otp';
  static const String authForgotPassword = 'forgot-password';
  static const String authOtp = 'otp';
  static const String home = '/home'; // Será la ruta base para las subrutas
  static const String authNewPassword = 'new-password';

  static const String login = auth;
  static const String register = '$auth/$authRegister';
  static const String registerOtp = '$auth/$authRegisterOtp';
  static const String forgotPassword = '$auth/$authForgotPassword';
  static const String otp = '$auth/$authOtp';
  static const String newPasswordForm = '$auth/$authNewPassword';
  // --- Fin constantes originales ---

  // --- NUEVOS: SEGMENTOS de Path para sub-rutas de Home ---
  static const String homeSubRequest = 'request';
  static const String homeSubCheckPayment = 'check-payment';
  static const String homeSubInformeCursos = 'informe-cursos';
  static const String homeSubColaAprobacion = 'cola-aprobacion';
  static const String homeSubOfertasTrabajo = 'ofertas-trabajo';
  static const String homeSubCandidatos = 'candidatos';
  static const String homeSubPortalPublico = 'portal-publico';
  static const String homeSubPruebasPsicometricas = 'pruebas-psicometricas';
  static const String homeSubAjustes = 'ajustes';
  static const String homeSubSubitemCandidato = 'subitem-candidato';
  static const String homeSubMisPostulaciones = 'mis-postulaciones';
  static const String homeSubMiPerfilCandidato = 'mi-perfil-candidato';
  static const String homeSubEvaluacionDesempeno = 'evaluacion-desempeno';
  static const String homeSubConsolidacion = 'consolidacion';
  static const String homeSubCalculosImpositivos = 'calculos-impositivos';
  static const String homeSubProfileUserSystem = 'profile-user-system';
  static const String homeSubAyudaSoporte = 'ayuda-soporte';
  static const String homeSubConfiguracion = 'configuracion';

  // --- NUEVOS: NOMBRES DE RUTA para usar con context.goNamed() SOLO PARA LAS SUBRUTAS DE HOME ---
  // Para auth, seguiremos usando tus paths como nombres para no romper tu SplashScreen.
  // La recomendación sigue siendo usar nombres únicos, pero para cumplir tu requisito:
  static const String homeRequestName =
      'homeRequest'; // Nombres simples y únicos para subrutas de home
  static const String homeCheckPaymentName = 'homeCheckPayment';
  static const String homeInformeCursosName = 'homeInformeCursos';
  static const String homeColaAprobacionName = 'homeColaAprobacion';
  static const String homeOfertasTrabajoName = 'homeOfertasTrabajo';
  static const String homeCandidatosName = 'homeCandidatos';
  static const String homePortalPublicoName = 'homePortalPublico';
  static const String homePruebasPsicometricasName = 'homePruebasPsicometricas';
  static const String homeAjustesName = 'homeAjustes';
  static const String homeSubitemCandidatoName = 'homeSubitemCandidato';
  static const String homeMisPostulacionesName = 'homeMisPostulaciones';
  static const String homeMiPerfilCandidatoName = 'homeMiPerfilCandidato';
  static const String homeEvaluacionDesempenoName = 'homeEvaluacionDesempeno';
  static const String homeConsolidacionName = 'homeConsolidacion';
  static const String homeCalculosImpositivosName = 'homeCalculosImpositivos';
  static const String homeProfileUserSystemName = 'homeProfileUserSystem';
  static const String homeAyudaSoporteName = 'homeAyudaSoporte';
  static const String homeConfiguracionName = 'homeConfiguracion';
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

      // Tu lógica original de redirect se mantiene aquí.
      final authRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.registerOtp,
        AppRoutes.forgotPassword,
        AppRoutes.otp,
        AppRoutes.newPasswordForm,
      ];
      final bool isTryingToAccessAuthPath = location.startsWith(AppRoutes.auth);
      final bool isGoingToSplash = location == AppRoutes.splash;

      if (isGoingToSplash) return null;

      if (loggedIn && isTryingToAccessAuthPath) {
        return '${AppRoutes.home}/${AppRoutes.homeSubRequest}'; // Redirige a path de subruta home
      }

      if (!loggedIn && !isTryingToAccessAuthPath && !isGoingToSplash) {
        return AppRoutes.login; // Redirige a path '/auth'
      }

      if (loggedIn && location == AppRoutes.home) {
        return '${AppRoutes.home}/${AppRoutes.homeSubRequest}'; // Redirige a path de subruta home
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash, // Es '/'
        name: AppRoutes.splash, // Usas '/' como nombre
        builder:
            (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth, // Es '/auth'
        name: AppRoutes.login, // Usas '/auth' como nombre para esta ruta padre
        builder:
            (BuildContext context, GoRouterState state) => const LoginView(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.authRegister, // Es 'register' (segmento)
            name: AppRoutes.register, // Usas '/auth/register' como nombre
            builder:
                (BuildContext context, GoRouterState state) =>
                    const RegisterView(),
          ),
          GoRoute(
            path: AppRoutes.authRegisterOtp, // Es 'register-otp' (segmento)
            name:
                AppRoutes.registerOtp, // Usas '/auth/register-otp' como nombre
            builder: (BuildContext context, GoRouterState state) {
              final args = state.extra as RegisterOtpViewArguments?;
              if (args == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => context.goNamed(AppRoutes.register),
                ); // Usa el nombre (que es path)
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
            builder:
                (BuildContext context, GoRouterState state) =>
                    const ForgotPasswordEmailView(),
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
            path: AppRoutes.authNewPassword,
            name: AppRoutes.newPasswordForm,
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
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => context.goNamed(AppRoutes.forgotPassword),
              ); // Usa el nombre (que es path)
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
      // --- CONFIGURACIÓN PARA /HOME CON SUBRUTAS ---
      GoRoute(
        path: AppRoutes.home, // Es '/home'
        name:
            AppRoutes.home, // Usas '/home' como nombre para la ruta padre /home
        redirect: (context, state) {
          if (state.matchedLocation == AppRoutes.home) {
            return '${AppRoutes.home}/${AppRoutes.homeSubRequest}'; // Navega a path
          }
          return null;
        },
        // El builder para /home (AppRoutes.home) puede ser necesario si el redirect no siempre aplica.
        // builder: (context, state) => const HomeScreen(currentRouteKeyFromRouter: AppSidebarMenuRoutes.solicitudes),
        routes: <RouteBase>[
          GoRoute(
            path:
                AppRoutes
                    .homeSubRequest, // 'request' (segmento relativo a /home)
            name: AppRoutes.homeRequestName, // NOMBRE ÚNICO: 'homeRequest'
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.solicitudes,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubCheckPayment,
            name: AppRoutes.homeCheckPaymentName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.comprobantesPago,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubInformeCursos,
            name: AppRoutes.homeInformeCursosName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.informeCursos,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubColaAprobacion,
            name: AppRoutes.homeColaAprobacionName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.colaAprobacion,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubOfertasTrabajo,
            name: AppRoutes.homeOfertasTrabajoName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.ofertasTrabajo,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubCandidatos,
            name: AppRoutes.homeCandidatosName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.candidatos,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubPortalPublico,
            name: AppRoutes.homePortalPublicoName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.portalPublico,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubPruebasPsicometricas,
            name: AppRoutes.homePruebasPsicometricasName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.pruebasPsicometricas,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubAjustes,
            name: AppRoutes.homeAjustesName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.ajustes,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubSubitemCandidato,
            name: AppRoutes.homeSubitemCandidatoName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.subitemCandidato,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubMisPostulaciones,
            name: AppRoutes.homeMisPostulacionesName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.misPostulaciones,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubMiPerfilCandidato,
            name: AppRoutes.homeMiPerfilCandidatoName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.miPerfilCandidato,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubEvaluacionDesempeno,
            name: AppRoutes.homeEvaluacionDesempenoName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.evaluacionDesempeno,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubConsolidacion,
            name: AppRoutes.homeConsolidacionName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.consolidacion,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubCalculosImpositivos,
            name: AppRoutes.homeCalculosImpositivosName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.calculosImpositivos,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubProfileUserSystem, // 'profile-user-system'
            name: AppRoutes.homeProfileUserSystemName, // NOMBRE ÚNICO
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter:
                      AppSidebarMenuRoutes.perfilUsuarioSistema,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubAyudaSoporte,
            name: AppRoutes.homeAyudaSoporteName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.ayudaSoporte,
                ),
          ),
          GoRoute(
            path: AppRoutes.homeSubConfiguracion,
            name: AppRoutes.homeConfiguracionName,
            builder:
                (context, state) => const HomeScreen(
                  currentRouteKeyFromRouter: AppSidebarMenuRoutes.configuracion,
                ),
          ),
        ],
      ),
      // Si tenías una ruta /profile original e independiente:
      // GoRoute(
      //   path: AppRoutes.profile,
      //   name: AppRoutes.profile, // Usar AppRoutes.profile (path '/profile') como nombre
      //   builder: (BuildContext context, GoRouterState state) => const PerfilScreen(),
      // ),
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
