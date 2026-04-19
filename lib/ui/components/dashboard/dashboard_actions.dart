import 'package:flutter/material.dart';

import 'package:my_sage_agent/ui/components/dashboard/dashboard_button.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardActions extends StatefulWidget {
  const DashboardActions({super.key});

  @override
  State<DashboardActions> createState() => _DashboardActionsState();
}

class _DashboardActionsState extends State<DashboardActions> {
  @override
  Widget build(BuildContext context) {
    // final actions = _actions(context);
    return SliverPadding(
      padding: const .only(top: 20, left: 20, right: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Text(
              'What do you want to do?',
              style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 320,
              child: GridView(
                padding: .zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: AppUtil.currentUser!.activities!.map((item) {
                  return DashboardButton(category: DashboardPage.category, item: item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
