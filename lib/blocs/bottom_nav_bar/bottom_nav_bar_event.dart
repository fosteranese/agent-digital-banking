part of 'bottom_nav_bar_bloc.dart';

abstract class BottomNavBarEvent extends Equatable {
  const BottomNavBarEvent();

  @override
  List<Object> get props => [];
}

class ShowBottomNavBar extends BottomNavBarEvent {
  const ShowBottomNavBar(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class HideBottomNavBar extends BottomNavBarEvent {
  const HideBottomNavBar(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class ChangeBottomNavigationTab extends BottomNavBarEvent {
  const ChangeBottomNavigationTab({required this.index, required this.routeName});
  final int index;
  final String routeName;

  @override
  List<Object> get props => [index, routeName];
}
