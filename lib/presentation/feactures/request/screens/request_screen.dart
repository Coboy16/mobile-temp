import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:fe_core_vips/presentation/feactures/request/views/new_request/select_request_type_dialog._widget.dart';
import 'package:fe_core_vips/presentation/feactures/request/widgets/widget.dart';
import 'package:fe_core_vips/presentation/resources/colors.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    final theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(
      context,
    ).smallerOrEqualTo(MOBILE);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 1.0 : 40.0,
            vertical: isMobile ? 5.0 : 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child:
                    isMobilePlatform
                        ? _headerWidgetMobile(context, localizations, theme)
                        : _buildHeader(context, localizations, theme),
              ),
              SizedBox(height: isMobilePlatform ? 10 : 24),

              // 2. Barra de Filtros/Búsqueda
              isMobilePlatform ? FilterBarMobile() : FilterBar(),
              SizedBox(height: 20),

              // 3. Tarjetas de Resumen
              SummaryCards(),
              SizedBox(height: 20),

              RequestsTableArea(),
              SizedBox(height: 20),

              // 5. Controles de Paginación
              PaginationControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return TopSection();
  }

  Widget _headerWidgetMobile(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // Título y subtítulo
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Solicitudes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            AutoSizeText(
              'Gestiona todas tus solicitudes desde aquí',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              maxLines: 2,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Botón de Nueva Solicitud
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text(
                'Nueva Solicitud',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                await showSelectRequestTypeDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> showSelectRequestTypeDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const SelectRequestTypeDialog();
      },
    );
  }
}
