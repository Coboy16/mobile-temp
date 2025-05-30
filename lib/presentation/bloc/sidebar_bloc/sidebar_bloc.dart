import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/presentation/widgets/widgets.dart'; // Para AppSidebarMenuRoutes

part 'sidebar_event.dart';
part 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc({
    String initialRoute = AppSidebarMenuRoutes.solicitudes,
    String? initialParentRoute,
    bool initialIsSmallScreen = false,
  }) : super(
         SidebarState.initial(
           initialRoute: initialRoute,
           initialParentRoute: initialParentRoute,
           initialIsSmallScreen: initialIsSmallScreen,
         ),
       ) {
    on<SidebarRouteSelected>(_onSidebarRouteSelected);
    on<SidebarExpansionToggled>(_onSidebarExpansionToggled);
    on<SidebarVisibilityToggled>(_onSidebarVisibilityToggled);
    on<SidebarLayoutChanged>(_onSidebarLayoutChanged);
  }

  void _onSidebarRouteSelected(
    SidebarRouteSelected event,
    Emitter<SidebarState> emit,
  ) {
    final newExpandedParentRoutes = Set<String>.from(
      state.expandedParentRoutes,
    );

    if (event.isParentItem) {
      if (newExpandedParentRoutes.contains(event.routeName)) {
        newExpandedParentRoutes.remove(event.routeName);
      } else {
        newExpandedParentRoutes.add(event.routeName);
      }
    } else if (event.parentRouteName != null &&
        !newExpandedParentRoutes.contains(event.parentRouteName!)) {
      newExpandedParentRoutes.add(event.parentRouteName!);
    }

    emit(
      state.copyWith(
        currentSelectedRoute: event.routeName,
        expandedParentRoutes: newExpandedParentRoutes,
      ),
    );
  }

  void _onSidebarExpansionToggled(
    SidebarExpansionToggled event,
    Emitter<SidebarState> emit,
  ) {
    final newExpandedParentRoutes = Set<String>.from(
      state.expandedParentRoutes,
    );
    if (newExpandedParentRoutes.contains(event.parentRouteName)) {
      newExpandedParentRoutes.remove(event.parentRouteName);
    } else {
      newExpandedParentRoutes.add(event.parentRouteName);
    }
    emit(state.copyWith(expandedParentRoutes: newExpandedParentRoutes));
  }

  void _onSidebarVisibilityToggled(
    SidebarVisibilityToggled event,
    Emitter<SidebarState> emit,
  ) {
    emit(
      state.copyWith(
        isSidebarExpanded: event.forceState ?? !state.isSidebarExpanded,
      ),
    );
  }

  void _onSidebarLayoutChanged(
    SidebarLayoutChanged event,
    Emitter<SidebarState> emit,
  ) {
    debugPrint(
      "[SidebarBloc] Layout changed - isSmallScreen: ${event.isSmallScreen}, current state: ${state.isSmallScreenLayout}",
    );

    if (event.isSmallScreen != state.isSmallScreenLayout) {
      debugPrint(
        "[SidebarBloc] Updating layout - new isSmallScreenLayout: ${event.isSmallScreen}",
      );
      emit(
        state.copyWith(
          isSmallScreenLayout: event.isSmallScreen,
          isSidebarExpanded: !event.isSmallScreen,
        ),
      );
    }
  }
}
