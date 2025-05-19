import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/bloc/blocs.dart';

class SidebarWrapper extends StatelessWidget {
  const SidebarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SidebarWidget();
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
    // Initial check and listen for future changes via LayoutBuilder or BlocListener
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
    // Adjust this condition based on your `responsive_framework` breakpoints
    // For example, if you consider TABLET also a "small screen" for the sidebar behavior.
    bool isCurrentlySmallScreen = responsive.isMobile || responsive.isTablet;
    // Or: bool isCurrentlySmallScreen = responsive.smallerOrEqualTo(TABLET);

    // Send event to BLoC only if the layout type has actually changed
    // The BLoC itself will also check if state.isSmallScreenLayout needs update
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
        buildWhen: (previous, current) => true,
        builder: (context, sidebarState) {
          // Re-check layout on each build. LayoutBuilder is more robust for this.
          // However, for simplicity with BlocConsumer, we can call it here.
          // For more complex scenarios, wrap parts of the tree with LayoutBuilder.
          // _checkLayout(context); // Can be called here, but LayoutBuilder is better.

          final double expandedOpacity = 1.0 - _animationController.value;
          final double collapsedOpacity = _animationController.value;

          return LayoutBuilder(
            // Use LayoutBuilder to react to constraint changes
            builder: (context, constraints) {
              // This is a more reliable place to check for layout changes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkLayout(context);
              });

              return AnimatedBuilder(
                animation: _widthAnimation,
                builder: (context, child) {
                  return Container(
                    width: _widthAnimation.value,
                    color: AppColors.sidebarBackground,
                    child: Column(
                      children: [
                        SidebarHeaderWithToggle(
                          isExpanded: sidebarState.isSidebarExpanded,
                          onToggle:
                              () => context.read<SidebarBloc>().add(
                                const SidebarVisibilityToggled(),
                              ),
                          widthAnimation: _widthAnimation,
                        ),
                        if (sidebarState.isSidebarExpanded ||
                            _animationController.value < 0.5)
                          ClipRect(
                            child: AnimatedOpacity(
                              duration: _animationDuration,
                              opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                              child: const UserInfo(),
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ClipRect(
                              child: Stack(
                                children: [
                                  AnimatedOpacity(
                                    duration: _animationDuration,
                                    opacity: (expandedOpacity * 1.2).clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    child: IgnorePointer(
                                      ignoring: !sidebarState.isSidebarExpanded,
                                      child: ExpandedSidebarContent(
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
                                              parentRouteName: parentRouteName,
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
                                  AnimatedOpacity(
                                    duration: _animationDuration,
                                    opacity: (collapsedOpacity * 1.2).clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    child: IgnorePointer(
                                      ignoring: sidebarState.isSidebarExpanded,
                                      child: CollapsedSidebarContent(
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
                                              parentRouteName: parentRouteName,
                                            ),
                                          );
                                        },
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
                        ClipRect(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: _animationDuration,
                                opacity: (expandedOpacity * 1.2).clamp(
                                  0.0,
                                  1.0,
                                ),
                                child: IgnorePointer(
                                  ignoring: !sidebarState.isSidebarExpanded,
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
                              AnimatedOpacity(
                                duration: _animationDuration,
                                opacity: (collapsedOpacity * 1.2).clamp(
                                  0.0,
                                  1.0,
                                ),
                                child: IgnorePointer(
                                  ignoring: sidebarState.isSidebarExpanded,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildCollapsedItem(
                                        LucideIcons.circleHelp,
                                        sidebarState.currentSelectedRoute ==
                                            'Ayuda y Soporte',
                                        () => context.read<SidebarBloc>().add(
                                          const SidebarRouteSelected(
                                            'Ayuda y Soporte',
                                          ),
                                        ),
                                      ),
                                      _buildCollapsedItem(
                                        LucideIcons.settings,
                                        sidebarState.currentSelectedRoute ==
                                            'Configuración',
                                        () => context.read<SidebarBloc>().add(
                                          const SidebarRouteSelected(
                                            'Configuración',
                                          ),
                                        ),
                                      ),
                                      _buildCollapsedItem(
                                        LucideIcons.logOut,
                                        false,
                                        () => _handleLogout(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildCollapsedItem(
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
