import 'package:flutter/material.dart';

import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class MyTabHeader2 extends StatefulWidget {
  const MyTabHeader2({
    super.key,
    required this.tabItems,
    required this.controller,
    this.scrollable = true,
  });

  final List<TabItem> tabItems;
  final ValueNotifier<String> controller;
  final bool scrollable;

  @override
  State<MyTabHeader2> createState() => _MyTabHeader2State();
}

class _MyTabHeader2State extends State<MyTabHeader2> with SingleTickerProviderStateMixin {
  final _selectedTab = ValueNotifier(0);
  late final _tabController = TabController(length: widget.tabItems.length, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(color: ThemeUtil.headerBackground, borderRadius: .circular(8)),
      child: TabBar(
        controller: _tabController,
        padding: .all(8),
        dividerHeight: 0,
        indicatorSize: .label,
        labelColor: Colors.black,
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: true,
        splashBorderRadius: .circular(8),
        indicatorWeight: 0,

        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        indicatorPadding: .zero,
        labelPadding: .zero,
        tabAlignment: widget.scrollable ? TabAlignment.start : TabAlignment.center,
        onTap: (index) {
          _selectedTab.value = index;
          widget.controller.value = widget.tabItems[index].id ?? '';
        },
        isScrollable: widget.scrollable,
        labelStyle: PrimaryTextStyle(fontSize: 14, fontWeight: .w400),
        tabs: widget.tabItems.map((e) => _getTabItem(e.title)).toList(),
      ),
    );
  }

  Widget _getTabItem(String title) => ValueListenableBuilder(
    valueListenable: _selectedTab,
    builder: (context, value, child) {
      return Container(
        padding: .symmetric(horizontal: 10),
        height: double.maxFinite,
        decoration: BoxDecoration(borderRadius: .circular(8)),
        alignment: .center,
        child: Text(title, maxLines: 1, overflow: .ellipsis),
      );
    },
  );
}
