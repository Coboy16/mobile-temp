import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ho-Tech',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 32,
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryText),
          ),
        ),
      ],
    );
  }
}
