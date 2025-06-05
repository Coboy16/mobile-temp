import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/bloc/blocs.dart';
import '/presentation/routes/route_utils.dart';

String getSidebarConstantForGoRouterName(String? goRouterName) {
  if (goRouterName == null || goRouterName.isEmpty) {
    debugPrint(
      "[getSidebarConstantForGoRouterName] Received null or empty router name, returning fallback (Solicitudes).",
    );
    return AppSidebarMenuRoutes.solicitudes;
  }

  switch (goRouterName) {
    case AppRoutes.homeRequestName:
      return AppSidebarMenuRoutes.solicitudes;
    case AppRoutes.homeCheckPaymentName:
      return AppSidebarMenuRoutes.comprobantesPago;
    case AppRoutes.homeInformeCursosName:
      return AppSidebarMenuRoutes.informeCursos;
    case AppRoutes.homeColaAprobacionName:
      return AppSidebarMenuRoutes.colaAprobacion;
    case AppRoutes.homeOfertasTrabajoName:
      return AppSidebarMenuRoutes.ofertasTrabajo;
    case AppRoutes.homeCandidatosName:
      return AppSidebarMenuRoutes.candidatos;
    case AppRoutes.homePortalPublicoName:
      return AppSidebarMenuRoutes.portalPublico;
    case AppRoutes.homePruebasPsicometricasName:
      return AppSidebarMenuRoutes.pruebasPsicometricas;
    case AppRoutes.homeAjustesName:
      return AppSidebarMenuRoutes.ajustes;
    case AppRoutes.homeSubitemCandidatoName:
      return AppSidebarMenuRoutes.subitemCandidato;
    case AppRoutes.homeMisPostulacionesName:
      return AppSidebarMenuRoutes.misPostulaciones;
    case AppRoutes.homeMiPerfilCandidatoName:
      return AppSidebarMenuRoutes.miPerfilCandidato;
    case AppRoutes.homeEvaluacionDesempenoName:
      return AppSidebarMenuRoutes.evaluacionDesempeno;
    case AppRoutes.homeConsolidacionName:
      return AppSidebarMenuRoutes.consolidacion;
    case AppRoutes.homeCalculosImpositivosName:
      return AppSidebarMenuRoutes.calculosImpositivos;
    case AppRoutes.homeProfileUserSystemName:
      return AppSidebarMenuRoutes.perfilUsuarioSistema;
    case AppRoutes.homeAyudaSoporteName:
      return AppSidebarMenuRoutes.ayudaSoporte;
    case AppRoutes.homeConfiguracionName:
      return AppSidebarMenuRoutes.configuracion;
    default:
      debugPrint(
        "[getSidebarConstantForGoRouterName] Unknown router name '$goRouterName', returning fallback (Solicitudes).",
      );
      return AppSidebarMenuRoutes.solicitudes;
  }
}

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint(
      "[HomeScreen Shell initState] (Instance: $hashCode) Key: ${widget.key}",
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScreenSize();
      _syncSidebarWithGoRouterState();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScreenSize();
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint(
      "[HomeScreen Shell didUpdateWidget] (Instance: $hashCode) New Key: ${widget.key}, Old Key: ${oldWidget.key}",
    );
    if (widget.key != oldWidget.key ||
        widget.child.key != oldWidget.child.key) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkScreenSize();
        _syncSidebarWithGoRouterState();
      });
    }
  }

  void _checkScreenSize() {
    if (!mounted) return;

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen =
        screenWidth < 768; // Breakpoint para pantallas pequeñas

    final sidebarBloc = context.read<SidebarBloc>();
    final currentIsSmallScreen = sidebarBloc.state.isSmallScreenLayout;

    debugPrint(
      "[HomeScreen Shell _checkScreenSize] Screen width: $screenWidth, isSmallScreen: $isSmallScreen, currentBlocState: $currentIsSmallScreen",
    );

    if (currentIsSmallScreen != isSmallScreen) {
      debugPrint(
        "[HomeScreen Shell _checkScreenSize] Updating screen layout: $isSmallScreen",
      );
      sidebarBloc.add(SidebarLayoutChanged(isSmallScreen));
    }
  }

  void _syncSidebarWithGoRouterState() {
    if (!mounted) return;

    final GoRouterState goState = GoRouterState.of(context);
    final String currentRouteNameFromRouter =
        goState.name ?? ''; // Nombre de la ruta hija actual
    final String sidebarConstant = getSidebarConstantForGoRouterName(
      currentRouteNameFromRouter,
    );

    final sidebarBloc = context.read<SidebarBloc>();
    debugPrint(
      "[HomeScreen Shell _syncSidebar] (Instance: $hashCode) Router name from GoState: '$currentRouteNameFromRouter', Mapped to sidebar constant: '$sidebarConstant'. Current BLoC state: '${sidebarBloc.state.currentSelectedRoute}'",
    );

    if (sidebarConstant.isNotEmpty &&
        sidebarBloc.state.currentSelectedRoute != sidebarConstant) {
      debugPrint(
        "[HomeScreen Shell _syncSidebar] ---> Dispatching SidebarRouteSelected: '$sidebarConstant' because BLoC ('${sidebarBloc.state.currentSelectedRoute}') != Mapped Router ('$sidebarConstant')",
      );

      String? parentRouteName;
      bool isParentItem = false;
      if (AppSidebarMenuRoutes.solicitudes == sidebarConstant ||
          AppSidebarMenuRoutes.comprobantesPago == sidebarConstant ||
          AppSidebarMenuRoutes.informeCursos == sidebarConstant ||
          AppSidebarMenuRoutes.colaAprobacion == sidebarConstant) {
        parentRouteName = AppSidebarMenuRoutes.portalEmpleado;
      } else if (AppSidebarMenuRoutes.ofertasTrabajo == sidebarConstant ||
          AppSidebarMenuRoutes.candidatos == sidebarConstant ||
          AppSidebarMenuRoutes.portalPublico == sidebarConstant ||
          AppSidebarMenuRoutes.pruebasPsicometricas == sidebarConstant ||
          AppSidebarMenuRoutes.ajustes == sidebarConstant) {
        parentRouteName = AppSidebarMenuRoutes.reclutamiento;
      } else if (AppSidebarMenuRoutes.subitemCandidato == sidebarConstant ||
          AppSidebarMenuRoutes.misPostulaciones == sidebarConstant ||
          AppSidebarMenuRoutes.miPerfilCandidato == sidebarConstant) {
        parentRouteName = AppSidebarMenuRoutes.portalCandidato;
      }

      if (sidebarConstant == AppSidebarMenuRoutes.portalEmpleado ||
          sidebarConstant == AppSidebarMenuRoutes.reclutamiento ||
          sidebarConstant == AppSidebarMenuRoutes.portalCandidato) {
        isParentItem = true;
      }
      sidebarBloc.add(
        SidebarRouteSelected(
          sidebarConstant,
          parentRouteName: parentRouteName,
          isParentItem: isParentItem,
        ),
      );
    } else {
      debugPrint(
        "[HomeScreen Shell _syncSidebar] ---> No SidebarBloc update needed. BLoC ('${sidebarBloc.state.currentSelectedRoute}') == Mapped Router ('$sidebarConstant') or sidebarConstant is empty.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState goStateForBuild = GoRouterState.of(context);
    debugPrint(
      "[HomeScreen Shell build] (Instance: $hashCode). Child: ${widget.child.runtimeType}, Child Key: ${widget.child.key}, HomeScreen Key: ${widget.key}",
    );
    debugPrint(
      "[HomeScreen Shell build] GoRouterState NAME: '${goStateForBuild.name}', FullPath: '${goStateForBuild.fullPath}'",
    );

    return BlocListener<SidebarBloc, SidebarState>(
      listenWhen:
          (previous, current) =>
              previous.currentSelectedRoute != current.currentSelectedRoute,
      listener: (context, sidebarState) {
        final String blocSelectedConstant = sidebarState.currentSelectedRoute;
        final String targetGoRouterPath = getGoRouterPathForSidebarRoute(
          blocSelectedConstant,
        );

        final GoRouterState currentGoRouterStateListener = GoRouterState.of(
          context,
        );
        final String? currentActualPathListener =
            currentGoRouterStateListener.fullPath;

        debugPrint("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        debugPrint("[HomeScreen Shell BlocListener] (Instance: $hashCode)");
        debugPrint("  Bloc wants to go to (constant): '$blocSelectedConstant'");
        debugPrint("  Target GoRouter PATH: '$targetGoRouterPath'");
        debugPrint("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

        if (targetGoRouterPath.isNotEmpty &&
            targetGoRouterPath != currentActualPathListener) {
          debugPrint(
            "[HomeScreen Shell BlocListener] DECISION: Navigation needed. Attempting AppRouter.router.go('$targetGoRouterPath')",
          );
          AppRouter.router.go(targetGoRouterPath);
        } else {
          debugPrint(
            "[HomeScreen Shell BlocListener] DECISION: No navigation by PATH needed. Target: '$targetGoRouterPath', Current: '$currentActualPathListener'.",
          );
        }
      },
      child: BlocBuilder<SidebarBloc, SidebarState>(
        buildWhen:
            (previous, current) =>
                previous.isSmallScreenLayout != current.isSmallScreenLayout ||
                previous.isSidebarExpanded != current.isSidebarExpanded,
        builder: (context, sidebarState) {
          final bool isMobilePlatform =
              !kIsWeb && (Platform.isAndroid || Platform.isIOS);

          // Lógica corregida para determinar si usar drawer
          final bool useDrawerLayout =
              isMobilePlatform || sidebarState.isSmallScreenLayout;

          debugPrint(
            "[HomeScreen Shell build] isMobilePlatform: $isMobilePlatform, isSmallScreenLayout: ${sidebarState.isSmallScreenLayout}, useDrawerLayout: $useDrawerLayout",
          );

          return Scaffold(
            key: _scaffoldKey,
            drawer:
                useDrawerLayout
                    ? const SidebarWidget(
                      isDrawer: true,
                    ) // ✅ Pasar isDrawer: true
                    : null,
            drawerScrimColor: Colors.black.withOpacity(0.5),
            onDrawerChanged: (isOpened) {
              debugPrint(
                "[HomeScreen Shell] Drawer changed: isOpened=$isOpened",
              );
              final sidebarBloc = context.read<SidebarBloc>();
              if (!isOpened &&
                  sidebarBloc.state.isSidebarExpanded &&
                  useDrawerLayout) {
                sidebarBloc.add(
                  const SidebarVisibilityToggled(forceState: false),
                );
              }
            },
            body:
                useDrawerLayout
                    ? _buildMobileLayout(context, sidebarState)
                    : _buildWebLayout(context, sidebarState),
          );
        },
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context, SidebarState sidebarState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SidebarWidget(
          isDrawer: false,
        ), // ✅ Explícitamente isDrawer: false para web
        Expanded(
          child: Column(
            children: [
              HeaderWidget(scaffoldKey: _scaffoldKey),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, SidebarState sidebarState) {
    return SafeArea(
      child: Column(
        children: [
          HeaderWidget(scaffoldKey: _scaffoldKey),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
