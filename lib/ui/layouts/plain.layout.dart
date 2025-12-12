import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/utils/help.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class PlainLayout extends StatelessWidget {
  const PlainLayout({super.key, this.backIcon, this.onPressHelped, this.title, this.subtitle, this.miniTitle, required this.children, this.useCloseIcon = false, this.onBackPressed, this.centerTitle = false, this.centerSubtitle = false, this.titleTextColor = Colors.black, this.noHelp = false});

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
              leading: IconButton(
                style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
                onPressed:
                    onBackPressed ??
                    () {
                      context.pop();
                    },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              title: Text(
                miniTitle ?? '',
                style: const PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff010101)),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                  onPressed: () {
                    HelpUtil.show(onCancelled: () {});
                  },
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, size: 24),
                      const SizedBox(width: 5),
                      Text('Help', style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                          style: TextStyle(fontFamily: ThemeUtil.fontHelveticaNeue, color: titleTextColor, fontSize: 22, fontWeight: FontWeight.w800),
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
                            style: const TextStyle(color: Color(0xff4F4F4F), fontWeight: FontWeight.w400, fontSize: 14),
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
