import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/icon.dart';
import 'package:my_sage_agent/ui/pages/register_client.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/process_flow.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardButton extends StatelessWidget {
  const DashboardButton({super.key, required this.item, required this.category});

  final ActivityDatum item;
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
    final color = int.parse(item.activity?.customCss ?? '0x29034D89');
    var icon = '${AppUtil.data.imageBaseUrl}${AppUtil.data.imageDirectory}/${item.activity?.icon}';
    return InkWell(
      onTap: () {
        if (item.activity?.activityId != '7b7b9140-cab1-42bf-acbc-347fcc4b4f6c') {
          _onTap(activityDatum: item, skipSavedData: false);
          return;
        }

        context.push(RegisterClientPage.routeName);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Color(color), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 19,
              child: Padding(
                padding: const .all(8),
                child: MyIcon(icon: icon),
              ),
            ),
            Spacer(),
            Text(
              item.activity?.activityName ?? '',
              maxLines: 1,
              style: PrimaryTextStyle(fontSize: 14, fontWeight: .w700, color: ThemeUtil.black),
            ),
            Text(
              item.activity?.description ?? '',
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
