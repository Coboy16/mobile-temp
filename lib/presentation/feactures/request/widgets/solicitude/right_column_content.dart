import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/app_models.dart';

import 'acciones_card.dart';
import 'indicadores_card.dart';
import 'informacion_adicional_card.dart';

class RightColumnContent extends StatelessWidget {
  final AppData appData;
  const RightColumnContent({super.key, required this.appData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AccionesCard(),
        const SizedBox(height: 16),
        IndicadoresCard(indicadores: appData.indicadores),
        const SizedBox(height: 16),
        InformacionAdicionalCard(info: appData.informacionAdicional),
      ],
    );
  }
}
