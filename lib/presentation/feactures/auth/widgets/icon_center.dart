import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class IconCenterWidget extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final bool? iconDarkMode;
  final bool? iconCenterDarkMode;
  const IconCenterWidget({
    super.key,
    this.size = 65,
    this.iconSize = 28,
    this.iconDarkMode = false,
    this.iconCenterDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color:
            iconDarkMode!
                ? Theme.of(context).scaffoldBackgroundColor
                : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Center(
        child: Text(
          'HT',
          style: TextStyle(
            color:
                iconCenterDarkMode!
                    ? AppColors.whiteColor
                    : AppColors.primaryBlue,
            fontSize: iconSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
