import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/otp/otp_bloc.dart';
import 'package:my_sage_agent/blocs/payee/payee_bloc.dart';
import 'package:my_sage_agent/blocs/schedule/schedule_bloc.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/process_request.model.dart';
import 'package:my_sage_agent/data/models/transaction_auth.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/form/multiple_input_plus.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/authentication.util.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class ProcessFormController {
  ProcessFormController({required this.context, required this.formData, required this.amDoing, required this.controllers, required this.loader, required this.id, required this.activity});

  final BuildContext context;
  final GeneralFlowFormData formData;
  final AmDoing amDoing;
  final Map<String, (TextEditingController, GeneralFlowFieldsDatum)> controllers;
  final Loader loader;
  final String id;
  final ActivityDatum activity;

  /// Called when the user taps submit
  void submit({String? scheduleType, String? scheduleDate}) {
    final payload = FormMultipleInputPlus.getFormData(controllers: controllers, preGeneralFieldDatum: formData.fieldsDatum);

    if (payload == null) return;

    if (formData.form!.requireVerification != 1 && amDoing == AmDoing.createSchedule) {
      if ((scheduleType ?? '').isEmpty) {
        MessageUtil.displayErrorDialog(context, message: 'Schedule is required');
        return;
      }
      if ((scheduleDate ?? '').isEmpty) {
        MessageUtil.displayErrorDialog(context, message: 'Start Date is required');
        return;
      }
    }

    if (formData.form!.requireVerification == 1) {
      context.read<GeneralFlowBloc>().add(VerifyRequest(routeName: id, formData: formData, payload: payload, activityType: activity.activity!.activityType!));
      return;
    }

    AuthenticationUtil.start(
      authModes: formData.authMode ?? [],
      payload: payload,
      onResendShortCode: () => context.read<OtpBloc>().add(ResendOtp(uid: id, formId: formData.form!.formId!)),
      complete: ({String? otp, required Map<String, dynamic> payload, String? pin, String? secretAnswer}) {
        final request = ProcessRequestModel(
          activityId: activity.activity?.activityId ?? '',
          formId: formData.form?.formId ?? '',
          paymentMode: payload['SourceAccount'] ?? '',
          auth: TransactionAuth(otp: otp, pin: pin, secretAnswer: secretAnswer),
        );

        switch (amDoing) {
          case AmDoing.addPayee:
            context.read<PayeeBloc>().add(AddPayee(routeName: id, payment: request, payload: payload));
            break;

          case AmDoing.createSchedule:
            context.read<ScheduleBloc>().add(AddSchedule(routeName: id, request: request, payload: payload, schedulePayload: {'ExecutionType': scheduleType, 'NextExecutionDate': scheduleDate}));
            break;

          default:
            context.read<GeneralFlowBloc>().add(ProcessRequest(routeName: id, activityType: formData.form?.activityType ?? '', request: request, payload: payload));
        }
      },
    );
  }
}
