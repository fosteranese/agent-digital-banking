import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/collection/institution.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/schedule/schedules.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';

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
    Payee? payee,
    String? receiptId,
    dynamic form,
    required String id,

    required ActivityDatum activity,
  }) {
    String action = '';
    ProcessFlowUtil.id = id;

    if (amDoing == AmDoing.createScheduleFromPayee) {
      action = (payee != null) ? 'p-${payee.payeeId}' : 'r-$receiptId';

      context.read<RetrieveDataBloc>().add(
        RetrieveScheduleForm(
          id: id,
          action: action,
          skipSavedData: skipSavedData,
          receiptId: receiptId,
          payeeId: payee?.payeeId,
        ),
      );
      return;
    }

    switch (form) {
      case GeneralFlowForm form:
        action = form.formId!;
        break;
      case Institution form:
        action = form.insId!;
        break;
    }
    context.read<RetrieveDataBloc>().add(
      RetrieveForm(
        id: id,
        action: action,
        skipSavedData: skipSavedData,
        form: form,
        activity: activity,
        payeeId: payee?.payeeId,
      ),
    );
  }
}
