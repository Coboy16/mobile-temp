import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/resources.dart';

class SeguimientoCard extends StatelessWidget {
  final Seguimiento seguimiento;
  const SeguimientoCard({super.key, required this.seguimiento});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.timer,
                    size: 20,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Seguimiento de la Solicitud',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  '${seguimiento.progreso}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: seguimiento.progreso / 100,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),

          // Timeline responsivo
          _buildResponsiveTimeline(context, seguimiento.eventos),
        ],
      ),
    );
  }

  Widget _buildResponsiveTimeline(
    BuildContext context,
    List<SeguimientoEvento> eventos,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return _buildSingleColumnTimeline(eventos);
        } else {
          return _buildTwoColumnTimeline(eventos);
        }
      },
    );
  }

  Widget _buildSingleColumnTimeline(List<SeguimientoEvento> eventos) {
    return Column(
      children:
          eventos.asMap().entries.map((entry) {
            int index = entry.key;
            SeguimientoEvento evento = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < eventos.length - 1 ? 16.0 : 0,
              ),
              child: TimelineEventWidget(
                evento: evento,
                isLast: index == eventos.length - 1,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTwoColumnTimeline(List<SeguimientoEvento> eventos) {
    List<SeguimientoEvento> leftColumn = [];
    List<SeguimientoEvento> rightColumn = [];

    // Izquierda: Solicitud Creada (0), En Espera (1), Aprobado (2)
    // Derecha: Corregido (3), Pendiente de Firma (4)

    // Basándome en el JSON que compartiste:
    // 0: Solicitud Creada -> Izquierda
    // 1: En Espera de Aprobación -> Izquierda
    // 2: Aprobado -> Izquierda
    // 3: Corregido -> Derecha
    // 4: Pendiente de Firma -> Derecha

    for (int i = 0; i < eventos.length; i++) {
      if (i <= 2) {
        // Primeros 3 elementos van a la izquierda
        leftColumn.add(eventos[i]);
      } else {
        // El resto va a la derecha
        rightColumn.add(eventos[i]);
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna izquierda
          Expanded(
            child: Column(
              children:
                  leftColumn.asMap().entries.map((entry) {
                    int index = entry.key;
                    SeguimientoEvento evento = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < leftColumn.length - 1 ? 20.0 : 0,
                      ),
                      child: TimelineEventWidget(
                        evento: evento,
                        isLast: false,
                        isTwoColumnLayout: true,
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(width: 24),

          // Columna derecha
          Expanded(
            child: Column(
              children: [
                ...rightColumn.asMap().entries.map((entry) {
                  int index = entry.key;
                  SeguimientoEvento evento = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < rightColumn.length - 1 ? 20.0 : 0,
                    ),
                    child: TimelineEventWidget(
                      evento: evento,
                      isLast: false,
                      isTwoColumnLayout: true,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
