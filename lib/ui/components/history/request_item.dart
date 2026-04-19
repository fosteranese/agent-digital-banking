import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RequestItem extends StatelessWidget {
  final RequestResponse record;
  final VoidCallback? onTap;

  const RequestItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const .symmetric(horizontal: 0),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: ThemeUtil.iconBg,
        child: Icon(Icons.sync, color: Colors.black),
      ),
      title: Text(
        record.customerName ?? 'John Doe',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ThemeUtil.black),
      ),
      subtitle: Text(
        'Agent Code: DB01236',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: PrimaryTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ThemeUtil.subtitleGrey,
        ),
      ),
      trailing: Icon(Icons.navigate_next_outlined, color: ThemeUtil.black),
    );
  }
}
