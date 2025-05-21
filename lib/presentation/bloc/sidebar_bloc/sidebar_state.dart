part of 'sidebar_bloc.dart';

class SidebarState extends Equatable {
  final String currentSelectedRoute;
  final bool isSidebarExpanded;
  final Set<String> expandedParentRoutes;
  final bool isSmallScreenLayout;

  const SidebarState({
    required this.currentSelectedRoute,
    required this.isSidebarExpanded,
    required this.expandedParentRoutes,
    this.isSmallScreenLayout = false,
  });

  factory SidebarState.initial({
    String initialRoute = AppSidebarMenuRoutes.solicitudes,
    String? initialParentRoute,
    bool initialIsSmallScreen = false,
  }) {
    final initialExpandedRoutes = <String>{};
    String determinedParentRoute = "";

    if (initialParentRoute != null && initialParentRoute.isNotEmpty) {
      determinedParentRoute = initialParentRoute;
    } else {
      if ([
        AppSidebarMenuRoutes.solicitudes,
        AppSidebarMenuRoutes.comprobantesPago,
        AppSidebarMenuRoutes.informeCursos,
        AppSidebarMenuRoutes.colaAprobacion,
      ].contains(initialRoute)) {
        determinedParentRoute = AppSidebarMenuRoutes.portalEmpleado;
      } else if ([
        AppSidebarMenuRoutes.ofertasTrabajo,
        AppSidebarMenuRoutes.candidatos,
        AppSidebarMenuRoutes.portalPublico,
        AppSidebarMenuRoutes.pruebasPsicometricas,
        AppSidebarMenuRoutes.ajustes,
      ].contains(initialRoute)) {
        determinedParentRoute = AppSidebarMenuRoutes.reclutamiento;
      } else if ([
        AppSidebarMenuRoutes.subitemCandidato,
        AppSidebarMenuRoutes.misPostulaciones,
        AppSidebarMenuRoutes.miPerfilCandidato,
      ].contains(initialRoute)) {
        determinedParentRoute = AppSidebarMenuRoutes.portalCandidato;
      }
    }

    if (determinedParentRoute.isNotEmpty) {
      initialExpandedRoutes.add(determinedParentRoute);
    }

    if (initialRoute == AppSidebarMenuRoutes.portalEmpleado ||
        initialRoute == AppSidebarMenuRoutes.reclutamiento ||
        initialRoute == AppSidebarMenuRoutes.portalCandidato) {
      initialExpandedRoutes.add(initialRoute);
    }

    return SidebarState(
      currentSelectedRoute: initialRoute,
      isSidebarExpanded: !initialIsSmallScreen,
      expandedParentRoutes: initialExpandedRoutes,
      isSmallScreenLayout: initialIsSmallScreen,
    );
  }

  SidebarState copyWith({
    String? currentSelectedRoute,
    bool? isSidebarExpanded,
    Set<String>? expandedParentRoutes,
    bool? isSmallScreenLayout,
  }) {
    return SidebarState(
      currentSelectedRoute: currentSelectedRoute ?? this.currentSelectedRoute,
      isSidebarExpanded: isSidebarExpanded ?? this.isSidebarExpanded,
      expandedParentRoutes: expandedParentRoutes ?? this.expandedParentRoutes,
      isSmallScreenLayout: isSmallScreenLayout ?? this.isSmallScreenLayout,
    );
  }

  @override
  List<Object?> get props => [
    currentSelectedRoute,
    isSidebarExpanded,
    expandedParentRoutes,
    isSmallScreenLayout,
  ];
}
