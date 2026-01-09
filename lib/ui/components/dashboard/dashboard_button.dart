import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/utils/process_flow.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardButton extends StatelessWidget {
  const DashboardButton({super.key, required this.item, required this.category});

  final Map<String, dynamic> item;
  final ValueNotifier<GeneralFlowCategory?> category;

  void _onTap({required ActivityDatum activityDatum, required bool skipSavedData}) {
    category.value = null;
    ProcessFlowUtil.activityDatum = activityDatum;
    ProcessFlowUtil.loadActivityCategories(
      activityDatum: activityDatum,
      skipSavedData: skipSavedData,
      currentId: Uuid().v4(),
      currentActivityDatum: activityDatum,
    );
  }

  @override
  Widget build(BuildContext context) {
    final action = item['activity'] as ActivityDatum?;
    final color = int.parse(action?.activity?.customCss ?? '0x29034D89');
    return InkWell(
      onTap: () {
        final onPressed = item['onPressed'];

        if (action != null) {
          _onTap(activityDatum: action, skipSavedData: false);
          return;
        }

        onPressed();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: item['color'] ?? Color(color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 19,
              child: SvgPicture.asset(item['icon']),
            ),
            Spacer(),
            Text(
              action?.activity?.activityName ?? item['title'],
              maxLines: 1,
              style: PrimaryTextStyle(fontSize: 14, fontWeight: .w700, color: ThemeUtil.black),
            ),
            Text(
              action?.activity?.description ?? item['caption'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PrimaryTextStyle(fontSize: 13, fontWeight: .w600, color: ThemeUtil.flat),
            ),
          ],
        ),
      ),
    );
  }
}
