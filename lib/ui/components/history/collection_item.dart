import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/collection_model.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionItem extends StatelessWidget {
  final CollectionModel record;
  final VoidCallback? onTap;

  const CollectionItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildDetails(), _buildAmountOrStatus()],
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
            record.customerName ?? 'John Doe',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            record.serviceName ?? '',
            style: PrimaryTextStyle(
              color: ThemeUtil.flora,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountOrStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          FormatterUtil.currency(record.amount ?? 0.0),
          style: PrimaryTextStyle(
            color: ThemeUtil.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          record.transDate ?? '',
          style: PrimaryTextStyle(
            color: const Color(0xff919195),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
