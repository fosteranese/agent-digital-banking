import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/utils/help.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class PlainLayout extends StatelessWidget {
  const PlainLayout({
    super.key,
    this.backIcon,
    this.onPressHelped,
    this.title,
    this.subtitle,
    this.miniTitle,
    required this.children,
    this.useCloseIcon = false,
    this.onBackPressed,
    this.centerTitle = false,
    this.centerSubtitle = false,
    this.titleTextColor = Colors.black,
    this.noHelp = false,
  });

  final Widget? backIcon;
  final void Function()? onPressHelped;
  final String? title;
  final String? subtitle;
  final String? miniTitle;
  final List<Widget> children;
  final bool useCloseIcon;
  final void Function()? onBackPressed;
  final bool centerTitle;
  final bool centerSubtitle;
  final Color titleTextColor;
  final bool noHelp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: IconButton.filled(
                style: IconButton.styleFrom(
                  fixedSize: const Size(35, 35),
                  backgroundColor: ThemeUtil.offWhite,
                ),
                onPressed:
                    onBackPressed ??
                    () {
                      context.pop();
                    },
                icon: const Icon(Icons.arrow_back, color: ThemeUtil.black),
              ),
              title: Text(
                miniTitle ?? '',
                style: const PrimaryTextStyle(
                  fontWeight: .w600,
                  fontSize: 16,
                  color: ThemeUtil.black,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: ThemeUtil.offWhite,
                    foregroundColor: ThemeUtil.black,
                    padding: .symmetric(horizontal: 15),
                  ),
                  onPressed: () {
                    HelpUtil.show(onCancelled: () {});
                  },
                  child: Text('Help', style: PrimaryTextStyle(fontSize: 13, fontWeight: .w400)),
                ),
                const SizedBox(width: 5),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Align(
                        alignment: centerTitle ? Alignment.topCenter : Alignment.topLeft,
                        child: Text(
                          title!,
                          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                          style: const PrimaryTextStyle(
                            fontWeight: .w600,
                            fontSize: 24,
                            color: ThemeUtil.sikaBlack,
                          ),
                        ),
                      ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Align(
                          alignment: centerTitle ? Alignment.topCenter : Alignment.topLeft,
                          child: Text(
                            subtitle!,
                            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                            style: const PrimaryTextStyle(
                              color: ThemeUtil.flat,
                              fontWeight: .w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    if (title != null) const SizedBox(height: 10),
                    ...children,
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }
}
