import 'package:flutter/material.dart';

import 'package:fe_core_vips/domain/domain.dart';
import '/presentation/resources/resources.dart';

import 'initials_avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  final UserDetailsEntity userData;
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
            firstName: userData.name,
            lastName: userData.fatherLastname,
            radius: isMobile ? 45 : 50,
            fontSize: isMobile ? 28 : 32,
          ),
          const SizedBox(height: 12.0),
          Text(
            '${userData.name} ${userData.fatherLastname}',
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
