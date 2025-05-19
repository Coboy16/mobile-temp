part of 'sidebar_bloc.dart';

class SidebarState extends Equatable {
  final String currentSelectedRoute;
  final bool isSidebarExpanded;
  final Set<String> expandedParentRoutes;
  final bool isSmallScreenLayout; // Renamed from isMobileLayout for clarity

  const SidebarState({
    required this.currentSelectedRoute,
    required this.isSidebarExpanded,
    required this.expandedParentRoutes,
    this.isSmallScreenLayout = false,
  });

  factory SidebarState.initial({
    String initialRoute = 'Solicitudes',
    String? initialParentRoute,
    bool initialIsSmallScreen = false,
  }) {
    final initialExpandedRoutes = <String>{};
    if (initialParentRoute != null) {
      initialExpandedRoutes.add(initialParentRoute);
    } else if (initialRoute == 'Solicitudes') {
      initialExpandedRoutes.add('Portal del Empleado');
    }

    return SidebarState(
      currentSelectedRoute: initialRoute,
      isSidebarExpanded:
          !initialIsSmallScreen, // Collapsed by default on small screens
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
