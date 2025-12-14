import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/ui/components/bottom_navbar.cm.dart';
import 'package:my_sage_agent/ui/pages/collectionsPage.page.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/history.page.dart';
import 'package:my_sage_agent/ui/pages/more/more.page.dart';

final authRouter = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return BottomNavBar(state: state, navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(path: DashboardPage.routeName, builder: (context, state) => const DashboardPage()),
      ],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(
          path: CollectionsPage.routeName,
          builder: (context, state) => const CollectionsPage(),
        ),
      ],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(path: HistoryPage.routeName, builder: (context, state) => const HistoryPage()),
      ],
    ),

    StatefulShellBranch(
      routes: [GoRoute(path: MorePage.routeName, builder: (context, state) => const MorePage())],
    ),
  ],
);
