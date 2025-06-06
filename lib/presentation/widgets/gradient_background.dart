import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primaryBlue),
      child: child,
    );
  }
}
