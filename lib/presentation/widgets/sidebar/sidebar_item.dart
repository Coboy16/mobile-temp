import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isChild;
  final VoidCallback? onTap;

  const SidebarItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.isChild = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.white;

    isChild
        ? (parentHorizontalPadding + itemHorizontalPadding)
        : parentHorizontalPadding;

    return Padding(
      padding: EdgeInsets.only(left: isChild ? childIndent : 0),
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: itemVerticalMargin,
            horizontal: itemHorizontalMargin,
          ),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color.fromARGB(
                      46,
                      255,
                      255,
                      255,
                    ).withOpacity(selectedItemBackgroundOpacity)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: onTap ?? () => print('Tapped on $title'),
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: selectedItemColor.withOpacity(0.1),
              highlightColor: selectedItemColor.withOpacity(0.05),
              child: Padding(
                padding: EdgeInsets.only(
                  left: itemHorizontalPadding,
                  right: itemHorizontalPadding / 2,
                  top: itemVerticalPadding,
                  bottom: itemVerticalPadding,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.subtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),

                    if (isSelected)
                      Positioned(
                        left: -19,
                        top: -itemVerticalPadding,
                        bottom: -itemVerticalPadding,
                        child: Container(
                          width: indicatorWidth,
                          decoration: const BoxDecoration(
                            color: selectedItemColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              bottomLeft: Radius.circular(borderRadius),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
