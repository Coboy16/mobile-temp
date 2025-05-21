part of 'sidebar_bloc.dart';

abstract class SidebarEvent extends Equatable {
  const SidebarEvent();

  @override
  List<Object?> get props => [];
}

class SidebarRouteSelected extends SidebarEvent {
  final String routeName;
  final String? parentRouteName;
  final bool isParentItem;

  const SidebarRouteSelected(
    this.routeName, {
    this.parentRouteName,
    this.isParentItem = false,
  });

  @override
  List<Object?> get props => [routeName, parentRouteName, isParentItem];
}

class SidebarExpansionToggled extends SidebarEvent {
  final String parentRouteName;

  const SidebarExpansionToggled(this.parentRouteName);

  @override
  List<Object?> get props => [parentRouteName];
}

class SidebarVisibilityToggled extends SidebarEvent {
  final bool? forceState;
  const SidebarVisibilityToggled({this.forceState});

  @override
  List<Object?> get props => [forceState];
}

class SidebarLayoutChanged extends SidebarEvent {
  final bool isSmallScreen;
  const SidebarLayoutChanged(this.isSmallScreen);

  @override
  List<Object?> get props => [isSmallScreen];
}
