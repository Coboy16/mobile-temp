// lib/presentation/feactures/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/presentation/feactures/check_payment/check.dart';
import '/presentation/feactures/request/request.dart';
import '/presentation/feactures/perfil/perfil.dart';

import '/presentation/widgets/widgets.dart';
import '/presentation/bloc/blocs.dart';
import '/presentation/widgets/sidebar/sidebar_menu_constants.dart';

class HomeScreen extends StatefulWidget {
  final String currentRouteKeyFromRouter; // Nuevo parámetro

  const HomeScreen({
    super.key,
    required this.currentRouteKeyFromRouter, // Requerido
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Sincronizar el SidebarBloc con la ruta actual de GoRouter
    // Esto asegura que si se accede a la URL directamente, el sidebar se actualice
    // Esto también maneja el estado inicial cuando HomeScreen se carga por primera vez
    // para una sub-ruta específica.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sidebarBloc = context.read<SidebarBloc>();
      if (sidebarBloc.state.currentSelectedRoute !=
          widget.currentRouteKeyFromRouter) {
        // Determinar parentRouteName si es aplicable
        String? parentRouteName;
        if (AppSidebarMenuRoutes.solicitudes ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.comprobantesPago ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.informeCursos ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.colaAprobacion ==
                widget.currentRouteKeyFromRouter) {
          parentRouteName = AppSidebarMenuRoutes.portalEmpleado;
        } else if (AppSidebarMenuRoutes.ofertasTrabajo ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.candidatos ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.portalPublico ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.pruebasPsicometricas ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.ajustes == widget.currentRouteKeyFromRouter) {
          parentRouteName = AppSidebarMenuRoutes.reclutamiento;
        } else if (AppSidebarMenuRoutes.subitemCandidato ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.misPostulaciones ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.miPerfilCandidato ==
                widget.currentRouteKeyFromRouter) {
          parentRouteName = AppSidebarMenuRoutes.portalCandidato;
        }
        // Considerar isParentItem también si la clave actual es una ruta padre
        bool isParentItem =
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.portalEmpleado ||
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.reclutamiento ||
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.portalCandidato;

        sidebarBloc.add(
          SidebarRouteSelected(
            widget.currentRouteKeyFromRouter,
            parentRouteName: parentRouteName,
            isParentItem: isParentItem,
          ),
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la ruta de GoRouter cambia mientras HomeScreen ya está en el árbol,
    // también actualizamos el SidebarBloc.
    if (oldWidget.currentRouteKeyFromRouter !=
        widget.currentRouteKeyFromRouter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sidebarBloc = context.read<SidebarBloc>();
        String? parentRouteName;
        if (AppSidebarMenuRoutes.solicitudes ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.comprobantesPago ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.informeCursos ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.colaAprobacion ==
                widget.currentRouteKeyFromRouter) {
          parentRouteName = AppSidebarMenuRoutes.portalEmpleado;
        } else if (AppSidebarMenuRoutes.ofertasTrabajo ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.candidatos ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.portalPublico ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.pruebasPsicometricas ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.ajustes == widget.currentRouteKeyFromRouter) {
          parentRouteName = AppSidebarMenuRoutes.reclutamiento;
        } else if (AppSidebarMenuRoutes.subitemCandidato ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.misPostulaciones ==
                widget.currentRouteKeyFromRouter ||
            AppSidebarMenuRoutes.miPerfilCandidato ==
                widget.currentRouteKeyFromRouter) {
          parentRouteName = AppSidebarMenuRoutes.portalCandidato;
        }
        bool isParentItem =
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.portalEmpleado ||
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.reclutamiento ||
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.portalCandidato;

        sidebarBloc.add(
          SidebarRouteSelected(
            widget.currentRouteKeyFromRouter,
            parentRouteName: parentRouteName,
            isParentItem: isParentItem,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SidebarWidget(),
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(),
                Expanded(
                  child: BlocBuilder<SidebarBloc, SidebarState>(
                    builder: (context, state) {
                      // La vista ahora se determina por el estado del SidebarBloc,
                      // que está siendo sincronizado con GoRouter.
                      return _getViewForSidebarRoute(
                        state.currentSelectedRoute,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getViewForSidebarRoute(String routeName) {
    switch (routeName) {
      case AppSidebarMenuRoutes.solicitudes:
      case AppSidebarMenuRoutes.portalEmpleado:
        return const RequestScreen();
      case AppSidebarMenuRoutes.comprobantesPago:
        return const CheckPaymentScreen();
      case AppSidebarMenuRoutes.informeCursos:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.informeCursos}'),
        );
      case AppSidebarMenuRoutes.colaAprobacion:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.colaAprobacion}'),
        );

      case AppSidebarMenuRoutes.ofertasTrabajo:
      case AppSidebarMenuRoutes.reclutamiento:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.ofertasTrabajo}'),
        );
      case AppSidebarMenuRoutes.candidatos:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.candidatos}'),
        );
      case AppSidebarMenuRoutes.portalPublico:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.portalPublico}'),
        );
      case AppSidebarMenuRoutes.pruebasPsicometricas:
        return Center(
          child: Text(
            'Vista para ${AppSidebarMenuRoutes.pruebasPsicometricas}',
          ),
        );
      case AppSidebarMenuRoutes.ajustes:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.ajustes}'),
        );

      case AppSidebarMenuRoutes.subitemCandidato:
      case AppSidebarMenuRoutes.portalCandidato:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.subitemCandidato}'),
        );
      case AppSidebarMenuRoutes.misPostulaciones:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.misPostulaciones}'),
        );
      case AppSidebarMenuRoutes.miPerfilCandidato:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.miPerfilCandidato}'),
        );

      case AppSidebarMenuRoutes.evaluacionDesempeno:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.evaluacionDesempeno}'),
        );
      case AppSidebarMenuRoutes.consolidacion:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.consolidacion}'),
        );
      case AppSidebarMenuRoutes.calculosImpositivos:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.calculosImpositivos}'),
        );

      case AppSidebarMenuRoutes.perfilUsuarioSistema:
        return const PerfilScreen();

      case AppSidebarMenuRoutes.ayudaSoporte:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.ayudaSoporte}'),
        );
      case AppSidebarMenuRoutes.configuracion:
        return Center(
          child: Text('Vista para ${AppSidebarMenuRoutes.configuracion}'),
        );

      default: // Fallback
        if (widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.portalEmpleado ||
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.reclutamiento ||
            widget.currentRouteKeyFromRouter ==
                AppSidebarMenuRoutes.portalCandidato) {
          // Si la ruta es un padre, y no tiene un case específico, redirige al primero del padre
          // Por ejemplo, para 'Portal del Empleado', ir a 'Solicitudes'
          if (widget.currentRouteKeyFromRouter ==
              AppSidebarMenuRoutes.portalEmpleado) {
            return const RequestScreen();
          }
          if (widget.currentRouteKeyFromRouter ==
              AppSidebarMenuRoutes.reclutamiento) {
            return Center(
              child: Text('Vista para ${AppSidebarMenuRoutes.ofertasTrabajo}'),
            );
          }
          if (widget.currentRouteKeyFromRouter ==
              AppSidebarMenuRoutes.portalCandidato) {
            return Center(
              child: Text(
                'Vista para ${AppSidebarMenuRoutes.subitemCandidato}',
              ),
            );
          }
        }
        return const RequestScreen(); // O un error más específico.
    }
  }
}
