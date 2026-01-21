part of 'bottom_nav_bar_bloc.dart';

abstract class BottomNavBarState extends Equatable {
  const BottomNavBarState();

  @override
  List<Object> get props => [];
}

class BottomNavBarInitial extends BottomNavBarState {}

class ChangingBottomNavBarVisible extends BottomNavBarState {
  const ChangingBottomNavBarVisible(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class BottomNavBarHidden extends BottomNavBarState {
  const BottomNavBarHidden(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class BottomNavBarVisible extends BottomNavBarState {
  const BottomNavBarVisible(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class ChangingBottomNavigationTab extends BottomNavBarState {
  const ChangingBottomNavigationTab(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class BottomNavigationTabChanged extends BottomNavBarState {
  const BottomNavigationTabChanged({required this.index, required this.routeName});
  final int index;
  final String routeName;

  @override
  List<Object> get props => [index, routeName];
}
