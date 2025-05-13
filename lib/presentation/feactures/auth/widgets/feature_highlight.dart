import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class FeatureHighlight extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureHighlight({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppDimensions.iconBoxSize,
          height: AppDimensions.iconBoxSize,
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withOpacity(
              0.15,
            ), // Slightly transparent white
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadius / 1.5,
            ),
          ),
          child: Icon(icon, color: AppColors.whiteColor, size: 24),
        ),
        const SizedBox(width: AppDimensions.itemSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.9),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
