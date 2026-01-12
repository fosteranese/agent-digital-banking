import 'package:flutter/material.dart';

import 'package:my_sage_agent/utils/theme.util.dart';

class TabItem {
  TabItem({required this.title, this.id});
  final String title;
  final String? id;
}

class MyTabHeader extends StatefulWidget {
  const MyTabHeader({super.key, required this.tabItems, required this.controller});

  final List<TabItem> tabItems;
  final ValueNotifier<String> controller;

  @override
  State<MyTabHeader> createState() => _MyTabHeaderState();
}

class _MyTabHeaderState extends State<MyTabHeader> with SingleTickerProviderStateMixin {
  final _selectedTab = ValueNotifier(0);
  late final _tabController = TabController(length: widget.tabItems.length, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(color: Color(0xffF4F4F4), borderRadius: BorderRadius.circular(50)),
      child: TabBar(
        controller: _tabController,
        padding: .all(8),
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: true,
        splashBorderRadius: BorderRadius.circular(50),
        indicatorWeight: 0,
        indicator: BoxDecoration(
          color: ThemeUtil.primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        labelPadding: .zero,
        onTap: (index) {
          _selectedTab.value = index;
          widget.controller.value = widget.tabItems[index].id ?? '';
        },
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
        width: double.maxFinite,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        alignment: Alignment.center,
        child: Text(title),
      );
    },
  );
}
