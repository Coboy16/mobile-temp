import '/presentation/resources/resources.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/widgets/widget.dart';

class SolicitudInfoCard extends StatelessWidget {
  final Solicitud solicitud;
  const SolicitudInfoCard({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                return _buildMobileHeader();
              } else {
                return _buildWebHeader();
              }
            },
          ),
          const SizedBox(height: 24),

          // Details grid section - responsive
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;

              if (isSmallScreen) {
                // Layout vertical para pantallas pequeñas
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            'Fecha de Solicitud',
                            solicitud.fechaSolicitud,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildDetailItem('Periodo', solicitud.periodo),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            'Días Solicitados',
                            '${solicitud.diasSolicitados} días',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildDetailItem(
                            'Días Disponibles',
                            '${solicitud.diasDisponibles} días',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Layout horizontal para pantallas grandes
                return Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Fecha de Solicitud',
                        solicitud.fechaSolicitud,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailItem('Periodo', solicitud.periodo),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailItem(
                        'Días Solicitados',
                        '${solicitud.diasSolicitados} días',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailItem(
                        'Días Disponibles',
                        '${solicitud.diasDisponibles} días',
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 24),

          // Motivo section
          _buildSectionContent('Motivo', solicitud.motivo),
          const SizedBox(height: 20),

          // Comentarios section
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              return isSmallScreen
                  ? SizedBox.shrink()
                  : Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      _buildSectionContent(
                        'Comentarios',
                        solicitud.comentarios,
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
            },
          ),

          // Documento adjunto section - responsivo
          _buildDocumentSection(),
        ],
      ),
    );
  }

  Widget _buildWebHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icono y información del lado izquierdo
        Container(
          height: 48,
          width: 48,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            LucideIcons.calendar,
            color: AppColors.primaryBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        // Información del título expandida
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                solicitud.tipo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Text(
                'Código ${solicitud.codigo} • ${solicitud.solicitante} • ${solicitud.departamentoSolicitante}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        // Botones y estado del lado derecho
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    side: BorderSide(color: Colors.grey.shade300, width: 0.4),
                  ),
                  icon: const Icon(
                    LucideIcons.download,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Descargar',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusPendienteTagBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    solicitud.estado,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 155, 83, 0),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              solicitud.nivelEstado,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono del lado izquierdo
            Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.calendar,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const Spacer(),
            // Botones del lado derecho en columna
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Botón de descarga solo icono
                Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 8),
                  child: Container(
                    width: 135,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.4,
                        ),
                      ),
                      icon: const Icon(
                        LucideIcons.download,
                        size: 18,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Descargar',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                // Badge de estado
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.statusPendienteTagBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        solicitud.estado,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 155, 83, 0),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solicitud.nivelEstado,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Título e información debajo
        AutoSizeText(
          solicitud.tipo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Text(
          'Código ${solicitud.codigo} • ${solicitud.solicitante} • ${solicitud.departamentoSolicitante}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documento adjunto',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child:
                  isMobile ? _buildMobileDocumentRow() : _buildWebDocumentRow(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebDocumentRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            LucideIcons.fileText,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            solicitud.documentoAdjunto.nombre,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Text(
              '${solicitud.documentoAdjunto.tamano} • ${solicitud.documentoAdjunto.fechaSubida}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondaryTextColor,
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightGrayBorderColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Descargar',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileDocumentRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            LucideIcons.fileText,
            color: AppColors.primaryBlue,
            size: 20,
          ),
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
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGrayBorderColor),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              LucideIcons.download,
              color: Colors.grey.shade600,
              size: 18,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
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

  Widget _buildSectionContent(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
