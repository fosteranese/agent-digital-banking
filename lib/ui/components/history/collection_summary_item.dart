import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionSummaryItem extends StatelessWidget {
  final double amount;
  final String title;
  final String icon;
  final VoidCallback? onTap;

  const CollectionSummaryItem({
    super.key,
    required this.amount,
    required this.icon,
    required this.title,
    this.onTap,
  });

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
        child: SvgPicture.asset(
          icon,
          width: 20,
          colorFilter: ColorFilter.mode(ThemeUtil.black, BlendMode.srcIn),
        ),
      ),

      title: Text(
        title,
        style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
      ),
      subtitle: Text(
        'GHS ${FormatterUtil.currency(amount)}',
        style: PrimaryTextStyle(fontSize: 16, fontWeight: .w600, color: ThemeUtil.black),
      ),

      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xffC4C4C4)),
    );
  }
}
