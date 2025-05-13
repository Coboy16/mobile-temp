import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

class SidebarExpansionItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<SidebarItem> children;
  final List<String> childrenRoutes;
  final bool isParentSelected;
  final bool initiallyExpanded;
  final bool? forceExpanded;

  const SidebarExpansionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.childrenRoutes,
    required this.isParentSelected,
    this.initiallyExpanded = false,
    this.forceExpanded,
  });

  @override
  State<SidebarExpansionItem> createState() => _SidebarExpansionItemState();
}

class _SidebarExpansionItemState extends State<SidebarExpansionItem>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.forceExpanded ?? widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80), // Más rápida
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SidebarExpansionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.forceExpanded != null && widget.forceExpanded != _isExpanded) {
      setState(() {
        _isExpanded = widget.forceExpanded!;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
    if (widget.isParentSelected != oldWidget.isParentSelected) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final Color iconColor = Colors.white;
    final TextStyle textStyle = AppTextStyles.subtitle;
    final Color chevronColor = iconColor.withOpacity(0.7);

    final double indicatorLeftPos = -parentHorizontalPadding;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: itemVerticalMargin,
            horizontal: itemHorizontalMargin,
          ),
          decoration: BoxDecoration(
            color:
                widget.isParentSelected
                    ? selectedItemColor.withOpacity(
                      selectedItemBackgroundOpacity,
                    )
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: selectedItemColor.withOpacity(0.1),
              highlightColor: selectedItemColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: parentHorizontalPadding,
                  right: parentHorizontalPadding,
                  top: itemVerticalPadding,
                  bottom: itemVerticalPadding,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      children: [
                        Icon(widget.icon, color: iconColor, size: 20),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: textStyle.copyWith(color: textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 18,
                          color: chevronColor,
                        ),
                      ],
                    ),

                    if (widget.isParentSelected)
                      Positioned(
                        left: indicatorLeftPos,
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
        // Usamos SizeTransition para una animación más eficiente
        ClipRect(
          child: SizeTransition(
            axisAlignment: -1,
            sizeFactor: _expandAnimation,
            child: ExpansionTileChildrenWrapper(children: widget.children),
          ),
        ),
      ],
    );
  }
}
