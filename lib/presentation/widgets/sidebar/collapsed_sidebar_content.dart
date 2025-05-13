import 'package:fe_core_vips/presentation/resources/resources.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/widgets/widgets.dart';

class CollapsedSidebarContent extends StatelessWidget {
  final String currentRoute;
  final List<String> portalEmpleadoRoutes;
  final List<String> reclutamientoRoutes;
  final List<String> portalCandidatoRoutes;

  const CollapsedSidebarContent({
    super.key,
    required this.currentRoute,
    required this.portalEmpleadoRoutes,
    required this.reclutamientoRoutes,
    required this.portalCandidatoRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('collapsed_content'),
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCollapsedItem(
          LucideIcons.fileText,
          portalEmpleadoRoutes.contains(currentRoute),
          () => print('Navegar a Portal del Empleado'),
        ),
        _buildCollapsedItem(
          LucideIcons.users,
          reclutamientoRoutes.contains(currentRoute),
          () => print('Navegar a Reclutamiento'),
        ),
        _buildCollapsedItem(
          LucideIcons.contact,
          portalCandidatoRoutes.contains(currentRoute),
          () => print('Navegar a Portal del Candidato'),
        ),
        _buildCollapsedItem(
          LucideIcons.chartLine,
          currentRoute == 'Evaluación de desempeño',
          () => print('Navegar a Evaluación'),
        ),
        _buildCollapsedItem(
          LucideIcons.layers,
          currentRoute == 'Consolidación',
          () => print('Navegar a Consolidación'),
        ),
        _buildCollapsedItem(
          LucideIcons.calculator,
          currentRoute == 'Cálculos Impositivos',
          () => print('Navegar a Cálculos'),
        ),
      ],
    );
  }

  Widget _buildCollapsedItem(
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ClipRect(
      child: Tooltip(
        message: _getTooltipMessage(icon),
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

  String _getTooltipMessage(IconData icon) {
    if (icon == LucideIcons.fileText) return 'Portal del Empleado';
    if (icon == LucideIcons.users) return 'Reclutamiento';
    if (icon == LucideIcons.contact) return 'Portal del Candidato';
    if (icon == LucideIcons.chartLine) return 'Evaluación de desempeño';
    if (icon == LucideIcons.layers) return 'Consolidación';
    if (icon == LucideIcons.calculator) return 'Cálculos Impositivos';
    return '';
  }
}
