import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/presentation/feactures/perfil/utils/app_colors.dart';
import '/presentation/feactures/perfil/utils/app_text_styles.dart';

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
      child: TextButton.icon(
        icon: FaIcon(
          FontAwesomeIcons.trashCan,
          size: 16,
          color: AppColors.error,
        ),
        label: Text(
          'Eliminar Cuenta',
          style: AppTextStyles.button.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onDeleteAccount,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.error.withOpacity(0.4)),
          ),
          backgroundColor: AppColors.error.withOpacity(0.05),
        ),
      ),
    );
  }
}
