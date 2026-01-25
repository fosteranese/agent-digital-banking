import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/ui/pages/login/new_device_login.page.dart';
import 'package:my_sage_agent/utils/help.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class PlainWithHeaderLayout extends StatefulWidget {
  const PlainWithHeaderLayout({
    super.key,
    this.backIcon,
    this.onPressHelped,
    this.title,
    this.subtitle,
    this.miniTitle,
    required this.children,
    this.useCloseIcon = false,
    this.onBackPressed,
    this.onPressedSubtitle,
    this.sidesPadding = 10,
    this.subtitleWidget,
    this.bottomNavigationBar,
  });

  final Widget? backIcon;
  final void Function()? onPressHelped;
  final String? title;
  final String? subtitle;
  final String? miniTitle;
  final List<Widget> children;
  final bool useCloseIcon;
  final void Function()? onBackPressed;
  final void Function()? onPressedSubtitle;
  final double sidesPadding;
  final Widget? subtitleWidget;
  final Widget? bottomNavigationBar;

  @override
  State<PlainWithHeaderLayout> createState() => _PlainWithHeaderLayoutState();
}

class _PlainWithHeaderLayoutState extends State<PlainWithHeaderLayout> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final remainingHeight =
        MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.39,
            decoration: BoxDecoration(
              color: Color(0xffFAEFD5),
              gradient: LinearGradient(
                stops: [0, 1],
                colors: [Color(0xffFAEFD5), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leadingWidth: 0,
                title: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0x91F7C15A),
                    fixedSize: Size(35, 35),
                  ),
                  onPressed:
                      widget.onBackPressed ??
                      () {
                        if (context.canPop()) {
                          context.pop();
                          return;
                        }
                        context.go(NewDeviceLoginPage.routeName);
                      },
                  color: Colors.white,
                  icon: const Icon(Icons.keyboard_backspace, color: Colors.black, size: 20),
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.transparent,
                  statusBarColor: Colors.transparent,
                ),
                pinned: true,
                floating: true,
                actions: [
                  TextButton(
                    onPressed: () {
                      HelpUtil.show(onCancelled: () {});
                    },
                    child: Row(
                      children: [
                        Icon(Icons.help_outline, size: 24),
                        const SizedBox(width: 5),
                        Text(
                          'Help',
                          style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  width: double.maxFinite,
                  height: remainingHeight,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      top: false,
                      // bottom: false,
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    widget.title!,
                                    style: PrimaryTextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                if ((widget.subtitle?.isNotEmpty ?? false) ||
                                    (widget.subtitleWidget != null))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 20, top: 5),
                                    child: InkWell(
                                      onTap: widget.onPressedSubtitle,
                                      child:
                                          widget.subtitleWidget ??
                                          Text(
                                            widget.subtitle!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                    ),
                                  ),
                                if ((widget.subtitle?.isNotEmpty ?? false) ||
                                    (widget.subtitleWidget != null))
                                  const SizedBox(height: 25),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 16,
                                    ),
                                    decoration: const BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: widget.children,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
