import 'package:fe_core_vips/presentation/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/widgets/widgets.dart';

typedef NavigateToRouteCallback =
    void Function(String routeName, {String? parentRouteName});

class CollapsedSidebarContent extends StatelessWidget {
  final String currentRoute;
  final List<String> portalEmpleadoRoutes;
  final List<String> reclutamientoRoutes;
  final List<String> portalCandidatoRoutes;
  final NavigateToRouteCallback onNavigateToRoute;

  const CollapsedSidebarContent({
    super.key,
    required this.currentRoute,
    required this.portalEmpleadoRoutes,
    required this.reclutamientoRoutes,
    required this.portalCandidatoRoutes,
    required this.onNavigateToRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('collapsed_content'),
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCollapsedItem(
          LucideIcons.fileText,
          portalEmpleadoRoutes.contains(currentRoute) ||
              currentRoute == 'Portal del Empleado',
          () => onNavigateToRoute(
            portalEmpleadoRoutes.first,
            parentRouteName: 'Portal del Empleado',
          ),
          'Portal del Empleado',
        ),
        _buildCollapsedItem(
          LucideIcons.users,
          reclutamientoRoutes.contains(currentRoute) ||
              currentRoute == 'Reclutamiento',
          () => onNavigateToRoute(
            reclutamientoRoutes.first,
            parentRouteName: 'Reclutamiento',
          ),
          'Reclutamiento',
        ),
        _buildCollapsedItem(
          LucideIcons.contact,
          portalCandidatoRoutes.contains(currentRoute) ||
              currentRoute == 'Portal del Candidato',
          () => onNavigateToRoute(
            portalCandidatoRoutes.first,
            parentRouteName: 'Portal del Candidato',
          ),
          'Portal del Candidato',
        ),
        _buildCollapsedItem(
          LucideIcons.chartLine,
          currentRoute == 'Evaluación de desempeño',
          () => onNavigateToRoute('Evaluación de desempeño'),
          'Evaluación de desempeño',
        ),
        _buildCollapsedItem(
          LucideIcons.layers,
          currentRoute == 'Consolidación',
          () => onNavigateToRoute('Consolidación'),
          'Consolidación',
        ),
        _buildCollapsedItem(
          LucideIcons.calculator,
          currentRoute == 'Cálculos Impositivos',
          () => onNavigateToRoute('Cálculos Impositivos'),
          'Cálculos Impositivos',
        ),
      ],
    );
  }

  Widget _buildCollapsedItem(
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    String tooltipMessage,
  ) {
    return ClipRect(
      child: Tooltip(
        message: tooltipMessage,
        waitDuration: const Duration(milliseconds: 500),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isSelected ? AppColors.primaryPurple : Colors.transparent,
                width: 1,
              ),
            ),
            height: 48,
            width: collapsedSidebarWidth - 16,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Center(child: Icon(icon, color: Colors.white, size: 24)),
          ),
        ),
      ),
    );
  }
}
