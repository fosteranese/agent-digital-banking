import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/utils/string.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class TeamMemberItem extends StatelessWidget {
  final Agent record;
  final VoidCallback? onTap;

  const TeamMemberItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const .symmetric(horizontal: 0),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: ThemeUtil.iconBg,
        child: Text(
          StringUtil.getInitials(record.fullName!),
          style: const TextStyle(color: ThemeUtil.color3, fontWeight: .w400, fontSize: 14),
        ),
      ),
      title: Text(
        record.fullName ?? 'John Doe',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ThemeUtil.black),
      ),
      subtitle: Text(
        'Agent Code: ${record.agentCode ?? 'N/A'}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: PrimaryTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ThemeUtil.subtitleGrey,
        ),
      ),
      trailing: IconButton.outlined(
        onPressed: () {},
        style: IconButton.styleFrom(
          side: const BorderSide(color: ThemeUtil.fade),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: SvgPicture.asset('assets/img/send-feedback.svg'),
      ),
    );
  }
}
