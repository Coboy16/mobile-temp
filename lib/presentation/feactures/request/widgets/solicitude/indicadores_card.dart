import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/resources.dart';

class IndicadoresCard extends StatelessWidget {
  final Indicadores indicadores;
  const IndicadoresCard({super.key, required this.indicadores});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Indicadores',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildIndicadorItem(
            'Tiempo de Atención',
            indicadores.tiempoAtencion,
            '(promedio: ${indicadores.promedioTiempoAtencion})',
          ),
          const SizedBox(height: 16),
          _buildIndicadorItem(
            'Cantidad de Solicitudes',
            '${indicadores.cantidadSolicitudesMes} en el último mes',
            '(promedio: ${indicadores.promedioSolicitudesMes})',
          ),
        ],
      ),
    );
  }

  Widget _buildIndicadorItem(String title, String value, String subValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              subValue,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
