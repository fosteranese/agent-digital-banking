import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class BottomNavBarBloc
    extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc()
    : super(const BottomNavBarVisible('')) {
    on(_onShowNavBar);
    on(_onHiddenNavBar);
    on(_onChangeBottomNavigationTab);
  }

  bool visible = true;

  void _onShowNavBar(
    ShowBottomNavBar event,
    Emitter<BottomNavBarState> emit,
  ) {
    emit(ChangingBottomNavBarVisible(event.routeName));
    visible = true;
    emit(BottomNavBarVisible(event.routeName));
  }

  void _onHiddenNavBar(
    HideBottomNavBar event,
    Emitter<BottomNavBarState> emit,
  ) {
    emit(ChangingBottomNavBarVisible(event.routeName));
    visible = false;
    emit(BottomNavBarHidden(event.routeName));
  }

  void _onChangeBottomNavigationTab(
    ChangeBottomNavigationTab event,
    Emitter<BottomNavBarState> emit,
  ) {
    emit(ChangingBottomNavigationTab(event.routeName));
    emit(
      BottomNavigationTabChanged(
        index: event.index,
        routeName: event.routeName,
      ),
    );
  }
}
