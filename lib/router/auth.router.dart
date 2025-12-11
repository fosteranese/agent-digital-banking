import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/ui/components/bottom_navbar.cm.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/history.page.dart';
import 'package:agent_digital_banking/ui/pages/more/more.page.dart';
import 'package:agent_digital_banking/ui/pages/recipient/recipient.page.dart';

final authRouter = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return BottomNavBar(state: state, navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [GoRoute(path: DashboardPage.routeName, builder: (context, state) => const DashboardPage())],
    ),

    StatefulShellBranch(
      routes: [GoRoute(path: PayeesPage.routeName, builder: (context, state) => const PayeesPage())],
    ),

    StatefulShellBranch(
      routes: [GoRoute(path: HistoryPage.routeName, builder: (context, state) => const HistoryPage())],
    ),

    StatefulShellBranch(
      routes: [GoRoute(path: MorePage.routeName, builder: (context, state) => const MorePage())],
    ),
  ],
);
