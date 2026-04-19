import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/data/models/agent_collection_model.dart';
import 'package:my_sage_agent/ui/pages/collections/collections_details.page.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionItem extends StatelessWidget {
  final AgentCollectionModel record;
  final VoidCallback? onTap;

  const CollectionItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            context.push(CollectionsDetailsPage.routeName, extra: record);
          },
      enableFeedback: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: .center,
              margin: .only(right: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _status['bg'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_status['icon'], color: _status['color']),
            ),
            _buildDetails(),
            _buildAmountOrStatus(),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> get _status {
    switch (record.status) {
      case 1:
        return {
          'icon': Icons.done_all_outlined,
          'color': ThemeUtil.primaryColor,
          'bg': ThemeUtil.primaryColor.withAlpha(50),
        };
      case 0:
      case 2:
      case 100:
        return {
          'icon': Icons.error_outline_outlined,
          'color': ThemeUtil.danger,
          'bg': ThemeUtil.danger.withAlpha(50),
        };
      case 3:
      case 5:
        return {
          'icon': Icons.timelapse_outlined,
          'color': ThemeUtil.secondaryColor,
          'bg': ThemeUtil.secondaryColor.withAlpha(50),
        };
      default:
        return {
          'icon': Icons.done_all_outlined,
          'color': ThemeUtil.black,
          'bg': ThemeUtil.black.withAlpha(50),
        };
    }
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
