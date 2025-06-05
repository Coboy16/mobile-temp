import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/resources/colors.dart';

class TimelineEventWidget extends StatelessWidget {
  final SeguimientoEvento evento;
  final bool isLast;
  final bool isTwoColumnLayout; // Nuevo parámetro

  const TimelineEventWidget({
    super.key,
    required this.evento,
    this.isLast = false,
    this.isTwoColumnLayout = false, // Por defecto false para compatibilidad
  });

  Widget _buildIcon() {
    Color iconColor = Colors.white;
    Color bgColor;
    IconData iconData;

    switch (evento.status) {
      case 'completed_green':
        bgColor = AppColors.appGreenColor.withOpacity(0.4);
        iconData = LucideIcons.circleCheckBig;
        iconColor = Colors.green.shade700;

        break;
      case 'pending_yellow':
        bgColor = AppColors.appYellowColor.withOpacity(0.4);
        iconData = LucideIcons.clock;
        iconColor = Colors.deepOrange.shade500;
        break;
      case 'completed_blue':
        bgColor = AppColors.primaryBlue.withOpacity(0.2);
        iconData = LucideIcons.circleCheckBig;
        iconColor = AppColors.primaryBlue;
        break;
      case 'future_gray':
      case 'future_gray_level':
      default:
        bgColor = AppColors.appGrayColor.withOpacity(0.2);
        iconData = LucideIcons.circleAlert;
        iconColor = Colors.grey;

        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(iconData, size: 19, color: iconColor),
    );
  }

  Widget _buildConnectorLine() {
    // En el layout de dos columnas no mostramos líneas conectoras
    if (isLast || isTwoColumnLayout) return const SizedBox.shrink();

    return Positioned(
      left: 15.5,
      top: 32,
      bottom: -16,
      child: Container(width: 1, color: AppColors.lightGrayBorderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildConnectorLine(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          evento.titulo,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        if (evento.nivelTag != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.lightGrayBorderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              evento.nivelTag!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (evento.timestamp != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        evento.timestamp!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                    if (evento.detalle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        evento.detalle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
