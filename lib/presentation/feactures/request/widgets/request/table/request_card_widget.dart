import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/temp/mock_data.dart';
import '/presentation/resources/resources.dart';

class RequestCard extends StatelessWidget {
  final RequestData request;
  final VoidCallback? onViewDetails;
  final Function(String)? onActionSelected;

  const RequestCard({
    super.key,
    required this.request,
    this.onViewDetails,
    this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobilePlatform =
        !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabecera con icono, título y estado
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono y título
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        request.typeIcon,
                        size: 18,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      request.type,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey.shade900,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Estado
                StatusBadge(status: request.status),
              ],
            ),
          ),

          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Información del empleado - LAYOUT CORREGIDO
                _buildInfoRow(
                  'Empleado:',
                  '${request.employeeName} (Código ${request.employeeCode})',
                ),
                _buildInfoRow('Departamento:', request.employeeDept),
                _buildInfoRow('Fecha Solicitud:', request.typeDate),
                _buildInfoRow('Período:', request.period),
                _buildInfoRow('Empresa:', request.company),
                _buildInfoRow('Sucursal:', request.branch),
                _buildInfoRow('Solicitado:', request.requestedAgo),

                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade300, thickness: 1),

                //TODO:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón Ver detalles (lado izquierdo)
                    InkWell(
                      onTap: onViewDetails,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver detalles',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              LucideIcons.arrowRight,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botón Acciones (lado derecho)
                    Container(
                      height: 40,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: PopupMenuButton<String>(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder:
                              (context) => [
                                _buildMenuItem(
                                  LucideIcons.squarePen,
                                  'Editar solicitud',
                                  Colors.grey.shade700,
                                ),
                                _buildMenuItem(
                                  LucideIcons.download,
                                  'Descargar PDF',
                                  Colors.grey.shade700,
                                ),
                                _buildMenuItem(
                                  LucideIcons.circleCheckBig,
                                  'Aprobar solicitud',
                                  AppColors.primaryPurple,
                                ),
                                _buildMenuItem(
                                  LucideIcons.circleX,
                                  'Rechazar solicitud',
                                  Colors.red.shade600,
                                ),
                              ],
                          onSelected: (value) {
                            if (onActionSelected != null) {
                              onActionSelected!(value);
                            }
                          },
                          offset: const Offset(0, 8),
                          elevation: 8,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Acciones',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                LucideIcons.plus,
                                size: 14,
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                isMobilePlatform
                    ? const SizedBox(height: 12)
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir filas de información - LAYOUT CORREGIDO
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label a la izquierda
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // Valor a la derecha
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade900,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir los items del menú
  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
