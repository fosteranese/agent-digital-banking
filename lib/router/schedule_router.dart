import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../data/models/schedule/schedules.dart';
import '../data/models/user_response/activity_datum.dart';
import '../ui/pages/schedules/schedule_details.page.dart';
import '../ui/pages/schedules/schedules.page.dart';

class ScheduleRouter {
  Widget? pageRoute(RouteSettings routeSettings) {
    Widget? page;
    switch (routeSettings.name) {
      case SchedulesPage.routeName:
        final payload =
            routeSettings.arguments as ActivityDatum;
        page = SchedulesPage(payload);

      case ScheduleDetailsPage.routeName:
        final payload =
            routeSettings.arguments as Schedules;
        page = ScheduleDetailsPage(payload);
        break;
    }

    return page;
  }

  static void handleBottomNavBarVisibility({
    required String screenName,
    required BuildContext context,
  }) {
    switch (screenName) {
      case SchedulesPage.routeName:
        context.read<BottomNavBarBloc>().add(
          ShowBottomNavBar(screenName),
        );
        break;

      case ScheduleDetailsPage.routeName:
        context.read<BottomNavBarBloc>().add(
          HideBottomNavBar(screenName),
        );
        break;
    }
  }
}
