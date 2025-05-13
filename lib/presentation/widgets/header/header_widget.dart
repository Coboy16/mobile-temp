import 'package:flutter/material.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

const double _headerHeight = 60.0;

class HeaderWidget extends StatefulWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(_headerHeight);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  final GlobalKey _iconKey = GlobalKey();

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final RenderBox renderBox =
        _iconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _removeDropdown, // Cierra el dropdown al tocar fuera
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left:
                    offset.dx +
                    size.width -
                    350, // 350 es el maxWidth del dropdown
                top:
                    offset.dy +
                    size.height +
                    5, // 5 es un pequeño espacio vertical
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(size.width - 350, size.height + 5),
                  child: NotificationDropdown(
                    onViewAll: () {
                      print("Ver todas presionado");
                      _removeDropdown();
                      // Aquí podrías navegar a la pantalla de notificaciones
                    },
                  ),
                ),
              ),
            ],
          ),
    );

    overlay.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15), // Sombra un poco más sutil
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const _Breadcrumbs(),
          const Spacer(),
          CompositedTransformTarget(
            link: _layerLink,
            child: IconButton(
              key: _iconKey,
              icon: Icon(
                _isDropdownOpen
                    ? Icons.notifications
                    : Icons.notifications_none_outlined,
              ),
              color: AppColors.headerIcons,
              tooltip: 'Notificaciones',
              onPressed: _toggleDropdown,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.nightlight_round),
            color: AppColors.headerIcons,
            tooltip: 'Modo Oscuro',
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.indigo,
            child: Text(
              'JP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs();

  @override
  Widget build(BuildContext context) {
    // En una app real, esto vendría del estado de navegación
    return Row(
      children: [
        Text(
          'Inicio',
          style: TextStyle(color: AppColors.breadcrumbInactive, fontSize: 14),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.chevron_right,
            color: AppColors.breadcrumbInactive,
            size: 18,
          ),
        ),
        Text(
          'Solicitudes',
          style: TextStyle(
            color: AppColors.breadcrumbActive,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
