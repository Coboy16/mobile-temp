import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/views/views.dart';
import '/presentation/resources/resources.dart';

class TopSection extends StatelessWidget {
  const TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btnVolver(),
        SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text('Solicitudes', style: AppTextStyles.titleSolicitudes),

              const SizedBox(height: 2),
              Text(
                'Gestiona todas tus solicitudes desde aquí',
                style: AppTextStyles.subtitleSolicitudes,
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 180,
          height: 42,
          child: ElevatedButton.icon(
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Nueva Solicitud'),
            onPressed: () async {
              await showSelectRequestTypeDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
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

  Widget _btnVolver() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(color: Colors.grey, width: 0.3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),

      child: TextButton.icon(
        icon: const Icon(
          LucideIcons.chevronLeft,
          size: 18,
          color: Colors.black,
        ),
        label: const Text('Volver', style: TextStyle(color: Colors.black)),
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
