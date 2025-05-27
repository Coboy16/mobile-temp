import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/bloc/blocs.dart';

class SidebarWrapper extends StatelessWidget {
  const SidebarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const SidebarWidget();
  }
}

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

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

    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
      value: sidebarBloc.state.isSidebarExpanded ? 0.0 : 1.0,
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
    _checkLayout(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggleSidebarAnimation(bool isExpanded) {
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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUnauthenticated || authState is AuthFailure) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
        if (authState is AuthUnauthenticated) {
          if (authState.message != null) {
            context.pushReplacementNamed(AppRoutes.login);
          }
        } else if (authState is AuthFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(authState.message)));
        }
      },
      child: BlocConsumer<SidebarBloc, SidebarState>(
        listener: (context, state) {
          _handleToggleSidebarAnimation(state.isSidebarExpanded);
        },
        listenWhen:
            (previous, current) =>
                previous.isSidebarExpanded != current.isSidebarExpanded,
        builder: (context, sidebarState) {
          return LayoutBuilder(
            builder: (context, constraints) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkLayout(context);
              });

              return AnimatedBuilder(
                animation: _widthAnimation,
                builder: (context, child) {
                  bool isMobilePlatform =
                      !kIsWeb && (Platform.isAndroid || Platform.isIOS);
                  return Container(
                    width: _widthAnimation.value,
                    color: AppColors.primaryBlue,
                    child: Column(
                      children: [
                        isMobilePlatform
                            ? const SizedBox(height: 30)
                            : const SizedBox.shrink(),
                        SidebarHeaderWithToggle(
                          isExpanded: sidebarState.isSidebarExpanded,
                          onToggle:
                              () => context.read<SidebarBloc>().add(
                                const SidebarVisibilityToggled(),
                              ),
                          widthAnimation: _widthAnimation,
                        ),
                        AnimatedOpacity(
                          opacity: (1.0 - _animationController.value).clamp(
                            0.0,
                            1.0,
                          ),
                          duration: Duration.zero,
                          child: Visibility(
                            visible: _animationController.value < 0.8,
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
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  AnimatedOpacity(
                                    opacity: (1.0 - _animationController.value)
                                        .clamp(0.0, 1.0),
                                    duration: Duration.zero,
                                    child: Visibility(
                                      visible: _animationController.value < 1.0,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      maintainSize: false,
                                      child: IgnorePointer(
                                        ignoring:
                                            _animationController.value > 0.5,
                                        child: ExpandedSidebarContent(
                                          key: const ValueKey(
                                            'expanded_content_stack_child',
                                          ),
                                          currentRoute:
                                              sidebarState.currentSelectedRoute,
                                          expandedParentRoutes:
                                              sidebarState.expandedParentRoutes,
                                          portalEmpleadoRoutes:
                                              portalEmpleadoRoutes,
                                          reclutamientoRoutes:
                                              reclutamientoRoutes,
                                          portalCandidatoRoutes:
                                              portalCandidatoRoutes,
                                          onNavigateToRoute: (
                                            routeName, {
                                            parentRouteName,
                                            isParentItem = false,
                                          }) {
                                            context.read<SidebarBloc>().add(
                                              SidebarRouteSelected(
                                                routeName,
                                                parentRouteName:
                                                    parentRouteName,
                                                isParentItem: isParentItem,
                                              ),
                                            );
                                          },
                                          onToggleExpansion: (parentRouteName) {
                                            context.read<SidebarBloc>().add(
                                              SidebarExpansionToggled(
                                                parentRouteName,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: _animationController.value.clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    duration: Duration.zero,
                                    child: Visibility(
                                      visible: _animationController.value > 0.0,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      maintainSize: false,
                                      child: IgnorePointer(
                                        ignoring:
                                            _animationController.value < 0.5,
                                        child: CollapsedSidebarContent(
                                          key: const ValueKey(
                                            'collapsed_content_stack_child',
                                          ),
                                          currentRoute:
                                              sidebarState.currentSelectedRoute,
                                          portalEmpleadoRoutes:
                                              portalEmpleadoRoutes,
                                          reclutamientoRoutes:
                                              reclutamientoRoutes,
                                          portalCandidatoRoutes:
                                              portalCandidatoRoutes,
                                          onNavigateToRoute: (
                                            routeName, {
                                            parentRouteName,
                                          }) {
                                            context.read<SidebarBloc>().add(
                                              SidebarRouteSelected(
                                                routeName,
                                                parentRouteName:
                                                    parentRouteName,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors.dividerColor.withOpacity(0.1),
                          height: 1,
                          thickness: 1,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: (1.0 - _animationController.value).clamp(
                                0.0,
                                1.0,
                              ),
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
                                            sidebarState.currentSelectedRoute ==
                                            'Ayuda y Soporte',
                                        onTap: () {
                                          context.read<SidebarBloc>().add(
                                            const SidebarRouteSelected(
                                              'Ayuda y Soporte',
                                            ),
                                          );
                                        },
                                      ),
                                      SidebarItem(
                                        title: 'Configuración',
                                        icon: LucideIcons.settings,
                                        isSelected:
                                            sidebarState.currentSelectedRoute ==
                                            'Configuración',
                                        onTap: () {
                                          context.read<SidebarBloc>().add(
                                            const SidebarRouteSelected(
                                              'Configuración',
                                            ),
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
                              opacity: _animationController.value.clamp(
                                0.0,
                                1.0,
                              ),
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
                                        sidebarState.currentSelectedRoute ==
                                            'Ayuda y Soporte',
                                        () => context.read<SidebarBloc>().add(
                                          const SidebarRouteSelected(
                                            'Ayuda y Soporte',
                                          ),
                                        ),
                                      ),
                                      _buildCollapsedFooterItem(
                                        LucideIcons.settings,
                                        sidebarState.currentSelectedRoute ==
                                            'Configuración',
                                        () => context.read<SidebarBloc>().add(
                                          const SidebarRouteSelected(
                                            'Configuración',
                                          ),
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
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
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

  void _handleLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ConfirmLogoutDialog(),
    );

    if (confirmLogout == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext loadingContext) {
          return PopScope(
            canPop: false,
            child: CustomLoadingHotech(
              overlay: true,
              message: l10n.loggingOutMessage,
            ),
          );
        },
      );
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }
}
