import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/resources.dart';

class AccionesCard extends StatelessWidget {
  const AccionesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            text: 'Aprobar Solicitud',
            icon: LucideIcons.check,
            color: AppColors.appGreenColor,
            isFilled: true,
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            context,
            text: 'Rechazar Solicitud',
            icon: LucideIcons.x,
            color: AppColors.appRedColor,
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            context,
            text: 'Editar Solicitud',
            icon: LucideIcons.pencil,
            color: AppColors.primaryTextColor,
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            context,
            text: 'Eliminar',
            icon: LucideIcons.trash2,
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
                icon: Icon(icon, size: 18),
                label: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressed,
              )
              : OutlinedButton.icon(
                icon: Icon(icon, size: 18, color: color),
                label: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressed,
              ),
    );
  }
}
