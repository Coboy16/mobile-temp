import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onDeleteAccount;
  final bool isMobile;

  const ProfileActions({
    super.key,
    required this.onDeleteAccount,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(LucideIcons.x, size: 18),
        label: const Text('Eliminar Cuenta'),
        onPressed: onDeleteAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deleteButtonText,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
