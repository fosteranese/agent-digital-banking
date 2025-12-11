import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:agent_digital_banking/blocs/history/history_bloc.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.navigationShell, required GoRouterState state});
  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _currentIndex = ValueNotifier(0);

  List<PersistentRouterTabConfig> tabs() {
    return [
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: SvgPicture.asset('assets/img/home.svg', colorFilter: ColorFilter.mode(ThemeUtil.secondaryColor, BlendMode.srcIn), width: 24),
          inactiveIcon: SvgPicture.asset('assets/img/home.svg', colorFilter: ColorFilter.mode(ThemeUtil.primaryColorList, BlendMode.srcIn), width: 24),
          title: "Home",
          iconSize: 24,
          activeForegroundColor: ThemeUtil.secondaryColor,
          inactiveForegroundColor: ThemeUtil.primaryColorList,
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(icon: const Icon(Icons.people), inactiveIcon: const Icon(Icons.people_outlined), title: "Beneficiaries", iconSize: 24, activeForegroundColor: ThemeUtil.secondaryColor, inactiveForegroundColor: ThemeUtil.primaryColorList),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(icon: const Icon(Icons.sync_alt_outlined), inactiveIcon: const Icon(Icons.sync_alt_outlined), title: "Transactions", iconSize: 24, activeForegroundColor: ThemeUtil.secondaryColor, inactiveForegroundColor: ThemeUtil.primaryColorList),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: SvgPicture.asset('assets/img/more.svg', colorFilter: ColorFilter.mode(ThemeUtil.secondaryColor, BlendMode.srcIn), width: 24),
          inactiveIcon: SvgPicture.asset('assets/img/more.svg', colorFilter: ColorFilter.mode(ThemeUtil.primaryColorList, BlendMode.srcIn), width: 24),
          title: "More",
          iconSize: 24,
          activeForegroundColor: ThemeUtil.secondaryColor,
          inactiveForegroundColor: ThemeUtil.primaryColorList,
        ),
      ),
    ];
  }

  bool _hasBottomNavBar(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.bottom > 0;
  }

  bool get isNavMovedDown {
    if (Platform.isAndroid) {
      return _hasBottomNavBar(context);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (status, data) async {
        if (GoRouter.of(context).state.path != DashboardPage.routeName) {
          context.go(DashboardPage.routeName);
          return;
        }

        AppUtil.logout();
        // await showModalBottomSheet(
        //   backgroundColor: Colors.transparent,
        //   context: context,
        //   isScrollControlled: true,
        //   builder: (context) {
        //     return PopOver(
        //       child: Padding(
        //         padding: EdgeInsets.only(
        //           top: 30,
        //           left: 30,
        //           right: 30,
        //           bottom: 20,
        //         ),
        //         child: Column(
        //           crossAxisAlignment:
        //               CrossAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Align(
        //               alignment: Alignment.topRight,
        //               child: IconButton(
        //                 onPressed: () {
        //                   context.pop();
        //                 },
        //                 icon: Icon(Icons.close),
        //               ),
        //             ),
        //             const SizedBox(height: 20),
        //             const Text(
        //               'About to Logout',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 24,
        //               ),
        //             ),
        //             const Text(
        //               'Are you sure you are ready to logout of this amazing app?',
        //               style: TextStyle(
        //                 fontWeight: FontWeight.w400,
        //                 fontSize: 20,
        //                 color: Color(0xff54534A),
        //               ),
        //             ),
        //             const SizedBox(height: 20),
        //             FormButton(
        //               onPressed: () {
        //                 // context.pop();
        //                 context.read<AuthBloc>().add(
        //                   Logout(),
        //                 );
        //               },
        //               text: 'No, Cancel',
        //             ),
        //             const SizedBox(height: 10),
        //             FormOutlineButton(
        //               backgroundColor: Colors.red,
        //               textColor: Colors.red,
        //               onPressed: () {
        //                 context.pop();
        //                 SystemNavigator.pop();
        //               },
        //               icon: SvgPicture.asset(
        //                 'assets/img/logout.svg',
        //                 colorFilter: const ColorFilter.mode(
        //                   Colors.red,
        //                   BlendMode.srcIn,
        //                 ),
        //                 width: 20,
        //               ),
        //               text: 'Yes, Close',
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // );
      },
      child: PersistentTabView.router(
        avoidBottomPadding: isNavMovedDown,
        navigationShell: widget.navigationShell,
        onTabChanged: (index) {
          _currentIndex.value = index;

          if (_currentIndex.value == 2) {
            context.read<HistoryBloc>().add(const LoadHistory(true));
          }
        },
        navBarBuilder: (navBarConfig) {
          return Style1BottomNavBar(
            navBarDecoration: NavBarDecoration(
              color: Color(0xffF6FAFF),
              border: Border(top: BorderSide(color: Color(0xffF1F3F8), width: 1)),
              padding: isNavMovedDown ? EdgeInsets.all(5) : EdgeInsets.only(top: 5, bottom: 20),
            ),
            navBarConfig: navBarConfig,
          );

          // return SizedBox();
        },
        tabs: tabs(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        // popAllScreensOnTapOfSelectedTab: true,
      ),
    );
  }
}
