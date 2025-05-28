import '/presentation/resources/resources.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/widgets/widget.dart';

class SolicitudInfoCard extends StatelessWidget {
  final Solicitud solicitud;
  const SolicitudInfoCard({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.calendarDays,
                color: AppColors.accentPurpleColor,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      solicitud.tipo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Código ${solicitud.codigo} • ${solicitud.solicitante} • ${solicitud.departamentoSolicitante}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(
                          LucideIcons.download,
                          size: 16,
                          color: AppColors.primaryTextColor,
                        ),
                        label: const Text(
                          'Descargar',
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.statusPendienteTagBgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          solicitud.estado,
                          style: const TextStyle(
                            color: AppColors.statusPendienteTagTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    solicitud.nivelEstado,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.lightGrayBorderColor),
          const SizedBox(height: 20),
          ResponsiveRowColumn(
            layout:
                ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowSpacing: 16,
            columnSpacing: 16,
            children: [
              ResponsiveRowColumnItem(
                child: _buildDetailItem(
                  'Fecha de Solicitud',
                  solicitud.fechaSolicitud,
                ),
              ),
              ResponsiveRowColumnItem(
                child: _buildDetailItem('Periodo', solicitud.periodo),
              ),
              ResponsiveRowColumnItem(
                child: _buildDetailItem(
                  'Días Solicitados',
                  '${solicitud.diasSolicitados} días',
                ),
              ),
              ResponsiveRowColumnItem(
                child: _buildDetailItem(
                  'Días Disponibles',
                  '${solicitud.diasDisponibles} días',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionContent('Motivo', solicitud.motivo),
          const SizedBox(height: 16),
          _buildSectionContent('Comentarios', solicitud.comentarios),
          const SizedBox(height: 20),
          Text(
            'Documento adjunto',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrayBorderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.fileText,
                  color: AppColors.accentPurpleColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        solicitud.documentoAdjunto.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${solicitud.documentoAdjunto.tamano} • ${solicitud.documentoAdjunto.fechaSubida}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.lightGrayBorderColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Descargar',
                    style: TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContent(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
