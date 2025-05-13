part of 'navegation_bar_bloc.dart';

class NavegationBarState extends Equatable {
  final int index;
  final int indexCategory;

  const NavegationBarState({this.index = 0, this.indexCategory = 0});

  NavegationBarState copyWith({int? index, int? indexCategory}) =>
      NavegationBarState(
        index: index ?? this.index,
        indexCategory: indexCategory ?? this.indexCategory,
      );

  @override
  List<Object> get props => [index, indexCategory];
}
