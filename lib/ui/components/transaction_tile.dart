import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.amount,
    required this.date,
    required this.name,
    required this.type,
  });

  final String name;
  final String type;
  final double amount;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                Text(
                  name,
                  textAlign: .start,
                  style: PrimaryTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ThemeUtil.black,
                  ),
                ),
                Text(
                  type,
                  textAlign: .start,
                  style: PrimaryTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: ThemeUtil.flora,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .end,
              children: [
                Text(
                  'GHS ${FormatterUtil.currency(amount)}',
                  textAlign: .end,
                  style: PrimaryTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeUtil.black,
                  ),
                ),
                Text(
                  FormatterUtil.fullDate(date),
                  textAlign: .end,
                  style: PrimaryTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: ThemeUtil.flora,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
