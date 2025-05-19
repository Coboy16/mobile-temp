import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/widgets/widgets.dart';

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
        currentRoute == 'Portal del Empleado';
    final bool isReclutamientoParentSelected =
        reclutamientoRoutes.contains(currentRoute) ||
        currentRoute == 'Reclutamiento';
    final bool isPortalCandidatoParentSelected =
        portalCandidatoRoutes.contains(currentRoute) ||
        currentRoute == 'Portal del Candidato';

    return Column(
      key: const ValueKey('expanded_content'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SidebarExpansionItem(
          title: 'Portal del Empleado',
          icon: LucideIcons.fileText,
          isParentSelected: isPortalEmpleadoParentSelected,
          isExpanded: expandedParentRoutes.contains('Portal del Empleado'),
          onToggle: () => onToggleExpansion('Portal del Empleado'),
          onHeaderTap:
              () =>
                  onNavigateToRoute('Portal del Empleado', isParentItem: true),
          childrenRoutes: portalEmpleadoRoutes,
          children: [
            SidebarItem(
              title: 'Solicitudes',
              icon: LucideIcons.fileText,
              isSelected: currentRoute == 'Solicitudes',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Solicitudes',
                    parentRouteName: 'Portal del Empleado',
                  ),
            ),
            SidebarItem(
              title: 'Comprobantes de Pago',
              icon: LucideIcons.receipt,
              isSelected: currentRoute == 'Comprobantes de Pago',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Comprobantes de Pago',
                    parentRouteName: 'Portal del Empleado',
                  ),
            ),
            SidebarItem(
              title: 'Informe de Cursos',
              icon: LucideIcons.graduationCap,
              isSelected: currentRoute == 'Informe de Cursos',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Informe de Cursos',
                    parentRouteName: 'Portal del Empleado',
                  ),
            ),
            SidebarItem(
              title: 'Cola de Aprobación',
              icon: LucideIcons.fileCheck,
              isSelected: currentRoute == 'Cola de Aprobación',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Cola de Aprobación',
                    parentRouteName: 'Portal del Empleado',
                  ),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: 'Reclutamiento',
          icon: LucideIcons.users,
          isParentSelected: isReclutamientoParentSelected,
          isExpanded: expandedParentRoutes.contains('Reclutamiento'),
          onToggle: () => onToggleExpansion('Reclutamiento'),
          onHeaderTap:
              () => onNavigateToRoute('Reclutamiento', isParentItem: true),
          childrenRoutes: reclutamientoRoutes,
          children: [
            SidebarItem(
              title: 'Ofertas de Trabajo',
              icon: LucideIcons.briefcase,
              isSelected: currentRoute == 'Ofertas de Trabajo',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Ofertas de Trabajo',
                    parentRouteName: 'Reclutamiento',
                  ),
            ),
            SidebarItem(
              title: 'Candidatos',
              icon: LucideIcons.users,
              isSelected: currentRoute == 'Candidatos',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Candidatos',
                    parentRouteName: 'Reclutamiento',
                  ),
            ),
            SidebarItem(
              title: 'Portal Público',
              icon: LucideIcons.globe,
              isSelected: currentRoute == 'Portal Público',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Portal Público',
                    parentRouteName: 'Reclutamiento',
                  ),
            ),
            SidebarItem(
              title: 'Pruebas Psicométricas',
              icon: LucideIcons.brain,
              isSelected: currentRoute == 'Pruebas Psicométricas',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Pruebas Psicométricas',
                    parentRouteName: 'Reclutamiento',
                  ),
            ),
            SidebarItem(
              title: 'Ajustes',
              icon: LucideIcons.settings,
              isSelected: currentRoute == 'Ajustes',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Ajustes',
                    parentRouteName: 'Reclutamiento',
                  ),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: 'Portal del Candidato',
          icon: LucideIcons.contact,
          isParentSelected: isPortalCandidatoParentSelected,
          isExpanded: expandedParentRoutes.contains('Portal del Candidato'),
          onToggle: () => onToggleExpansion('Portal del Candidato'),
          onHeaderTap:
              () =>
                  onNavigateToRoute('Portal del Candidato', isParentItem: true),
          childrenRoutes: portalCandidatoRoutes,
          children: [
            SidebarItem(
              title: 'Subitem Candidato',
              icon: LucideIcons.userSearch,
              isSelected: currentRoute == 'Subitem Candidato',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Subitem Candidato',
                    parentRouteName: 'Portal del Candidato',
                  ),
            ),
            SidebarItem(
              title: 'Mis Postulaciones',
              icon: LucideIcons.clipboardList,
              isSelected: currentRoute == 'Mis Postulaciones',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Mis Postulaciones',
                    parentRouteName: 'Portal del Candidato',
                  ),
            ),
            SidebarItem(
              title: 'Mi Perfil',
              icon: LucideIcons.circleUser,
              isSelected: currentRoute == 'Mi Perfil',
              isChild: true,
              onTap:
                  () => onNavigateToRoute(
                    'Mi Perfil',
                    parentRouteName: 'Portal del Candidato',
                  ),
            ),
          ],
        ),
        SidebarItem(
          title: 'Evaluación de desempeño',
          icon: LucideIcons.chartLine,
          isSelected: currentRoute == 'Evaluación de desempeño',
          onTap: () => onNavigateToRoute('Evaluación de desempeño'),
        ),
        SidebarItem(
          title: 'Consolidación',
          icon: LucideIcons.layers,
          isSelected: currentRoute == 'Consolidación',
          onTap: () => onNavigateToRoute('Consolidación'),
        ),
        SidebarItem(
          title: 'Cálculos Impositivos',
          icon: LucideIcons.calculator,
          isSelected: currentRoute == 'Cálculos Impositivos',
          onTap: () => onNavigateToRoute('Cálculos Impositivos'),
        ),
      ],
    );
  }
}
