import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/agent_reversal_request_model/agent_reversal_request_model.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorAgentReversalItem extends StatelessWidget {
  final AgentReversalRequestModel record;
  final VoidCallback? onTap;

  const SupervisorAgentReversalItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:
          onTap ??
          () {
            // context.push(CollectionsDetailsPage.routeName, extra: record);
          },
      contentPadding: const .symmetric(horizontal: 0),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: _status['bg'],
        child: Icon(_status['icon'], size: 20, color: _status['color']),
      ),

      title: Text(
        '${record.collection?.customerName} (GHS ${FormatterUtil.currency(record.collection?.amount)})',
        style: PrimaryTextStyle(fontSize: 14, fontWeight: .w600, color: ThemeUtil.black),
      ),
      subtitle: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisSize: .min,
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Text(
                '${record.collection?.collectionMode}: ',
                style: PrimaryTextStyle(fontSize: 14, fontWeight: .w600, color: ThemeUtil.flat),
              ),

              Expanded(
                child: Text(
                  record.reason ?? 'No reason provided',
                  style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
                ),
              ),
            ],
          ),
          Text(
            record.requestDate ?? '',
            style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Map<String, dynamic> get _status {
    switch (record.status) {
      case 1:
        return {
          'icon': Icons.published_with_changes_outlined,
          'color': ThemeUtil.primaryColor,
          'bg': ThemeUtil.primaryColor.withAlpha(50),
        };
      case 0:
      case 2:
      case 100:
        return {
          'icon': Icons.cancel_outlined,
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
}
