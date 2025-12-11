import 'package:flutter/material.dart';

import '../data/models/request_response.dart';
import '../ui/pages/filter_history.page.dart';
import '../ui/pages/history.page.dart';
import '../ui/pages/receipt.page.dart';

class HistoryRouter {
  Widget? pageRoute(RouteSettings routeSettings) {
    Widget? page;
    switch (routeSettings.name) {
      // case '/':
      case HistoryPage.routeName:
        final payload = (routeSettings.arguments ?? false) as bool;
        page = HistoryPage(
          showBackBtn: payload,
        );
        break;

      case FilterHistoryPage.routeName:
        final params = routeSettings.arguments as Map<String, dynamic>;
        page = FilterHistoryPage(
          activities: params['activities'],
          onAllSelected: params['onAllSelected'],
          onSelected: params['onSelected'],
        );
        break;

      case ReceiptPage.routeName:
        final params = routeSettings.arguments as Map<String, dynamic>;
        page = ReceiptPage(
          request: params['request'] as RequestResponse,
          imageBaseUrl: params['imageBaseUrl'] as String,
          imageDirectory: params['imageDirectory'] as String,
          fblLogo: params['fblLogo'] as String,
        );
        break;
    }

    return page;
  }
}