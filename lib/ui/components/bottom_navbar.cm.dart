import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

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
          icon: SvgPicture.asset(
            'assets/img/home.svg',
            colorFilter: ColorFilter.mode(ThemeUtil.primaryColor, BlendMode.srcIn),
            width: 24,
          ),
          inactiveIcon: SvgPicture.asset(
            'assets/img/home.svg',
            colorFilter: ColorFilter.mode(ThemeUtil.inactivate, BlendMode.srcIn),
            width: 24,
          ),
          title: "Home",
          iconSize: 24,
          activeForegroundColor: ThemeUtil.primaryColor,
          textStyle: GoogleFonts.mulish(fontWeight: .w600, color: ThemeUtil.flat),
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.people),
          inactiveIcon: const Icon(Icons.people, color: ThemeUtil.inactivate),
          title: "Collections",
          iconSize: 24,
          activeForegroundColor: ThemeUtil.primaryColor,
          textStyle: GoogleFonts.mulish(fontWeight: .w600, color: ThemeUtil.flat),
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.history_outlined),
          inactiveIcon: const Icon(Icons.history_outlined, color: ThemeUtil.inactivate),
          title: "Activities",
          iconSize: 24,
          activeForegroundColor: ThemeUtil.primaryColor,
          textStyle: GoogleFonts.mulish(fontWeight: .w600, color: ThemeUtil.flat),
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.more_horiz_outlined),
          inactiveIcon: const Icon(Icons.more_horiz_outlined, color: ThemeUtil.inactivate),
          title: "More",
          iconSize: 24,
          activeForegroundColor: ThemeUtil.primaryColor,
          textStyle: GoogleFonts.mulish(fontWeight: .w600, color: ThemeUtil.flat),
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
      },
      child: PersistentTabView.router(
        avoidBottomPadding: isNavMovedDown,
        navigationShell: widget.navigationShell,
        onTabChanged: (index) {
          _currentIndex.value = index;

          if (_currentIndex.value == 0 || _currentIndex.value == 1) {
            context.read<RetrieveDataBloc>().add(
              RetrieveCollectionEvent(
                id: Uuid().v4(),
                action: 'RetrieveCollectionEvent',
                skipSavedData: true,
              ),
            );
          } else if (_currentIndex.value == 2) {
            context.read<RetrieveDataBloc>().add(
              RetrieveActivitiesEvent(
                id: Uuid().v4(),
                action: 'RetrieveActivitiesEvent',
                skipSavedData: true,
              ),
            );
          }
        },
        navBarBuilder: (navBarConfig) {
          return Style1BottomNavBar(
            navBarDecoration: NavBarDecoration(
              color: Colors.white,
              // border: Border(top: BorderSide(color: Color(0xffF1F3F8), width: 1)),
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
