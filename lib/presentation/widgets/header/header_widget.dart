import 'dart:io';

import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/presentation/bloc/blocs.dart';
import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';
import 'account_dropdown.dart';

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
  // Para las notificaciones
  OverlayEntry? _notificationOverlayEntry;
  final LayerLink _notificationLayerLink = LayerLink();
  bool _isNotificationDropdownOpen = false;
  final GlobalKey _notificationIconKey = GlobalKey();

  // Para el dropdown de cuenta
  OverlayEntry? _accountOverlayEntry;
  bool _isAccountDropdownOpen = false;
  final GlobalKey _avatarKey = GlobalKey();

  // Detectar si es móvil
  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Métodos para notificaciones (modificados para móvil)
  void _toggleNotificationDropdown() {
    if (_isNotificationDropdownOpen) {
      _removeNotificationDropdown();
    } else {
      _showNotificationDropdown();
    }
  }

  void _showNotificationDropdown() {
    // Cerrar dropdown de cuenta si está abierto
    if (_isAccountDropdownOpen) {
      _removeAccountDropdown();
    }

    final overlay = Overlay.of(context);
    final RenderBox renderBox =
        _notificationIconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    // Calcular posición según la plataforma
    double leftPosition;
    const double dropdownWidth = 350.0;
    const double mobileMargin = 16.0; // Margen desde el borde derecho en móvil

    if (_isMobile) {
      // En móvil: pegado al borde derecho con un pequeño margen
      leftPosition = screenWidth - dropdownWidth - mobileMargin;
    } else {
      // En desktop: comportamiento original
      leftPosition = offset.dx + size.width - dropdownWidth;

      // Verificar que no se salga del borde derecho en desktop
      if (leftPosition + dropdownWidth > screenWidth) {
        leftPosition = screenWidth - dropdownWidth - 16;
      }
    }

    _notificationOverlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _removeNotificationDropdown,
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left: leftPosition,
                top: offset.dy + size.height + 5,
                child: NotificationDropdown(
                  onViewAll: () {
                    print("Ver todas presionado");
                    _removeNotificationDropdown();
                  },
                ),
              ),
            ],
          ),
    );

    overlay.insert(_notificationOverlayEntry!);
    setState(() {
      _isNotificationDropdownOpen = true;
    });
  }

  void _removeNotificationDropdown() {
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry!.remove();
      _notificationOverlayEntry = null;
      setState(() {
        _isNotificationDropdownOpen = false;
      });
    }
  }

  // Métodos para el dropdown de cuenta (mejorados)
  void _toggleAccountDropdown() {
    if (_isAccountDropdownOpen) {
      _removeAccountDropdown();
    } else {
      _showAccountDropdown();
    }
  }

  void _showAccountDropdown() {
    // Cerrar el dropdown de notificaciones si está abierto
    if (_isNotificationDropdownOpen) {
      _removeNotificationDropdown();
    }

    // Si ya está abierto, no hacer nada
    if (_isAccountDropdownOpen) {
      return;
    }

    final overlay = Overlay.of(context);
    final RenderBox? renderBox =
        _avatarKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _accountOverlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Área invisible para detectar taps fuera del dropdown
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _removeAccountDropdown();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
              ),
              // El dropdown
              Positioned(
                left:
                    offset.dx +
                    size.width -
                    200, // 200 es el ancho del dropdown
                top: offset.dy + size.height + 8,
                child: GestureDetector(
                  // Prevenir que los taps dentro del dropdown lo cierren
                  onTap: () {
                    debugPrint("Tap dentro del dropdown - manteniendo abierto");
                  },
                  child: AccountDropdown(
                    onProfile: () {
                      context.read<SidebarBloc>().add(
                        const SidebarRouteSelected('Configuración'),
                      );
                      _removeAccountDropdown();
                    },
                    onSettings: () {
                      context.read<SidebarBloc>().add(
                        const SidebarRouteSelected('Configuración'),
                      );
                      _removeAccountDropdown();
                    },
                    onHelp: () {
                      debugPrint("Ayuda presionada - cerrando dropdown");
                      _removeAccountDropdown();
                      // Aquí puedes navegar a la pantalla de ayuda
                    },
                    onLogout: () {
                      _handleLogout(context);
                      _removeAccountDropdown();
                      // Aquí puedes implementar la lógica de logout
                    },
                  ),
                ),
              ),
            ],
          ),
    );

    overlay.insert(_accountOverlayEntry!);
    setState(() {
      _isAccountDropdownOpen = true;
    });
    debugPrint("Dropdown de cuenta abierto exitosamente");
  }

  void _removeAccountDropdown() {
    if (_accountOverlayEntry != null) {
      _accountOverlayEntry!.remove();
      _accountOverlayEntry = null;
      if (mounted) {
        setState(() {
          _isAccountDropdownOpen = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _removeNotificationDropdown();
    _removeAccountDropdown();
    super.dispose();
  }

  void _handleLogout(BuildContext context) async {
    debugPrint("🏠 [HeaderWidget] Logout iniciado");

    final l10n = AppLocalizations.of(context)!;

    try {
      // ✅ Usar CustomConfirmationModal
      final bool? confirmLogout = await CustomConfirmationModal.show(
        context: context,
        title: l10n.confirmLogoutTitle,
        subtitle: l10n.confirmLogoutMessage,
        confirmButtonText: l10n.logoutButton,
        cancelButtonText: l10n.cancel,
        confirmButtonColor: const Color(0xFFDC2626), // Rojo para logout
        width: 420,
      );

      debugPrint("🏠 [HeaderWidget] Confirmación: $confirmLogout");

      if (confirmLogout == true) {
        debugPrint("🏠 [HeaderWidget] Logout confirmado");

        context.read<AuthBloc>().add(const AuthLogoutRequested());
        debugPrint(
          "🏠 [HeaderWidget] AuthLogoutRequested enviado - delegando a HomeScreen",
        );
      } else {
        debugPrint("🏠 [HeaderWidget] Logout cancelado");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ [HeaderWidget] Error en logout: $e");
      debugPrint("❌ [HeaderWidget] StackTrace: $stackTrace");
    }
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
    return BlocBuilder<SidebarBloc, SidebarState>(
      buildWhen:
          (previous, current) =>
              previous.isSmallScreenLayout != current.isSmallScreenLayout ||
              previous.isSidebarExpanded != current.isSidebarExpanded,
      builder: (context, sidebarState) {
        return Container(
          height: widget.preferredSize.height,
          padding: EdgeInsets.symmetric(horizontal: _isMobile ? 10.0 : 24.0),
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
              if (_isMobile)
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
              // Notificaciones
              CompositedTransformTarget(
                link: _notificationLayerLink,
                child: IconButton(
                  key: _notificationIconKey,
                  icon: Icon(
                    _isNotificationDropdownOpen
                        ? Icons.notifications
                        : Icons.notifications_none_outlined,
                  ),
                  color: AppColors.headerIcons,
                  tooltip: 'Notificaciones',
                  onPressed: _toggleNotificationDropdown,
                ),
              ),
              const SizedBox(width: 8),
              // Avatar con dropdown (simplificado)
              GestureDetector(
                key: _avatarKey,
                onTap: _toggleAccountDropdown,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border:
                          _isAccountDropdownOpen
                              ? Border.all(
                                color: Colors.indigo.withOpacity(0.3),
                                width: 2,
                              )
                              : null,
                    ),
                    child: const CircleAvatar(
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
