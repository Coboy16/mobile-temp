import 'package:fe_core_vips/presentation/feactures/auth/bloc/blocs.dart';
import 'package:fe_core_vips/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/presentation/feactures/home/bloc/blocs.dart';
import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

// WIDGET PRINCIPAL QUE MANEJA EL ESTADO Y LA ANIMACIÓN
class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late NavegationBarBloc _navigationBarBloc;
  int currentIndex = 0;

  static const Duration _animationDuration = Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
    _navigationBarBloc = BlocProvider.of<NavegationBarBloc>(context);
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
      value: isExpanded ? 0.0 : 1.0,
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSidebar() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Datos comunes para ambos widgets
    const String currentRoute = 'Solicitudes'; // Example

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

    final bool isPortalEmpleadoSelected = portalEmpleadoRoutes.contains(
      currentRoute,
    );
    final bool isReclutamientoSelected = reclutamientoRoutes.contains(
      currentRoute,
    );
    final bool isPortalCandidatoSelected = portalCandidatoRoutes.contains(
      currentRoute,
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated || state is AuthFailure) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (state is AuthUnauthenticated) {
          if (state.message != null) {
            debugPrint(state.message!);
            context.pushReplacementNamed(AppRoutes.login);
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AnimatedBuilder(
        animation: _widthAnimation,
        builder: (context, child) {
          final double expandedOpacity = 1.0 - _animationController.value;
          final double collapsedOpacity = _animationController.value;

          return Container(
            width: _widthAnimation.value,
            color: AppColors.sidebarBackground,
            child: Column(
              children: [
                SidebarHeaderWithToggle(
                  isExpanded: isExpanded,
                  onToggle: toggleSidebar,
                  widthAnimation: _widthAnimation,
                ),

                // UserInfo con ClipRect para prevenir overflow
                ClipRect(
                  child: AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                    child:
                        isExpanded || _animationController.value < 0.5
                            ? const UserInfo()
                            : const SizedBox.shrink(),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ClipRect(
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          // Contenido expandido
                          AnimatedOpacity(
                            duration: _animationDuration,
                            opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                            child: IgnorePointer(
                              ignoring: !isExpanded,
                              child: ExpandedSidebarContent(
                                currentRoute: currentRoute,
                                portalEmpleadoRoutes: portalEmpleadoRoutes,
                                reclutamientoRoutes: reclutamientoRoutes,
                                portalCandidatoRoutes: portalCandidatoRoutes,
                                isPortalEmpleadoSelected:
                                    isPortalEmpleadoSelected,
                                isReclutamientoSelected:
                                    isReclutamientoSelected,
                                isPortalCandidatoSelected:
                                    isPortalCandidatoSelected,
                                onNavigate: (index) {
                                  setState(() => currentIndex = index);
                                  _navigationBarBloc.add(
                                    UpdateIndexNavegationEvent(index),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Contenido colapsado
                          AnimatedOpacity(
                            duration: _animationDuration,
                            opacity: (collapsedOpacity * 1.2).clamp(0.0, 1.0),
                            child: IgnorePointer(
                              ignoring: isExpanded,
                              child: CollapsedSidebarContent(
                                currentRoute: currentRoute,
                                portalEmpleadoRoutes: portalEmpleadoRoutes,
                                reclutamientoRoutes: reclutamientoRoutes,
                                portalCandidatoRoutes: portalCandidatoRoutes,
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

                // Área de botones inferiores
                ClipRect(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Botones expandidos
                      AnimatedOpacity(
                        duration: _animationDuration,
                        opacity: (expandedOpacity * 1.2).clamp(0.0, 1.0),
                        child: IgnorePointer(
                          ignoring: !isExpanded,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SidebarItem(
                                title: 'Ayuda y Soporte',
                                icon: LucideIcons.circleHelp,
                                isSelected: currentRoute == 'Ayuda',
                                onTap: () => print('Navegar a Ayuda'),
                              ),
                              SidebarItem(
                                title: 'Configuración',
                                icon: LucideIcons.settings,
                                isSelected: currentRoute == 'Configuracion',
                                onTap: () => print('Navegar a Configuración'),
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

                      // Botones colapsados
                      AnimatedOpacity(
                        duration: _animationDuration,
                        opacity: (collapsedOpacity * 1.2).clamp(0.0, 1.0),
                        child: IgnorePointer(
                          ignoring: isExpanded,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCollapsedItem(
                                LucideIcons.circleHelp,
                                currentRoute == 'Ayuda',
                                () => print('Navegar a Ayuda'),
                              ),
                              _buildCollapsedItem(
                                LucideIcons.settings,
                                currentRoute == 'Configuracion',
                                () => print('Navegar a Configuración'),
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
