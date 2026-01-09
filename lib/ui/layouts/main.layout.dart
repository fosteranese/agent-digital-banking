import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/utils/navigator.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    this.nav,
    this.onBackPressed,
    this.showNavBarOnPop = true,
    this.backIcon,
    this.title,
    this.bottom,
    this.actions,
    this.showBackBtn = false,
    this.useCloseIcon = false,
    this.titleColor,
    this.backgroundColor,
    this.child,
    this.children = const [],
    this.sliver,
    this.slivers = const [],
    this.isTopPadded = true,
    this.useCustomScroll = true,
    this.scrollController,
    this.physics,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonMargin = 50,
    this.refreshController,
    this.onRefresh,
    this.refreshBackgroundColor,
    this.refreshColor,
    this.bottomNavigationBar,
    this.flexibleSpace,
    this.useSafeArea = true,
  });

  final NavigatorState? nav;
  final Widget? backIcon;
  final String? title;
  final Widget? child;
  final List<Widget> children;
  final Widget? sliver;
  final List<Widget> slivers;
  final bool useCloseIcon;
  final void Function()? onBackPressed;
  final PreferredSizeWidget? bottom;
  final bool showBackBtn;
  final Color? titleColor;
  final Color? backgroundColor;
  final bool showNavBarOnPop;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool isTopPadded;
  final List<Widget>? actions;
  final GlobalKey<RefreshIndicatorState>? refreshController;
  final Future<void> Function()? onRefresh;
  final Widget? bottomNavigationBar;
  final ScrollPhysics? physics;
  final double floatingActionButtonMargin;
  final bool useCustomScroll;
  final Color? refreshBackgroundColor;
  final Color? refreshColor;
  final ScrollController? scrollController;
  final Widget? flexibleSpace;
  final bool useSafeArea;

  bool get _hasAppBar => title != null || showBackBtn || bottom != null;

  double _spaceAllowed(BuildContext context) {
    return 0;
  }

  // double _spaceAllowed(BuildContext context) {
  //   final safeAreaBottomPadding = MediaQuery.of(
  //     context,
  //   ).padding.bottom;
  //   final navVisible = context
  //       .read<BottomNavBarBloc>()
  //       .visible;
  //   return navVisible ? safeAreaBottomPadding + 100 : 0;
  // }

  Widget _safeSliver(Widget sliver, double spaceAllowed) {
    return SliverSafeArea(
      top: isTopPadded,
      bottom: useCustomScroll,
      sliver: SliverPadding(
        padding: EdgeInsets.only(bottom: spaceAllowed),
        sliver: sliver,
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context, double spaceAllowed) {
    final sliverList = <Widget>[];

    if (sliver != null) {
      sliverList.add(_safeSliver(sliver!, spaceAllowed));
    }

    if (slivers.isNotEmpty) {
      sliverList.addAll(
        slivers.expand(
          (e) => [
            e,
            if (e == slivers.last && useSafeArea)
              SliverToBoxAdapter(child: SizedBox(height: spaceAllowed)),
          ],
        ),
      );
    }

    if (child != null) {
      sliverList.add(
        _safeSliver(SliverFillRemaining(hasScrollBody: false, child: child!), spaceAllowed),
      );
    }

    if (children.isNotEmpty) {
      sliverList.add(
        _safeSliver(
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          spaceAllowed,
        ),
      );
    }

    return CustomScrollView(
      primary: true,
      controller: scrollController,
      physics: physics ?? AlwaysScrollableScrollPhysics(),
      slivers: sliverList,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeUtil.primaryColor,
      automaticallyImplyLeading: false,
      leading: showBackBtn
          ? IconButton(
              onPressed:
                  onBackPressed ??
                  () {
                    NavigatorUtil.pop(
                      context,
                      nav: nav ?? MyApp.navigatorKey.currentState ?? Navigator.of(context),
                      showNavBar: showNavBarOnPop,
                    );
                  },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
          : null,
      title: Text(
        title ?? '',
        style: PrimaryTextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      bottom: bottom,
      elevation: 0,
      actions: actions,
    );
  }

  static bool isRefreshing = false;
  // Call this from anywhere to end refresh
  static void stopRefresh(BuildContext context) {
    if (!isRefreshing) return;
    isRefreshing = false;
  }

  @override
  Widget build(BuildContext context) {
    final spaceAllowed = _spaceAllowed(context);

    final content = (useCustomScroll || child == null)
        ? _buildScrollContent(context, spaceAllowed)
        : child ?? const SizedBox.shrink();

    final body = (onRefresh != null)
        ? EasyRefresh(
            header: MaterialHeader(
              backgroundColor: Theme.of(context).primaryColor,
              color: Colors.white,
            ),
            onRefresh: () async {
              final completer = Completer<void>();
              isRefreshing = true;
              onRefresh!();
              Timer.periodic(Duration(milliseconds: 50), (timer) {
                if (!isRefreshing) {
                  timer.cancel();
                  completer.complete();
                }
              });

              return completer.future;
            },
            child: content,
          )
        : content;

    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: _hasAppBar ? _buildAppBar(context) : null,
      body: body,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: floatingActionButtonMargin),
        child: floatingActionButton,
      ),
      floatingActionButtonLocation:
          floatingActionButtonLocation ?? FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigationBar != null
          ? SafeArea(bottom: useSafeArea, child: bottomNavigationBar!)
          : null,
    );
  }
}
