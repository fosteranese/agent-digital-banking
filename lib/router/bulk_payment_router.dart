import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../data/models/bulk_payment/bulk_payment_groups.dart';
import '../data/models/user_response/activity_datum.dart';
import '../ui/pages/bulk_payments/bulk_payment_group_details.page.dart';
import '../ui/pages/bulk_payments/bulk_payment_groups.page.dart';

class BulkPaymentRouter {
  Widget? pageRoute(RouteSettings routeSettings) {
    Widget? page;
    switch (routeSettings.name) {
      case BulkPaymentGroupsPage.routeName:
        final payload =
            routeSettings.arguments as ActivityDatum;
        page = BulkPaymentGroupsPage(payload);
        break;

      case BulkPaymentGroupDetailsPage.routeName:
        final payload = routeSettings.arguments as Groups;
        page = BulkPaymentGroupDetailsPage(payload);
        break;
    }

    return page;
  }

  static void handleBottomNavBarVisibility({
    required String screenName,
    required BuildContext context,
  }) {
    switch (screenName) {
      case BulkPaymentGroupsPage.routeName:
        context.read<BottomNavBarBloc>().add(
          ShowBottomNavBar(screenName),
        );
        break;

      case BulkPaymentGroupDetailsPage.routeName:
        context.read<BottomNavBarBloc>().add(
          HideBottomNavBar(screenName),
        );
        break;
    }
  }
}
