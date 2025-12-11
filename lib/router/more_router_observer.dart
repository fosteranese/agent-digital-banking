import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../logger.dart';
import '../main.dart';
import '../ui/pages/more/more.page.dart';
import '../ui/pages/more/profile.page.dart';
import '../ui/pages/more/security_settings.page.dart';

class MoreRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    logger.i('screenName $screenName');
    handleBottomNavBarVisibility(screenName ?? '');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }

  static void handleBottomNavBarVisibility(String screenName) {
    final context = MyApp.navigatorKey.currentContext!;

    switch (screenName) {
      case MorePage.routeName:
        context.read<BottomNavBarBloc>().add(ShowBottomNavBar(screenName));
        break;
      case ProfilePage.routeName:
        context.read<BottomNavBarBloc>().add(HideBottomNavBar(screenName));
        break;
      case SecuritySettingsPage.routeName:
        context.read<BottomNavBarBloc>().add(ShowBottomNavBar(screenName));
        break;
    }
  }
}
