import 'dart:convert';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/temp/app_data_json.dart';
import '/presentation/feactures/request/widgets/solicitude/solicitud_info_card.dart';
import '/presentation/feactures/request/widgets/solicitude/seguimiento_card.dart';
import '/presentation/feactures/request/widgets/solicitude/acciones_card.dart';
import '/presentation/feactures/request/widgets/solicitude/indicadores_card.dart';
import '/presentation/feactures/request/widgets/solicitude/informacion_adicional_card.dart';
import '/presentation/feactures/request/widgets/solicitude/historial_solicitudes_card.dart';
import '/presentation/feactures/request/widgets/solicitude/right_column_complete.dart';
import '/presentation/resources/resources.dart';

class SolicitudScreen extends StatefulWidget {
  final String requestId;

  const SolicitudScreen({super.key, required this.requestId});

  @override
  State<SolicitudScreen> createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  late AppData? appData;
  bool isLoading = true;
  bool requestNotFound = false;

  @override
  void initState() {
    super.initState();
    _loadRequestData();
  }

  void _loadRequestData() {
    try {
      // Simular búsqueda de la solicitud por ID
      // En tu implementación real, aquí harías una llamada al API

      // Por ahora, validamos con los IDs de ejemplo (simulación)
      final validRequestIds = [
        'REQ-001',
        'REQ-002',
        'REQ-003',
        'REQ-004',
        'REQ-005',
      ];

      if (validRequestIds.contains(widget.requestId)) {
        // Solicitud encontrada, cargar datos
        final Map<String, dynamic> decodedJson = jsonDecode(
          solicitudDataJsonString,
        );
        appData = AppData.fromJson(decodedJson);
        requestNotFound = false;
      } else {
        // Solicitud no encontrada
        appData = null;
        requestNotFound = true;
      }
    } catch (e) {
      // Error al cargar datos
      appData = null;
      requestNotFound = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para navegar de regreso a la lista de solicitudes
  void _navigateBack() {
    context.go('/home/request');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024; // Breakpoint para desktop

    // Envolver todo en WillPopScope para capturar el botón físico del teléfono
    return WillPopScope(
      onWillPop: () async {
        _navigateBack();
        return false; // Prevenir el comportamiento por defecto
      },
      child: Container(
        color: AppColors.pageBackgroundColor,
        child: _buildContent(context, localizations, theme, isDesktop),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    bool isDesktop,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requestNotFound || appData == null) {
      return _buildNotFoundScreen(context, localizations, theme, isDesktop);
    }

    return Column(
      children: [
        isDesktop
            ? _buildHeader(context, localizations, theme)
            : _headerMobile(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24.0 : 16.0,
              vertical: 16.0,
            ),
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundScreen(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    bool isDesktop,
  ) {
    return Column(
      children: [
        isDesktop
            ? _buildHeader(context, localizations, theme)
            : _headerMobile(),
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.fileX2,
                    size: isDesktop ? 80 : 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Solicitud no encontrada',
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'La solicitud con código "${widget.requestId}" no existe o ha sido eliminada.',
                    style: TextStyle(
                      fontSize: isDesktop ? 16 : 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _navigateBack,
                    icon: const Icon(LucideIcons.arrowLeft, size: 18),
                    label: const Text('Volver a solicitudes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 24 : 20,
                        vertical: isDesktop ? 16 : 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
            ),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                onPressed: _navigateBack, // Usar la función de navegación
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black87,
                ),
                label: Text(
                  localizations.backButton,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalle de Solicitud ${widget.requestId}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerMobile() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          // Agregar botón de regreso en móvil también
          IconButton(
            onPressed: _navigateBack,
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: AppColors.primaryTextColor,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Detalle de Solicitud ${widget.requestId}',
              style: const TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Layout para pantallas grandes (Desktop/Tablet)
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COLUMNA IZQUIERDA: Solicitud Info + Seguimiento
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SolicitudInfoCard(solicitud: appData!.solicitud),
              const SizedBox(height: 24),
              SeguimientoCard(seguimiento: appData!.seguimiento),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // COLUMNA DERECHA: Acciones + Indicadores + Info Adicional + Historial
        Expanded(flex: 1, child: RightColumnComplete(appData: appData!)),
      ],
    );
  }

  // Layout para pantallas pequeñas (Mobile/Tablet pequeño)
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Solicitud Info
        SolicitudInfoCard(solicitud: appData!.solicitud),
        const SizedBox(height: 24),

        // Acciones
        const AccionesCard(),
        const SizedBox(height: 24),

        // Seguimiento
        SeguimientoCard(seguimiento: appData!.seguimiento),
        const SizedBox(height: 24),

        // Indicadores
        IndicadoresCard(indicadores: appData!.indicadores),
        const SizedBox(height: 24),

        // Información Adicional
        InformacionAdicionalCard(info: appData!.informacionAdicional),
        const SizedBox(height: 24),

        // Historial de Solicitudes
        const HistorialSolicitudesCard(),
      ],
    );
  }
}
