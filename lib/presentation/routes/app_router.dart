import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:fe_core_vips/core/injection/di.dart';
import 'package:fe_core_vips/domain/use_cases/use_cases.dart';

import '/presentation/feactures/splash/splash.dart';
import '/presentation/feactures/auth/auth.dart';
import '/presentation/feactures/home/home.dart';
import '/presentation/widgets/sidebar/sidebar_menu_constants.dart';
import 'go_router_refresh_stream.dart';

import '/presentation/feactures/check_payment/check.dart';
import '/presentation/feactures/request/request.dart';
import '/presentation/feactures/settings/setting.dart';
import '/presentation/feactures/perfil/perfil.dart';

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

  static const String homeRequestName = 'homeRequest';
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

  static const String homeSubRequestDetail = 'request-detail';
  static const String homeRequestDetailName = 'homeRequestDetail';
  static String getRequestDetailPath(String requestId) {
    return '${AppRoutes.home}/${AppRoutes.homeSubRequest}/$requestId';
  }
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
      final String matchedLocation = state.matchedLocation;

      final bool isGoingToSplash = location == AppRoutes.splash;
      final bool isTryingToAccessAuthPath = location.startsWith(AppRoutes.auth);

      if (isGoingToSplash) return null;

      if (loggedIn && isTryingToAccessAuthPath) {
        return '${AppRoutes.home}/${AppRoutes.homeSubRequest}';
      }

      if (!loggedIn && !isTryingToAccessAuthPath && !isGoingToSplash) {
        return AppRoutes.login;
      }

      if (loggedIn &&
          (location == AppRoutes.home || matchedLocation == AppRoutes.home)) {
        return '${AppRoutes.home}/${AppRoutes.homeSubRequest}';
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder:
            (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRoutes.login,
        builder:
            (BuildContext context, GoRouterState state) => const LoginView(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.authRegister,
            name: AppRoutes.register,
            builder:
                (BuildContext context, GoRouterState state) =>
                    const RegisterView(),
          ),
          GoRoute(
            path: AppRoutes.authRegisterOtp,
            name: AppRoutes.registerOtp,
            builder: (BuildContext context, GoRouterState state) {
              final args = state.extra as RegisterOtpViewArguments?;
              if (args == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => context.goNamed(AppRoutes.register),
                );
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
              );
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return HomeScreen(key: state.pageKey, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubRequest}',
            name: AppRoutes.homeRequestName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: const RequestScreen(
                    key: ValueKey(AppSidebarMenuRoutes.solicitudes),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubRequest}/:requestId',
            name: AppRoutes.homeRequestDetailName,
            pageBuilder: (context, state) {
              final requestId = state.pathParameters['requestId'] ?? '';
              return NoTransitionPage(
                child: SolicitudScreen(
                  key: ValueKey('solicitud-$requestId'),
                  requestId: requestId,
                ),
                key: state.pageKey,
                name: state.name,
              );
            },
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubCheckPayment}',
            name: AppRoutes.homeCheckPaymentName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: const CheckPaymentScreen(
                    key: ValueKey(AppSidebarMenuRoutes.comprobantesPago),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubInformeCursos}',
            name: AppRoutes.homeInformeCursosName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.informeCursos),
                    child: Text(AppSidebarMenuRoutes.informeCursos),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubColaAprobacion}',
            name: AppRoutes.homeColaAprobacionName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.colaAprobacion),
                    child: Text(AppSidebarMenuRoutes.colaAprobacion),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubOfertasTrabajo}',
            name: AppRoutes.homeOfertasTrabajoName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.ofertasTrabajo),
                    child: Text(AppSidebarMenuRoutes.ofertasTrabajo),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubCandidatos}',
            name: AppRoutes.homeCandidatosName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.candidatos),
                    child: Text(AppSidebarMenuRoutes.candidatos),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubPortalPublico}',
            name: AppRoutes.homePortalPublicoName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.portalPublico),
                    child: Text(AppSidebarMenuRoutes.portalPublico),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubPruebasPsicometricas}',
            name: AppRoutes.homePruebasPsicometricasName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(
                      AppSidebarMenuRoutes.pruebasPsicometricas,
                    ),
                    child: Text(AppSidebarMenuRoutes.pruebasPsicometricas),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubAjustes}',
            name: AppRoutes.homeAjustesName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.ajustes),
                    child: Text(AppSidebarMenuRoutes.ajustes),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubSubitemCandidato}',
            name: AppRoutes.homeSubitemCandidatoName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.subitemCandidato),
                    child: Text(AppSidebarMenuRoutes.subitemCandidato),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubMisPostulaciones}',
            name: AppRoutes.homeMisPostulacionesName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.misPostulaciones),
                    child: Text(AppSidebarMenuRoutes.misPostulaciones),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubMiPerfilCandidato}',
            name: AppRoutes.homeMiPerfilCandidatoName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.miPerfilCandidato),
                    child: Text(AppSidebarMenuRoutes.miPerfilCandidato),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubEvaluacionDesempeno}',
            name: AppRoutes.homeEvaluacionDesempenoName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(
                      AppSidebarMenuRoutes.evaluacionDesempeno,
                    ),
                    child: Text(AppSidebarMenuRoutes.evaluacionDesempeno),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubConsolidacion}',
            name: AppRoutes.homeConsolidacionName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.consolidacion),
                    child: Text(AppSidebarMenuRoutes.consolidacion),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubCalculosImpositivos}',
            name: AppRoutes.homeCalculosImpositivosName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(
                      AppSidebarMenuRoutes.calculosImpositivos,
                    ),
                    child: Text(AppSidebarMenuRoutes.calculosImpositivos),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubProfileUserSystem}',
            name: AppRoutes.homeProfileUserSystemName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: const PerfilScreen(
                    key: ValueKey(AppSidebarMenuRoutes.perfilUsuarioSistema),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubAyudaSoporte}',
            name: AppRoutes.homeAyudaSoporteName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: Center(
                    key: const ValueKey(AppSidebarMenuRoutes.ayudaSoporte),
                    child: Text(AppSidebarMenuRoutes.ayudaSoporte),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
          GoRoute(
            path: '${AppRoutes.home}/${AppRoutes.homeSubConfiguracion}',
            name: AppRoutes.homeConfiguracionName,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: SettingsScreen(
                    key: ValueKey(AppSidebarMenuRoutes.configuracion),
                  ),
                  key: state.pageKey,
                  name: state.name,
                ),
          ),
        ],
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
