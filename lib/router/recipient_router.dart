import 'package:flutter/material.dart';

import '../data/models/payee/payees_response.dart';
import '../ui/pages/recipient/recipient_details.page.dart';
import '../ui/pages/recipient/recipient.page.dart';

class PayeeCategoriesRouter {
  Widget? pageRoute(RouteSettings routeSettings) {
    Widget? page;
    switch (routeSettings.name) {
      case '/':
      case PayeesPage.routeName:
        final payload =
            (routeSettings.arguments ?? <String, dynamic>{})
                as Map<String, dynamic>;
        page = PayeesPage(
          payeeAction:
              payload['payeeAction'] ?? PayeeAction.normal,
          group: payload['group'],
          payees: payload['payees'],
        );
        break;

      case PayeeDetailsPage.routeName:
        final payload = routeSettings.arguments as Payees;
        page = PayeeDetailsPage(payload);
        break;
    }

    return page;
  }
}