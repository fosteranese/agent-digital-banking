import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/collection/institution.dart';
import 'package:my_sage_agent/data/models/process_flow/process_flow_form.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/pages/collections/collections.page.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/history.page.dart';
import 'package:my_sage_agent/ui/pages/more/more.page.dart';
import 'package:my_sage_agent/ui/pages/register_client.page.dart';
import 'package:my_sage_agent/ui/pages/team/team_members.page.dart';

final class ProcessFlowUtil {
  static String id = '';
  static late ActivityDatum activityDatum;

  static void loadActivityCategories({
    required ActivityDatum activityDatum,
    required bool skipSavedData,
    required String currentId,
    required ActivityDatum currentActivityDatum,
  }) {
    var action = '';
    ProcessFlowUtil.id = currentId;
    ProcessFlowUtil.activityDatum = currentActivityDatum;

    final context = MyApp.navigatorKey.currentContext!;
    // if (widget.payment != null) {
    //   context.read<RetrieveDataBloc>().add(
    //     RetrievePaymentCategories(
    //       categoryId: widget.payment?.catId ?? '',
    //       skipSavedData: skipSavedData,
    //       id: id,
    //       action: widget.payment?.catId,
    //     ),
    //   );
    //   return;
    // }

    if (activityDatum.activity?.activityId == '4e38a9c6-37b0-4454-b025-a9df5adb3a49') {
      context.push(TeamMembersPage.routeName);
      return;
    }

    switch (activityDatum.activity?.activityType) {
      case ActivityTypesConst.fblOnline:
      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
      case ActivityTypesConst.fblCollect:
      case ActivityTypesConst.fblCollectCategory:
        action = activityDatum.activity?.endpoint ?? activityDatum.activity?.activityId ?? '';
        String activityType = activityDatum.activity!.activityType!;
        if (activityDatum.activity?.activityType == ActivityTypesConst.quickFlowAlt) {
          activityType = ActivityTypesConst.quickFlow;
        }

        context.read<RetrieveDataBloc>().add(
          RetrieveCategories(
            activityId: activityDatum.activity?.activityId ?? '',
            endpoint: activityDatum.activity?.endpoint ?? '',
            id: id,
            action: action,
            skipSavedData: skipSavedData,
            activityType: activityType,
          ),
        );
        break;
    }
  }

  static void loadFormData(
    BuildContext context, {
    required bool skipSavedData,
    required AmDoing amDoing,
    String? receiptId,
    String? collectionId,
    dynamic form,
    required String id,
    required ActivityDatum activity,
  }) {
    String action = '';
    ProcessFlowUtil.id = id;

    switch (form) {
      case ProcessFlowFormModel form:
        action = form.formId!;
        break;
      case Institution form:
        action = form.insId!;
        break;
    }

    if (action == "e59a1a12-6189-427f-820d-835b6f9ab730") {
      context.push(RegisterClientPage.routeName);
      return;
    }

    context.read<RetrieveDataBloc>().add(
      RetrieveForm(
        id: id,
        action: action,
        skipSavedData: skipSavedData,
        form: form,
        activity: activity,
        payeeId: null,
        collectionId: collectionId,
      ),
    );
  }

  static void goBackToPageBeforeProcessFlow() {
    final destinations = [
      '/',
      DashboardPage.routeName,
      CollectionsPage.routeName,
      HistoryPage.routeName,
      MorePage.routeName,
    ];

    final parentContext = MyApp.navigatorKey.currentContext!;
    var currentPath = GoRouter.of(parentContext).state.path;
    while (!destinations.contains(currentPath)) {
      parentContext.pop();
      currentPath = GoRouter.of(parentContext).state.path;
    }
  }
}
