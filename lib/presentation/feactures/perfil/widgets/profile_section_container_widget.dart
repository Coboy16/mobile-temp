// lib/widgets/profile_section_container.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ProfileSectionContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final CrossAxisAlignment titleCrossAxisAlignment;
  final EdgeInsetsGeometry titlePadding;

  const ProfileSectionContainer({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.all(20.0),
    this.decoration,
    this.titleCrossAxisAlignment = CrossAxisAlignment.start,
    this.titlePadding = const EdgeInsets.only(bottom: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration =
        decoration ??
        BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: padding,
      decoration: effectiveDecoration,
      child: Column(
        crossAxisAlignment: titleCrossAxisAlignment,
        children: [
          Padding(
            padding: titlePadding,
            child: Text(
              title,
              style: AppTextStyles.headline2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
