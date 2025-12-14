import 'package:flutter/material.dart';
import 'package:my_sage_agent/ui/components/transaction_tile.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardRecentTransactions extends StatelessWidget {
  const DashboardRecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .only(left: 20, right: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Text(
                  'Today\'s Collections',
                  style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See all',
                    style: PrimaryTextStyle(
                      fontSize: 14,
                      fontWeight: .normal,
                      color: ThemeUtil.subtitleGrey,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: ThemeUtil.headerBackground, thickness: 1),
            TransactionTile(
              amount: 2500.00,
              date: DateTime.now(),
              name: 'John Doe',
              type: 'Investment',
            ),
            Divider(color: ThemeUtil.headerBackground, thickness: 1),
          ],
        ),
      ),
    );
  }
}
