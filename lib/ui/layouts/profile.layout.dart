import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import '../../utils/navigator.util.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({
    super.key,
    this.backIcon,
    this.onPressHelped,
    this.title,
    this.child,
    this.children = const [],
    this.sliver,
    this.slivers = const [],
    this.useCloseIcon = false,
    this.onBackPressed,
    this.bottom,
    this.showBackBtn = false,
    this.backgroundColor,
    this.titleColor,
    this.showNavBarOnPop = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonMargin = 50,
    this.isTopPadded = true,
    this.actions,
    this.nav,
    this.refreshController,
    this.onRefresh,
    this.bottomNavigationBar,
    this.physics,
    this.useCustomScroll = true,
    this.profileHeight = 170,
    this.flexibleSpace,
    this.useSliverAppBar = false,
    this.headerBackgroundColor,
  });

  final NavigatorState? nav;
  final Widget? backIcon;
  final void Function()? onPressHelped;
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
  final void Function()? onRefresh;
  final Widget? bottomNavigationBar;
  final ClampingScrollPhysics? physics;
  final double floatingActionButtonMargin;
  final bool useCustomScroll;
  final double profileHeight;
  final Widget? flexibleSpace;
  final bool useSliverAppBar;
  final Color? headerBackgroundColor;

  static bool isRefreshing = false;

  static void stopRefresh(BuildContext context) {
    if (isRefreshing) isRefreshing = false;
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBottomPadding = MediaQuery.of(context).padding.bottom;
    // final double spaceAllowed =
    //     context.read<BottomNavBarBloc>().visible
    //     ? safeAreaBottomPadding + 100
    //     : 0;

    final content = _buildContent(context, 0 /*spaceAllowed*/);
    final body = onRefresh != null ? _buildRefreshWrapper(content) : content;

    return Stack(
      children: [
        Container(color: Colors.white),
        if (flexibleSpace == null) _buildBackgroundImage(),
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: useSliverAppBar ? null : _buildAppBar(context),
          body: body,
          floatingActionButton: _buildFAB(safeAreaBottomPadding),
          floatingActionButtonLocation:
              floatingActionButtonLocation ?? FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }

  Padding? _buildFAB(double safeAreaBottomPadding) {
    return floatingActionButton != null
        ? Padding(
            padding: EdgeInsets.only(bottom: safeAreaBottomPadding + floatingActionButtonMargin),
            child: floatingActionButton,
          )
        : null;
  }

  Widget _buildContent(BuildContext context, double spaceAllowed) {
    if (!useCustomScroll && child != null) return child!;

    return CustomScrollView(
      physics: physics,
      slivers: [
        if (useSliverAppBar) _buildSliverAppBar(context),
        if (sliver != null)
          SliverPadding(
            padding: EdgeInsets.only(bottom: spaceAllowed),
            sliver: sliver!,
          ),
        if (slivers.isNotEmpty) ..._buildSliversWithSpacing(spaceAllowed),
        if (child != null) _wrapSliverWithSafeArea(spaceAllowed, child!),
        if (children.isNotEmpty)
          _wrapSliverWithSafeArea(
            spaceAllowed,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildSliversWithSpacing(double spaceAllowed) {
    return slivers.expand((e) {
      return [e, if (e == slivers.last) SliverToBoxAdapter(child: SizedBox(height: spaceAllowed))];
    }).toList();
  }

  Widget _wrapSliverWithSafeArea(double spaceAllowed, Widget child) {
    return SliverSafeArea(
      top: isTopPadded,
      sliver: SliverPadding(
        padding: EdgeInsets.only(bottom: spaceAllowed),
        sliver: SliverFillRemaining(hasScrollBody: false, child: child),
      ),
    );
  }

  Widget _buildRefreshWrapper(Widget child) {
    return EasyRefresh(
      header: MaterialHeader(backgroundColor: Colors.black, color: Colors.white),
      onRefresh: () async {
        final completer = Completer<void>();
        isRefreshing = true;
        onRefresh!();
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
          if (!isRefreshing) {
            timer.cancel();
            completer.complete();
          }
        });
        return completer.future;
      },
      child: child,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: headerBackgroundColor ?? backgroundColor ?? Colors.transparent,
      leading: showBackBtn ? _buildBackButton(context) : null,
      title: Text(
        title ?? '',
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      bottom: bottom,
      toolbarHeight: bottom != null ? 100 : null,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      actions: actions,
      flexibleSpace: flexibleSpace,
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      expandedHeight: profileHeight,
      pinned: true,
      snap: true,
      floating: true,
      leading: showBackBtn ? _buildBackButton(context) : null,
      title: Text(
        title ?? '',
        style: PrimaryTextStyle(
          color: titleColor ?? Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      bottom: bottom,
      toolbarHeight: bottom != null ? 100 : kToolbarHeight,
      elevation: 0,
      shadowColor: Colors.black.withAlpha(51),
      actions: actions,
      flexibleSpace: flexibleSpace,
    );
  }

  Widget _buildBackButton(BuildContext? context) {
    return IconButton(
      style: IconButton.styleFrom(
        fixedSize: const Size(35, 35),
        backgroundColor: const Color(0x91F7C15A),
      ),
      onPressed:
          onBackPressed ??
          () {
            NavigatorUtil.pop(
              context!,
              nav: nav ?? MyApp.navigatorKey.currentState ?? Navigator.of(context),
              showNavBar: showNavBarOnPop,
            );
          },
      icon: const Icon(Icons.arrow_back, color: Colors.black),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: profileHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/img/bg.png'), fit: BoxFit.cover),
      ),
    );
  }
}
