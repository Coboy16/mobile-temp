import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/widgets/widgets.dart';

class ExpandedSidebarContent extends StatelessWidget {
  final String currentRoute;
  final List<String> portalEmpleadoRoutes;
  final List<String> reclutamientoRoutes;
  final List<String> portalCandidatoRoutes;
  final bool isPortalEmpleadoSelected;
  final bool isReclutamientoSelected;
  final bool isPortalCandidatoSelected;
  final Function(int) onNavigate;

  const ExpandedSidebarContent({
    super.key,
    required this.currentRoute,
    required this.portalEmpleadoRoutes,
    required this.reclutamientoRoutes,
    required this.portalCandidatoRoutes,
    required this.isPortalEmpleadoSelected,
    required this.isReclutamientoSelected,
    required this.isPortalCandidatoSelected,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('expanded_content'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SidebarExpansionItem(
          title: 'Portal del Empleado',
          icon: LucideIcons.fileText,
          initiallyExpanded: true,
          forceExpanded: isPortalEmpleadoSelected,
          isParentSelected: isPortalEmpleadoSelected,
          childrenRoutes: portalEmpleadoRoutes,
          children: [
            SidebarItem(
              title: 'Solicitudes',
              icon: LucideIcons.fileText,
              isSelected: currentRoute == 'Solicitudes',
              isChild: true,
              onTap: () => onNavigate(0),
            ),
            SidebarItem(
              title: 'Comprobantes de Pago',
              icon: LucideIcons.receipt,
              isSelected: currentRoute == 'Comprobantes de Pago',
              isChild: true,
              onTap: () => onNavigate(1),
            ),
            SidebarItem(
              title: 'Informe de Cursos',
              icon: LucideIcons.graduationCap,
              isSelected: currentRoute == 'Informe de Cursos',
              isChild: true,
              onTap: () => print('Navegar a Cursos'),
            ),
            SidebarItem(
              title: 'Cola de Aprobación',
              icon: LucideIcons.fileCheck,
              isSelected: currentRoute == 'Cola de Aprobación',
              isChild: true,
              onTap: () => print('Navegar a Cola de Aprobación'),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: 'Reclutamiento',
          icon: LucideIcons.users,
          initiallyExpanded: false,
          forceExpanded: isReclutamientoSelected,
          isParentSelected: isReclutamientoSelected,
          childrenRoutes: reclutamientoRoutes,
          children: [
            SidebarItem(
              title: 'Ofertas de Trabajo',
              icon: LucideIcons.briefcase,
              isSelected: currentRoute == 'Ofertas de Trabajo',
              isChild: true,
              onTap: () => print('Navegar a Ofertas de Trabajo'),
            ),
            SidebarItem(
              title: 'Candidatos',
              icon: LucideIcons.users,
              isSelected: currentRoute == 'Candidatos',
              isChild: true,
              onTap: () => print('Navegar a Candidatos'),
            ),
            SidebarItem(
              title: 'Portal Público',
              icon: LucideIcons.globe,
              isSelected: currentRoute == 'Portal Público',
              isChild: true,
              onTap: () => print('Navegar a Portal Público'),
            ),
            SidebarItem(
              title: 'Pruebas Psicométricas',
              icon: LucideIcons.brain,
              isSelected: currentRoute == 'Pruebas Psicométricas',
              isChild: true,
              onTap: () => print('Navegar a Pruebas Psicométricas'),
            ),
            SidebarItem(
              title: 'Ajustes',
              icon: LucideIcons.settings,
              isSelected: currentRoute == 'Ajustes',
              isChild: true,
              onTap: () => print('Navegar a Ajustes'),
            ),
          ],
        ),
        SidebarExpansionItem(
          title: 'Portal del Candidato',
          icon: LucideIcons.contact,
          initiallyExpanded: false,
          forceExpanded: isPortalCandidatoSelected,
          isParentSelected: isPortalCandidatoSelected,
          childrenRoutes: portalCandidatoRoutes,
          children: [
            SidebarItem(
              title: 'Subitem Candidato',
              icon: LucideIcons.userSearch,
              isChild: true,
              onTap: () {}, // Añadimos callback vacío para evitar null
            ),
            SidebarItem(
              title: 'Mis Postulaciones',
              icon: LucideIcons.clipboardList,
              isSelected: currentRoute == 'Mis Postulaciones',
              isChild: true,
              onTap: () => print('Navegar a Mis Postulaciones'),
            ),
            SidebarItem(
              title: 'Mi Perfil',
              icon: LucideIcons.circleUser,
              isSelected: currentRoute == 'Mi Perfil',
              isChild: true,
              onTap: () => print('Navegar a Mi Perfil'),
            ),
          ],
        ),
        SidebarItem(
          title: 'Evaluación de desempeño',
          icon: LucideIcons.chartLine,
          isSelected: currentRoute == 'Evaluación de desempeño',
          onTap: () => print('Navegar a Evaluación de desempeño'),
        ),
        SidebarItem(
          title: 'Consolidación',
          icon: LucideIcons.layers,
          isSelected: currentRoute == 'Consolidación',
          onTap: () => print('Navegar a Consolidación'),
        ),
        SidebarItem(
          title: 'Cálculos Impositivos',
          icon: LucideIcons.calculator,
          isSelected: currentRoute == 'Cálculos Impositivos',
          onTap: () => print('Navegar a Cálculos Impositivos'),
        ),
      ],
    );
  }
}
