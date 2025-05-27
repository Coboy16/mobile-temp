import 'package:flutter/material.dart';

class ResponsiveCenteredScrollable extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveCenteredScrollable({
    super.key,
    required this.child,
    this.maxWidth = 700.0,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              width: constraints.maxWidth,
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
