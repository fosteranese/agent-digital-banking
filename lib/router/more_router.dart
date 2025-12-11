import 'package:flutter/material.dart';

import '../ui/pages/more/more.page.dart';
import '../ui/pages/more/profile.page.dart';

class MoreRouter {
  Widget? pageRoute(RouteSettings routeSettings) {
    Widget? page;
    switch (routeSettings.name) {
      // case '/':
      case MorePage.routeName:
        page = const MorePage();
        break;

      case ProfilePage.routeName:
        page = const ProfilePage();
        break;
    }

    return page;
  }
}
