import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/widgets/solicitude/acciones_card.dart';
import '/presentation/feactures/request/widgets/solicitude/indicadores_card.dart';
import '/presentation/feactures/request/widgets/solicitude/informacion_adicional_card.dart';
import '/presentation/feactures/request/widgets/solicitude/historial_solicitudes_card.dart';

class RightColumnComplete extends StatelessWidget {
  final AppData appData;
  const RightColumnComplete({super.key, required this.appData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card de Acciones
        const AccionesCard(),
        const SizedBox(height: 24),

        // Card de Indicadores
        IndicadoresCard(indicadores: appData.indicadores),
        const SizedBox(height: 24),

        // Card de Información Adicional
        InformacionAdicionalCard(info: appData.informacionAdicional),
        const SizedBox(height: 24),

        // Card de Historial de Solicitudes
        const HistorialSolicitudesCard(),
      ],
    );
  }
}
