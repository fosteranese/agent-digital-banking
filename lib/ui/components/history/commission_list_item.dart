import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/commission_model.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CommissionListItem extends StatelessWidget {
  final CommissionModel record;
  final VoidCallback? onTap;

  const CommissionListItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: true,
      child: Container(
        padding: const .symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(borderRadius: .circular(12)),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            _buildDetails(),
            Text(
              'GHS ${FormatterUtil.currency(record.amount)}',
              style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 14, fontWeight: .w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FormatterUtil.shortDateOnly(record.dateCreated!),
            maxLines: 2,
            overflow: .ellipsis,
            style: PrimaryTextStyle(fontSize: 14, fontWeight: .w600),
          ),
          const SizedBox(height: 5),
          Text(
            FormatterUtil.timeOnly(record.dateCreated!),
            style: PrimaryTextStyle(color: ThemeUtil.flora, fontSize: 13, fontWeight: .w400),
          ),
        ],
      ),
    );
  }
}
