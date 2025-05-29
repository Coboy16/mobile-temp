import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/resources.dart';

class AccionesCard extends StatelessWidget {
  const AccionesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            text: 'Aprobar Solicitud',
            icon: LucideIcons.circleCheck,
            color: const Color.fromARGB(255, 45, 162, 86),
            isFilled: true,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            text: 'Rechazar Solicitud',
            icon: LucideIcons.circleX,
            color: AppColors.appRedColor,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            text: 'Editar Solicitud',
            icon: LucideIcons.squarePen,
            color: AppColors.primaryTextColor,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            text: 'Eliminar',
            icon: LucideIcons.trash,
            color: AppColors.appRedColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
    bool isFilled = false,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child:
          isFilled
              ? ElevatedButton.icon(
                icon: Icon(icon, size: 16),
                label: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                onPressed: onPressed,
              )
              : OutlinedButton.icon(
                icon: Icon(icon, size: 16, color: color),
                label: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        color == AppColors.appRedColor
                            ? color
                            : AppColors.primaryTextColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color:
                        color == AppColors.appRedColor
                            ? color
                            : AppColors.lightGrayBorderColor,
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                onPressed: onPressed,
              ),
    );
  }
}
