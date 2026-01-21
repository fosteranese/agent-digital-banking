import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bottom_nav_bar/bottom_nav_bar_bloc.dart';

class NavigatorUtil {
  static void pushName(
    BuildContext context, {
    required String routeName,
    required NavigatorState nav,
    bool showNavBar = true,
    Object? arguments,
  }) {
    // if (showNavBar) {
    //   context.read<BottomNavBarBloc>().add(ShowBottomNavBar(routeName));
    // } else {
    //   context.read<BottomNavBarBloc>().add(HideBottomNavBar(routeName));
    // }

    nav.pushNamed(routeName, arguments: arguments);
  }

  static void pop(
    BuildContext context, {
    required NavigatorState nav,
    String? routeName,
    List<String>? routeNames,
    bool showNavBar = true,
  }) {
    if (showNavBar) {
      context.read<BottomNavBarBloc>().add(ShowBottomNavBar(routeName ?? ''));
    } else {
      context.read<BottomNavBarBloc>().add(HideBottomNavBar(routeName ?? ''));
    }

    if (routeName != null && routeName.isNotEmpty) {
      nav.popUntil(ModalRoute.withName(routeName));
      return;
    }

    if (routeNames != null && routeNames.isNotEmpty) {
      nav.popUntil((route) {
        return routeNames.contains(route.settings.name);
      });
      return;
    }
    nav.pop();
  }
}
