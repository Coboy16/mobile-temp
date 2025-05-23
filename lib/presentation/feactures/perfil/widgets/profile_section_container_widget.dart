import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class ProfileSectionContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final CrossAxisAlignment titleCrossAxisAlignment;

  const ProfileSectionContainer({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.all(20.0),
    this.decoration,
    this.titleCrossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration =
        decoration ??
        BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
        );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: padding,
      decoration: effectiveDecoration,
      child: Column(
        crossAxisAlignment: titleCrossAxisAlignment,
        children: [
          Text(
            title,
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
