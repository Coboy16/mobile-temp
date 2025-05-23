import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/presentation/resources/resources.dart';

class InitialsAvatar extends StatelessWidget {
  final String firstName;
  final String? lastName;
  final double radius;
  final double fontSize;

  const InitialsAvatar({
    super.key,
    required this.firstName,
    this.lastName,
    this.radius = 45.0,
    this.fontSize = 28.0,
  });

  String _getInitials() {
    String initials = "";
    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName != null && lastName!.isNotEmpty) {
      initials += lastName![0].toUpperCase();
    }
    return initials.isEmpty ? "?" : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.7),
            AppColors.primaryVariant.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: AutoSizeText(
          _getInitials(),
          style: TextStyle(
            fontFamily: 'NunitoSans',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,
          ),
          minFontSize: fontSize * 0.5,
          maxLines: 1,
        ),
      ),
    );
  }
}
