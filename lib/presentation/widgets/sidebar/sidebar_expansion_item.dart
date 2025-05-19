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
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onHeaderTap;

  const SidebarExpansionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.childrenRoutes,
    required this.isParentSelected,
    required this.isExpanded,
    required this.onToggle,
    this.onHeaderTap,
  });

  @override
  State<SidebarExpansionItem> createState() => _SidebarExpansionItemState();
}

class _SidebarExpansionItemState extends State<SidebarExpansionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SidebarExpansionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final Color iconColor = Colors.white;
    final TextStyle textStyle = AppTextStyles.subtitle;
    final Color chevronColor = iconColor.withOpacity(0.7);
    final double indicatorLeftPos = -parentHorizontalPadding;

    bool effectivelySelected =
        widget.isParentSelected ||
        (widget.isExpanded && widget.children.any((child) => child.isSelected));

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
                effectivelySelected
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
              onTap: widget.onHeaderTap ?? widget.onToggle,
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
                        GestureDetector(
                          onTap: widget.onToggle,
                          child: Icon(
                            widget.isExpanded
                                ? LucideIcons.chevronUp
                                : LucideIcons.chevronDown,
                            size: 18,
                            color: chevronColor,
                          ),
                        ),
                      ],
                    ),
                    if (effectivelySelected)
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
