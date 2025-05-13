import 'package:flutter/material.dart';

import '/presentation/widgets/widgets.dart';

class ExpansionTileChildrenWrapper extends StatelessWidget {
  final List<Widget> children;

  const ExpansionTileChildrenWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20.0;
    const double childItemInternalPaddingLeft = itemHorizontalPadding;

    final double lineLeftOffset =
        -4 + childItemInternalPaddingLeft + (iconSize / 2) - (1.5 / 2);

    return Stack(
      children: [
        Positioned(
          left: lineLeftOffset,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: selectedItemColor.withOpacity(0.15),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ],
    );
  }
}
