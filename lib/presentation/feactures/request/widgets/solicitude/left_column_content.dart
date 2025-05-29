import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/app_models.dart';

import 'solicitud_info_card.dart';
import 'seguimiento_card.dart';

class LeftColumnContent extends StatelessWidget {
  final AppData appData;
  const LeftColumnContent({super.key, required this.appData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolicitudInfoCard(solicitud: appData.solicitud),
        const SizedBox(height: 24),
        SeguimientoCard(seguimiento: appData.seguimiento),
      ],
    );
  }
}
