import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/resources/resources.dart';

import '/presentation/widgets/widgets.dart';

class SidebarHeaderWithToggle extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final Animation<double> widthAnimation;

  const SidebarHeaderWithToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.widthAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final Color headerBg = AppColors.sidebarHeaderBackground;
    final Color logoText = AppColors.primaryPurple;
    final Color headerText = AppColors.sidebarText;
    final Color iconColor = AppColors.sidebarIcon.withOpacity(0.7);

    return Container(
      height: logoHeight,
      color: headerBg,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal:
            (parentHorizontalPadding / 2) +
            (parentHorizontalPadding /
                    2 *
                    (widthAnimation.value - collapsedSidebarWidth) /
                    (sidebarWidth - collapsedSidebarWidth))
                .clamp(
                  0.0,
                  parentHorizontalPadding / 2,
                ), // Mantenemos el cálculo original para preservar la UI
      ),
      // Mantenemos ClipRect para evitar overflow
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 120,
          ), // Más rápido que el original
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              clipBehavior: Clip.hardEdge, // Prevenir overflow
              alignment: Alignment.centerLeft,
              children: <Widget>[
                ...previousChildren.map((child) => Positioned(child: child)),
                if (currentChild != null) currentChild,
              ],
            );
          },
          child:
              isExpanded
                  ? Row(
                    key: const ValueKey('expanded_header'),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(
                          'HT',
                          style: TextStyle(
                            color: logoText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Ho-Tech',
                          style: TextStyle(
                            color: headerText,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Mejor manejo de espacio
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          LucideIcons.chevronLeft,
                          color: iconColor,
                          size: 20,
                        ),
                        onPressed: onToggle,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Collapse Sidebar',
                      ),
                    ],
                  )
                  : Container(
                    key: const ValueKey('collapsed_header'),
                    alignment: Alignment.center,
                    // Ancho fijo para evitar cálculos costosos
                    width: collapsedSidebarWidth - (parentHorizontalPadding),
                    child: IconButton(
                      icon: Icon(
                        LucideIcons.chevronRight,
                        color: iconColor,
                        size: 20,
                      ),
                      onPressed: onToggle,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Expand Sidebar',
                    ),
                  ),
        ),
      ),
    );
  }
}
