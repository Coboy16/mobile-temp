import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/presentation/bloc/blocs.dart';
import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

const double _headerHeight = 60.0;

class HeaderWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HeaderWidget({super.key, this.scaffoldKey});

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
                  onTap: _removeDropdown,
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left: offset.dx + size.width - 350,
                top: offset.dy + size.height + 5,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(size.width - 350, size.height + 5),
                  child: NotificationDropdown(
                    onViewAll: () {
                      print("Ver todas presionado");
                      _removeDropdown();
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

  void _openDrawer() {
    try {
      // Intentar usar la key del scaffold primero
      if (widget.scaffoldKey?.currentState != null) {
        widget.scaffoldKey!.currentState!.openDrawer();
        return;
      }

      // Fallback: buscar el scaffold en el contexto
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.hasDrawer) {
        scaffoldState.openDrawer();
        return;
      }

      // Si nada funciona, imprimir error para debug
      debugPrint(
        '[HeaderWidget] No se pudo abrir el drawer - Scaffold no encontrado',
      );
    } catch (e) {
      debugPrint('[HeaderWidget] Error al abrir drawer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobilePlatform = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return BlocBuilder<SidebarBloc, SidebarState>(
      buildWhen:
          (previous, current) =>
              previous.isSmallScreenLayout != current.isSmallScreenLayout ||
              previous.isSidebarExpanded != current.isSidebarExpanded,
      builder: (context, sidebarState) {
        return Container(
          height: widget.preferredSize.height,
          padding: EdgeInsets.symmetric(
            horizontal: isMobilePlatform ? 10.0 : 24.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (isMobilePlatform)
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.headerIcons.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Builder(
                    builder: (BuildContext buttonContext) {
                      return IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(LucideIcons.menu),
                        color: AppColors.headerIcons,
                        tooltip: 'Abrir menú',
                        onPressed: _openDrawer,
                      );
                    },
                  ),
                )
              else
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
      },
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs();

  @override
  Widget build(BuildContext context) {
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
