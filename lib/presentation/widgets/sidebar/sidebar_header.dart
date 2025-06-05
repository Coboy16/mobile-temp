import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

class SidebarHeaderWithToggle extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final Animation<double> widthAnimation;
  final bool isDrawer; // Nuevo parámetro

  const SidebarHeaderWithToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.widthAnimation,
    this.isDrawer = false, // Por defecto false
  });

  @override
  Widget build(BuildContext context) {
    final Color headerBg = AppColors.primaryBlue;
    final Color headerText = AppColors.sidebarText;
    final Color iconColor = AppColors.sidebarIcon.withOpacity(0.7);
    bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return Container(
      height: logoHeight,
      color: headerBg,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal:
            isDrawer
                ? parentHorizontalPadding // Si es drawer, usar padding fijo
                : (parentHorizontalPadding / 2) +
                    (parentHorizontalPadding /
                        2 *
                        ((widthAnimation.value - collapsedSidebarWidth) /
                                (sidebarWidth - collapsedSidebarWidth))
                            .clamp(0.0, 1.0)),
      ),
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 120),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.centerLeft,
              children: <Widget>[
                ...previousChildren.map((child) => Positioned(child: child)),
                if (currentChild != null) currentChild,
              ],
            );
          },
          child:
              (isDrawer ||
                      isExpanded) // Si es drawer, siempre mostrar expandido
                  ? Row(
                    key: ValueKey(
                      isDrawer ? 'drawer_header' : 'expanded_header',
                    ),
                    children: [
                      GestureDetector(
                        onTap: isMobilePlatform ? onToggle : () {},
                        child: _buildLogo(),
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
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      (isMobilePlatform || isDrawer)
                          ? SizedBox.shrink()
                          : const Spacer(),
                      // Mostrar botón apropiado según el contexto
                      if (isMobilePlatform || isDrawer)
                        SizedBox.shrink()
                      else
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
                    width: collapsedSidebarWidth - (parentHorizontalPadding),
                    child: GestureDetector(
                      onTap: onToggle,
                      child: _buildLogo(),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        'HT',
        style: TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
