import 'package:flutter/material.dart';
import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/resources.dart';

class HistorialSolicitudesCard extends StatelessWidget {
  const HistorialSolicitudesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y filtro
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial de Solicitudes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Últimos 3 meses',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Subtítulo
          const Text(
            'Solicitudes de vacaciones del empleado',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryTextColor),
          ),
          const SizedBox(height: 16),

          // Lista de solicitudes
          _buildSolicitudItem(
            fecha: '16/03/2025',
            tipo: 'Vacaciones',
            estado: 'Aprobada',
            colorEstado: AppColors.appGreenColor,
          ),
          const SizedBox(height: 12),
          _buildSolicitudItem(
            fecha: '16/03/2025',
            tipo: 'Vacaciones',
            estado: 'Rechazada',
            colorEstado: AppColors.appRedColor,
          ),
          const SizedBox(height: 12),
          _buildSolicitudItem(
            fecha: '10/02/2025',
            tipo: 'Vacaciones',
            estado: 'Aprobada',
            colorEstado: AppColors.appGreenColor,
          ),
          const SizedBox(height: 12),
          _buildSolicitudItem(
            fecha: '20/12/2024',
            tipo: 'Vacaciones',
            estado: 'Aprobada',
            colorEstado: AppColors.appGreenColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudItem({
    required String fecha,
    required String tipo,
    required String estado,
    required Color colorEstado,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGrayBorderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fecha,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  tipo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorEstado.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              estado,
              style: TextStyle(
                fontSize: 11,
                color: colorEstado,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
