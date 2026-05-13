import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/data/models/supervisor_collection_summary_model/collection_summary.dart';
import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/ui/pages/team/agent_details.page.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorCollectionSummaryItem extends StatelessWidget {
  final CollectionSummary record;
  final VoidCallback? onTap;

  const SupervisorCollectionSummaryItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          AgentDetailsPage.routeName,
          extra: Agent(agentCode: record.agentCode, fullName: record.agentName),
        );
      },
      enableFeedback: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
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
            record.agentName ?? 'John Doe',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            record.agentCode?.toString() ?? '',
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
          FormatterUtil.currency(record.totalCollections ?? 0.0),
          style: PrimaryTextStyle(
            color: ThemeUtil.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          record.startDate ?? '',
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
