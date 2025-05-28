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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Adicional',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('ID de Solicitud', info.idSolicitud),
          const SizedBox(height: 10),
          _buildInfoItem('Creada por', info.creadaPor),
          const SizedBox(height: 10),
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
          style: TextStyle(fontSize: 13, color: AppColors.secondaryTextColor),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
