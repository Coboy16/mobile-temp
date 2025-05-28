import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/resources/colors.dart';

class TimelineEventWidget extends StatelessWidget {
  final SeguimientoEvento evento;
  const TimelineEventWidget({super.key, required this.evento});

  Widget _buildIcon() {
    Color iconColor = Colors.white;
    Color bgColor;
    IconData iconData;

    switch (evento.status) {
      case 'completed_green':
        bgColor = AppColors.appGreenColor;
        iconData = LucideIcons.circleCheck;
        break;
      case 'pending_yellow':
        bgColor = AppColors.appYellowColor;
        iconData = LucideIcons.clock;
        iconColor = AppColors.primaryTextColor;
        break;
      case 'completed_blue':
        bgColor = AppColors.appBlueColor;
        iconData = LucideIcons.circleCheck;
        break;
      case 'future_gray':
      case 'future_gray_level':
      default:
        bgColor = AppColors.appGrayColor;
        iconData = LucideIcons.info;
        break;
    }
    return CircleAvatar(
      radius: 14,
      backgroundColor: bgColor,
      child: Icon(iconData, size: 16, color: iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        evento.titulo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ),
                    if (evento.nivelTag != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.nivelTagBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          evento.nivelTag!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.nivelTagTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (evento.timestamp != null || evento.detalle != null)
                  const SizedBox(height: 4),
                if (evento.timestamp != null)
                  Text(
                    evento.timestamp!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                if (evento.detalle != null)
                  Text(
                    evento.detalle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
