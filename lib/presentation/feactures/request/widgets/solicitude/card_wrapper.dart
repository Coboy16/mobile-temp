import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class CardWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CardWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackgroundColor,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
