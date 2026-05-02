import 'package:flutter/material.dart';

import 'package:my_sage_agent/ui/components/dashboard/dashboard_button.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';

class SupervisorDashboardActions extends StatefulWidget {
  const SupervisorDashboardActions({super.key});

  @override
  State<SupervisorDashboardActions> createState() => _SupervisorDashboardActionsState();
}

class _SupervisorDashboardActionsState extends State<SupervisorDashboardActions> {
  @override
  Widget build(BuildContext context) {
    // final actions = _actions(context);
    return SliverPadding(
      padding: const .only(top: 10, left: 20, right: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              height: 140,
              child: GridView(
                padding: .zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: AppUtil.currentUser!.activities!.take(2).map((item) {
                  return DashboardButton(category: DashboardPage.category, item: item);
                }).toList(),
              ),
            ),
            if (AppUtil.currentUser!.activities!.length > 2)
              SizedBox(
                height: 130,
                child: DashboardButton(
                  category: DashboardPage.category,
                  item: AppUtil.currentUser!.activities!.skip(2).first,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
