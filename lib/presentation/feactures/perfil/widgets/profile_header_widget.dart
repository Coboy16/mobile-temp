import 'package:flutter/material.dart';

import '/presentation/feactures/perfil/utils/user_temp.dart';
import '/presentation/feactures/perfil/utils/app_colors.dart';
import '/presentation/feactures/perfil/utils/app_text_styles.dart';

import 'initials_avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileData userData;
  final bool isMobile;

  const ProfileHeader({
    super.key,
    required this.userData,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InitialsAvatar(
            firstName: userData.firstName,
            lastName: userData.paternalLastName,
            radius: isMobile ? 45 : 50,
            fontSize: isMobile ? 28 : 32,
          ),
          const SizedBox(height: 12.0),
          Text(
            '${userData.firstName} ${userData.paternalLastName}',
            style: (isMobile
                    ? AppTextStyles.headline2
                    : AppTextStyles.headline1)
                .copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            userData.email,
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
