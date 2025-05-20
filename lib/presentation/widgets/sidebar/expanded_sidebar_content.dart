import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/widgets/widgets.dart';
import 'sidebar_menu_constants.dart';

typedef NavigateToRouteCallback =
    void Function(
      String routeName, {
      String? parentRouteName,
      bool isParentItem,
    });
typedef ToggleExpansionCallback = void Function(String parentRouteName);

class ExpandedSidebarContent extends StatelessWidget {
  final String currentRoute;
  final Set<String> expandedParentRoutes;
  final List<String> portalEmpleadoRoutes;
  final List<String> reclutamientoRoutes;
  final List<String> portalCandidatoRoutes;
  final NavigateToRouteCallback onNavigateToRoute;
  final ToggleExpansionCallback onToggleExpansion;

  const ExpandedSidebarContent({
    super.key,
    required this.currentRoute,
    required this.expandedParentRoutes,
    required this.portalEmpleadoRoutes,
    required this.reclutamientoRoutes,
    required this.portalCandidatoRoutes,
    required this.onNavigateToRoute,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPortalEmpleadoParentSelected =
        portalEmpleadoRoutes.contains(currentRoute) ||
        currentRoute == AppSidebarMenuRoutes.portalEmpleado;
    final bool isReclutamientoParentSelected =
        reclutamientoRoutes.contains(currentRoute) ||
        currentRoute == AppSidebarMenuRoutes.reclutamiento;
    final bool isPortalCandidatoParentSelected =
        portalCandidatoRoutes.contains(currentRoute) ||
        currentRoute == AppSidebarMenuRoutes.portalCandidato;

    return Column(
      key: const ValueKey('expanded_content'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SidebarExpansionItem(
          title: AppSidebarMenuRoutes.portalEmpleado,
          icon: LucideIcons.fileText,
          isParentSelected: isPortalEmpleadoParentSelected,
          isExpanded: expandedParentRoutes.contains(
            AppSidebarMenuRoutes.portalEmpleado,
          ),
          onToggle:
              () => onToggleExpansion(AppSidebarMenuRoutes.portalEmpleado),
          onHeaderTap:
              () => onNavigateToRoute(
                AppSidebarMenuRoutes.portalEmpleado,
                isParentItem: true,
              ),
          childrenRoutes: portalEmpleadoRoutes,
          children: [
            SidebarItem(
              title: AppSidebarMenuRoutes.solicitudes,
              icon: LucideIcons.fileText,
              isSelected: currentRoute == AppSidebarMenuRoutes.solicitudes,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.solicitudes,
                    parentRouteName: AppSidebarMenuRoutes.portalEmpleado,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.comprobantesPago,
              icon: LucideIcons.receipt,
              isSelected: currentRoute == AppSidebarMenuRoutes.comprobantesPago,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.comprobantesPago,
                    parentRouteName: AppSidebarMenuRoutes.portalEmpleado,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.informeCursos,
              icon: LucideIcons.graduationCap,
              isSelected: currentRoute == AppSidebarMenuRoutes.informeCursos,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.informeCursos,
                    parentRouteName: AppSidebarMenuRoutes.portalEmpleado,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.colaAprobacion,
              icon: LucideIcons.fileCheck,
              isSelected: currentRoute == AppSidebarMenuRoutes.colaAprobacion,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.colaAprobacion,
                    parentRouteName: AppSidebarMenuRoutes.portalEmpleado,
                  ),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: AppSidebarMenuRoutes.reclutamiento,
          icon: LucideIcons.users,
          isParentSelected: isReclutamientoParentSelected,
          isExpanded: expandedParentRoutes.contains(
            AppSidebarMenuRoutes.reclutamiento,
          ),
          onToggle: () => onToggleExpansion(AppSidebarMenuRoutes.reclutamiento),
          onHeaderTap:
              () => onNavigateToRoute(
                AppSidebarMenuRoutes.reclutamiento,
                isParentItem: true,
              ),
          childrenRoutes: reclutamientoRoutes,
          children: [
            SidebarItem(
              title: AppSidebarMenuRoutes.ofertasTrabajo,
              icon: LucideIcons.briefcase,
              isSelected: currentRoute == AppSidebarMenuRoutes.ofertasTrabajo,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.ofertasTrabajo,
                    parentRouteName: AppSidebarMenuRoutes.reclutamiento,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.candidatos,
              icon: LucideIcons.users,
              isSelected: currentRoute == AppSidebarMenuRoutes.candidatos,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.candidatos,
                    parentRouteName: AppSidebarMenuRoutes.reclutamiento,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.portalPublico,
              icon: LucideIcons.globe,
              isSelected: currentRoute == AppSidebarMenuRoutes.portalPublico,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.portalPublico,
                    parentRouteName: AppSidebarMenuRoutes.reclutamiento,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.pruebasPsicometricas,
              icon: LucideIcons.brain,
              isSelected:
                  currentRoute == AppSidebarMenuRoutes.pruebasPsicometricas,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.pruebasPsicometricas,
                    parentRouteName: AppSidebarMenuRoutes.reclutamiento,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.ajustes,
              icon: LucideIcons.settings,
              isSelected: currentRoute == AppSidebarMenuRoutes.ajustes,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.ajustes,
                    parentRouteName: AppSidebarMenuRoutes.reclutamiento,
                  ),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: AppSidebarMenuRoutes.portalCandidato,
          icon: LucideIcons.contact,
          isParentSelected: isPortalCandidatoParentSelected,
          isExpanded: expandedParentRoutes.contains(
            AppSidebarMenuRoutes.portalCandidato,
          ),
          onToggle:
              () => onToggleExpansion(AppSidebarMenuRoutes.portalCandidato),
          onHeaderTap:
              () => onNavigateToRoute(
                AppSidebarMenuRoutes.portalCandidato,
                isParentItem: true,
              ),
          childrenRoutes: portalCandidatoRoutes,
          children: [
            SidebarItem(
              title: AppSidebarMenuRoutes.subitemCandidato,
              icon: LucideIcons.userSearch,
              isSelected: currentRoute == AppSidebarMenuRoutes.subitemCandidato,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.subitemCandidato,
                    parentRouteName: AppSidebarMenuRoutes.portalCandidato,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.misPostulaciones,
              icon: LucideIcons.clipboardList,
              isSelected: currentRoute == AppSidebarMenuRoutes.misPostulaciones,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.misPostulaciones,
                    parentRouteName: AppSidebarMenuRoutes.portalCandidato,
                  ),
            ),
            SidebarItem(
              title: AppSidebarMenuRoutes.miPerfilCandidato,
              icon: LucideIcons.circleUser,
              isSelected:
                  currentRoute == AppSidebarMenuRoutes.miPerfilCandidato,
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    AppSidebarMenuRoutes.miPerfilCandidato,
                    parentRouteName: AppSidebarMenuRoutes.portalCandidato,
                  ),
            ),
          ],
        ),
        // SidebarItem(
        //   title: AppSidebarMenuRoutes.perfilUsuarioSistema,
        //   icon: LucideIcons.userCog,
        //   isSelected: currentRoute == AppSidebarMenuRoutes.perfilUsuarioSistema,
        //   onTap:
        //       () =>
        //           onNavigateToRoute(AppSidebarMenuRoutes.perfilUsuarioSistema),
        // ),
        SidebarItem(
          title: AppSidebarMenuRoutes.evaluacionDesempeno,
          icon: LucideIcons.chartLine,
          paddingEnabled: true,
          isSelected: currentRoute == AppSidebarMenuRoutes.evaluacionDesempeno,
          onTap:
              () => onNavigateToRoute(AppSidebarMenuRoutes.evaluacionDesempeno),
        ),
        SidebarItem(
          title: AppSidebarMenuRoutes.consolidacion,
          icon: LucideIcons.layers,
          paddingEnabled: true,

          isSelected: currentRoute == AppSidebarMenuRoutes.consolidacion,
          onTap: () => onNavigateToRoute(AppSidebarMenuRoutes.consolidacion),
        ),
        SidebarItem(
          title: AppSidebarMenuRoutes.calculosImpositivos,
          icon: LucideIcons.calculator,
          paddingEnabled: true,

          isSelected: currentRoute == AppSidebarMenuRoutes.calculosImpositivos,
          onTap:
              () => onNavigateToRoute(AppSidebarMenuRoutes.calculosImpositivos),
        ),
      ],
    );
  }
}
