import 'package:flutter/material.dart';

import '../../data/models/history/activity.dart';
import '../components/item.dart';
import '../layouts/main.layout.dart';

class FilterHistoryPage extends StatelessWidget {
  const FilterHistoryPage({
    super.key,
    required this.activities,
    required this.onAllSelected,
    required this.onSelected,
  });
  static const routeName = '/history/filter';
  final List<Activity> activities;
  final void Function() onAllSelected;
  final void Function(Activity activity) onSelected;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Filter',
      showBackBtn: true,
      useCloseIcon: true,
      // titleColor: Colors.black,
      // backgroundColor: const Color(0xffF6F6F6),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Item(
              onPressed: onAllSelected,
              padding: EdgeInsets.zero,
              title: 'All',
            ),
            const Divider(color: Color(0xffF1F1F1)),
            ...activities.map((e) {
              return Item(
                onPressed: () => onSelected(e),
                padding: EdgeInsets.zero,
                title: e.activityName ?? '',
              );
            }),
          ],
        ),
      ),
    );
  }
}