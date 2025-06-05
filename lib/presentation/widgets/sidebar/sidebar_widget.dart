import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/bloc/blocs.dart';

class SidebarWrapper extends StatelessWidget {
  const SidebarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const SidebarWidget();
  }
}

class SidebarWidget extends StatefulWidget {
  // Agregamos un parámetro para saber si está siendo usado como drawer
  final bool isDrawer;

  const SidebarWidget({super.key, this.isDrawer = false});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  static const Duration _animationDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    final sidebarBloc = BlocProvider.of<SidebarBloc>(context);

    // Si es drawer, siempre iniciamos como expandido
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
      value:
          (widget.isDrawer || sidebarBloc.state.isSidebarExpanded) ? 0.0 : 1.0,
    );

    _widthAnimation = Tween<double>(
      begin: sidebarWidth,
      end: collapsedSidebarWidth,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.isDrawer) {
      _checkLayout(context);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggleSidebarAnimation(bool isExpanded) {
    // Si es drawer, no animamos (siempre expandido)
    if (widget.isDrawer) return;

    if (isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _checkLayout(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    bool isCurrentlySmallScreen = responsive.isMobile || responsive.isTablet;
    context.read<SidebarBloc>().add(
      SidebarLayoutChanged(isCurrentlySmallScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> portalEmpleadoRoutes = [
      'Solicitudes',
      'Comprobantes de Pago',
      'Informe de Cursos',
      'Cola de Aprobación',
    ];
    final List<String> reclutamientoRoutes = [
      'Ofertas de Trabajo',
      'Candidatos',
      'Portal Público',
      'Pruebas Psicométricas',
      'Ajustes',
    ];
    final List<String> portalCandidatoRoutes = [
      'Subitem Candidato',
      'Mis Postulaciones',
      'Mi Perfil',
    ];

    return BlocConsumer<SidebarBloc, SidebarState>(
      listener: (context, state) {
        _handleToggleSidebarAnimation(state.isSidebarExpanded);
      },
      listenWhen:
          (previous, current) =>
              previous.isSidebarExpanded != current.isSidebarExpanded,
      builder: (context, sidebarState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (!widget.isDrawer) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkLayout(context);
              });
            }

            return AnimatedBuilder(
              animation: _widthAnimation,
              builder: (context, child) {
                bool isMobilePlatform =
                    !kIsWeb && (Platform.isAndroid || Platform.isIOS);

                // Determinar el ancho efectivo
                double effectiveWidth =
                    widget.isDrawer
                        ? isMobilePlatform
                            ? drawerWidth
                            : sidebarWidth
                        : _widthAnimation.value;

                return Container(
                  width: effectiveWidth,
                  color: AppColors.primaryBlue,
                  child: Column(
                    children: [
                      isMobilePlatform
                          ? const SizedBox(height: 55)
                          : const SizedBox.shrink(),
                      SidebarHeaderWithToggle(
                        isExpanded:
                            widget.isDrawer
                                ? true
                                : sidebarState.isSidebarExpanded,
                        isDrawer:
                            widget.isDrawer, // ✅ Pasar el parámetro isDrawer
                        onToggle:
                            widget.isDrawer
                                ? () {
                                  // En drawer, cerrar el drawer en lugar de toggle
                                  Navigator.of(context).pop();
                                }
                                : () => context.read<SidebarBloc>().add(
                                  const SidebarVisibilityToggled(),
                                ),
                        widthAnimation:
                            widget.isDrawer
                                ? AlwaysStoppedAnimation(sidebarWidth)
                                : _widthAnimation,
                      ),
                      // UserInfo siempre visible en drawer
                      AnimatedOpacity(
                        opacity:
                            widget.isDrawer
                                ? 1.0
                                : (1.0 - _animationController.value).clamp(
                                  0.0,
                                  1.0,
                                ),
                        duration: Duration.zero,
                        child: Visibility(
                          visible:
                              widget.isDrawer ||
                              _animationController.value < 0.8,
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: false,
                          child: const UserInfo(),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ClipRect(
                            child: _buildSidebarContent(
                              sidebarState,
                              portalEmpleadoRoutes,
                              reclutamientoRoutes,
                              portalCandidatoRoutes,
                              context,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: AppColors.dividerColor.withOpacity(0.1),
                        height: 1,
                        thickness: 1,
                      ),
                      _buildFooterSection(sidebarState, context),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSidebarContent(
    SidebarState sidebarState,
    List<String> portalEmpleadoRoutes,
    List<String> reclutamientoRoutes,
    List<String> portalCandidatoRoutes,
    BuildContext context,
  ) {
    // Si es drawer, siempre mostrar contenido expandido
    if (widget.isDrawer) {
      return ExpandedSidebarContent(
        key: const ValueKey('drawer_expanded_content'),
        currentRoute: sidebarState.currentSelectedRoute,
        expandedParentRoutes: sidebarState.expandedParentRoutes,
        portalEmpleadoRoutes: portalEmpleadoRoutes,
        reclutamientoRoutes: reclutamientoRoutes,
        portalCandidatoRoutes: portalCandidatoRoutes,
        onNavigateToRoute: (
          routeName, {
          parentRouteName,
          isParentItem = false,
        }) {
          context.read<SidebarBloc>().add(
            SidebarRouteSelected(
              routeName,
              parentRouteName: parentRouteName,
              isParentItem: isParentItem,
            ),
          );
          // Cerrar el drawer después de navegar
          Navigator.of(context).pop();
        },
        onToggleExpansion: (parentRouteName) {
          context.read<SidebarBloc>().add(
            SidebarExpansionToggled(parentRouteName),
          );
        },
      );
    }

    // Para web, usar la lógica original con stack
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        AnimatedOpacity(
          opacity: (1.0 - _animationController.value).clamp(0.0, 1.0),
          duration: Duration.zero,
          child: Visibility(
            visible: _animationController.value < 1.0,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: false,
            child: IgnorePointer(
              ignoring: _animationController.value > 0.5,
              child: ExpandedSidebarContent(
                key: const ValueKey('expanded_content_stack_child'),
                currentRoute: sidebarState.currentSelectedRoute,
                expandedParentRoutes: sidebarState.expandedParentRoutes,
                portalEmpleadoRoutes: portalEmpleadoRoutes,
                reclutamientoRoutes: reclutamientoRoutes,
                portalCandidatoRoutes: portalCandidatoRoutes,
                onNavigateToRoute: (
                  routeName, {
                  parentRouteName,
                  isParentItem = false,
                }) {
                  context.read<SidebarBloc>().add(
                    SidebarRouteSelected(
                      routeName,
                      parentRouteName: parentRouteName,
                      isParentItem: isParentItem,
                    ),
                  );
                },
                onToggleExpansion: (parentRouteName) {
                  context.read<SidebarBloc>().add(
                    SidebarExpansionToggled(parentRouteName),
                  );
                },
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: _animationController.value.clamp(0.0, 1.0),
          duration: Duration.zero,
          child: Visibility(
            visible: _animationController.value > 0.0,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: false,
            child: IgnorePointer(
              ignoring: _animationController.value < 0.5,
              child: CollapsedSidebarContent(
                key: const ValueKey('collapsed_content_stack_child'),
                currentRoute: sidebarState.currentSelectedRoute,
                portalEmpleadoRoutes: portalEmpleadoRoutes,
                reclutamientoRoutes: reclutamientoRoutes,
                portalCandidatoRoutes: portalCandidatoRoutes,
                onNavigateToRoute: (routeName, {parentRouteName}) {
                  context.read<SidebarBloc>().add(
                    SidebarRouteSelected(
                      routeName,
                      parentRouteName: parentRouteName,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection(SidebarState sidebarState, BuildContext context) {
    // Si es drawer, siempre mostrar footer expandido
    if (widget.isDrawer) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SidebarItem(
            title: 'Ayuda y Soporte',
            icon: LucideIcons.circleHelp,
            isSelected: sidebarState.currentSelectedRoute == 'Ayuda y Soporte',
            onTap: () {
              context.read<SidebarBloc>().add(
                const SidebarRouteSelected('Ayuda y Soporte'),
              );
              Navigator.of(context).pop();
            },
          ),
          SidebarItem(
            title: 'Configuración',
            icon: LucideIcons.settings,
            isSelected: sidebarState.currentSelectedRoute == 'Configuración',
            onTap: () {
              context.read<SidebarBloc>().add(
                const SidebarRouteSelected('Configuración'),
              );
              Navigator.of(context).pop();
            },
          ),
          SidebarItem(
            title: 'Cerrar Sesión',
            icon: LucideIcons.logOut,
            onTap: () {
              _handleLogout(context);
            },
          ),
        ],
      );
    }

    // Para web, usar la lógica original con stack
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: (1.0 - _animationController.value).clamp(0.0, 1.0),
          duration: Duration.zero,
          child: Visibility(
            visible: _animationController.value < 0.8,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: false,
            child: IgnorePointer(
              ignoring: _animationController.value > 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SidebarItem(
                    title: 'Ayuda y Soporte',
                    icon: LucideIcons.circleHelp,
                    isSelected:
                        sidebarState.currentSelectedRoute == 'Ayuda y Soporte',
                    onTap: () {
                      context.read<SidebarBloc>().add(
                        const SidebarRouteSelected('Ayuda y Soporte'),
                      );
                    },
                  ),
                  SidebarItem(
                    title: 'Configuración',
                    icon: LucideIcons.settings,
                    isSelected:
                        sidebarState.currentSelectedRoute == 'Configuración',
                    onTap: () {
                      context.read<SidebarBloc>().add(
                        const SidebarRouteSelected('Configuración'),
                      );
                    },
                  ),
                  SidebarItem(
                    title: 'Cerrar Sesión',
                    icon: LucideIcons.logOut,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: _animationController.value.clamp(0.0, 1.0),
          duration: Duration.zero,
          child: Visibility(
            visible: _animationController.value > 0.2,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: false,
            child: IgnorePointer(
              ignoring: _animationController.value < 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCollapsedFooterItem(
                    LucideIcons.circleHelp,
                    sidebarState.currentSelectedRoute == 'Ayuda y Soporte',
                    () => context.read<SidebarBloc>().add(
                      const SidebarRouteSelected('Ayuda y Soporte'),
                    ),
                  ),
                  _buildCollapsedFooterItem(
                    LucideIcons.settings,
                    sidebarState.currentSelectedRoute == 'Configuración',
                    () => context.read<SidebarBloc>().add(
                      const SidebarRouteSelected('Configuración'),
                    ),
                  ),
                  _buildCollapsedFooterItem(
                    LucideIcons.logOut,
                    false,
                    () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedFooterItem(
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ClipRect(
      child: Tooltip(
        message: _getTooltipMessage(icon),
        waitDuration: const Duration(milliseconds: 500),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isSelected ? AppColors.primaryPurple : Colors.transparent,
                width: 1,
              ),
            ),
            height: 48,
            width: collapsedSidebarWidth - 16,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Center(child: Icon(icon, color: Colors.white, size: 24)),
          ),
        ),
      ),
    );
  }

  String _getTooltipMessage(IconData icon) {
    if (icon == LucideIcons.circleHelp) return 'Ayuda y Soporte';
    if (icon == LucideIcons.settings) return 'Configuración';
    if (icon == LucideIcons.logOut) return 'Cerrar Sesión';
    return '';
  }

  // ✅ VERSIÓN COMPLETAMENTE SIMPLIFICADA SIN LOADING MANUAL
  void _handleLogout(BuildContext context) async {
    debugPrint(
      "🚪 [SidebarWidget] Logout iniciado - isDrawer: ${widget.isDrawer}",
    );

    final l10n = AppLocalizations.of(context)!;

    try {
      // Mostrar modal de confirmación
      final bool? confirmLogout = await CustomConfirmationModal.show(
        context: context,
        title: l10n.confirmLogoutTitle,
        subtitle: l10n.confirmLogoutMessage,
        confirmButtonText: l10n.logoutButton,
        cancelButtonText: l10n.cancel,
        confirmButtonColor: const Color(0xFFDC2626),
        width: 420,
      );

      debugPrint("🚪 [SidebarWidget] Confirmación: $confirmLogout");

      if (confirmLogout == true) {
        debugPrint("🚪 [SidebarWidget] Logout confirmado");

        // Obtener AuthBloc ANTES de cerrar drawer
        final authBloc = context.read<AuthBloc>();
        debugPrint("🚪 [SidebarWidget] AuthBloc obtenido");

        // Cerrar drawer si es mobile
        if (widget.isDrawer && context.mounted) {
          debugPrint("🚪 [SidebarWidget] Cerrando drawer...");
          Navigator.of(context).pop();
          // Pequeña pausa para que el drawer se cierre completamente
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Ejecutar logout SIN mostrar loading manual
        // El HomeScreen se encargará de todo el manejo posterior
        debugPrint("🚪 [SidebarWidget] Ejecutando logout...");
        authBloc.add(const AuthLogoutRequested());
        debugPrint(
          "🚪 [SidebarWidget] AuthLogoutRequested enviado - delegando manejo a HomeScreen",
        );
      } else {
        debugPrint("🚪 [SidebarWidget] Logout cancelado");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ [SidebarWidget] Error en logout: $e");
      debugPrint("❌ [SidebarWidget] StackTrace: $stackTrace");
    }
  }
}
