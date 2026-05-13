import 'package:flutter/material.dart';
import 'package:my_sage_agent/ui/pages/collections/agent_collections.page.dart';
import 'package:my_sage_agent/ui/pages/collections/supervisor_collections.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key, this.showBackBtn = false});
  static const routeName = '/collections';
  final bool showBackBtn;

  @override
  Widget build(BuildContext context) {
    if (AppUtil.currentUser?.userType == 'SUPERVISOR') {
      return SupervisorCollectionsPage(showBackBtn: showBackBtn);
    }

    return AgentCollectionsPage(showBackBtn: showBackBtn);
  }
}
