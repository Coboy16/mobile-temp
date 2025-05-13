part of 'navegation_bar_bloc.dart';

sealed class NavegationBarEvent extends Equatable {
  const NavegationBarEvent();

  @override
  List<Object> get props => [];
}

class UpdateIndexNavegationEvent extends NavegationBarEvent {
  final int index;
  const UpdateIndexNavegationEvent(this.index);
}

class UpdateIndexCategoryNavegationEvent extends NavegationBarEvent {
  final int indexCategory;
  const UpdateIndexCategoryNavegationEvent(this.indexCategory);
}
