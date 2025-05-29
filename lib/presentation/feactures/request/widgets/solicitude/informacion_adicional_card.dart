import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/request.dart';
import '/presentation/resources/resources.dart';

class InformacionAdicionalCard extends StatelessWidget {
  final InformacionAdicional info;
  const InformacionAdicionalCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Adicional',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('ID de Solicitud', info.idSolicitud),
          const SizedBox(height: 14),
          _buildInfoItem('Creada por', info.creadaPor),
          const SizedBox(height: 14),
          _buildInfoItem('Departamento', info.departamento),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
