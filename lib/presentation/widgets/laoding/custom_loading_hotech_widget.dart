import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';

class _IconForLoading extends StatelessWidget {
  final double? containerSize;
  final double? iconFontSize;

  const _IconForLoading({this.containerSize = 60, this.iconFontSize = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'HT',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: iconFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomLoadingHotech extends StatelessWidget {
  final String? message;
  final bool overlay;
  final Color? overlayBackgroundColor;
  final double iconContainerSize;
  final double iconFontSize;
  final double progressBarWidth;
  final double progressBarHeight;

  const CustomLoadingHotech({
    super.key,
    this.message,
    this.overlay = false,
    this.overlayBackgroundColor,
    this.iconContainerSize = 60.0,
    this.iconFontSize = 28.0,
    this.progressBarWidth = 80.0,
    this.progressBarHeight = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconForLoading(
            containerSize: iconContainerSize,
            iconFontSize: iconFontSize,
          ),
          SizedBox(
            height: AppDimensions.itemSpacing * 0.75,
          ), // Espacio entre icono y barra
          SizedBox(
            width: progressBarWidth,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.2),
              minHeight: progressBarHeight,
            ),
          ),
          if (message != null && message!.isNotEmpty) ...[
            SizedBox(height: AppDimensions.itemSpacing),
            Text(
              message!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (!overlay) {
      return indicator;
    }

    return Container(
      color: overlayBackgroundColor ?? Colors.black.withOpacity(0.5),
      child: indicator,
    );
  }
}
