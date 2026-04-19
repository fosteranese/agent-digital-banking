import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/reversal_model/reversal_model.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ReversalItem extends StatelessWidget {
  final ReversalModel record;
  final VoidCallback? onTap;

  const ReversalItem({super.key, required this.record, this.onTap});

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
        backgroundColor: ThemeUtil.iconBg,
        child: Icon(Icons.sync_outlined, size: 20, color: ThemeUtil.black),
      ),

      title: Text(
        'Reversal Transaction',
        style: PrimaryTextStyle(fontSize: 16, fontWeight: .w600, color: ThemeUtil.black),
      ),
      subtitle: Text(
        'Agent - ${record.agentName ?? 'N/A'}',
        style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
      ),

      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xffC4C4C4)),
    );
  }
}
