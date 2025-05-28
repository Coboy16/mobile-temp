import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/resources.dart';

class SeguimientoCard extends StatelessWidget {
  final Seguimiento seguimiento;
  const SeguimientoCard({super.key, required this.seguimiento});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seguimiento de la Solicitud',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              Text(
                '${seguimiento.progreso}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentPurpleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: seguimiento.progreso / 100,
              backgroundColor: AppColors.accentPurpleColor.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentPurpleColor,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          ...seguimiento.eventos.map(
            (evento) => TimelineEventWidget(evento: evento),
          ),
        ],
      ),
    );
  }
}
