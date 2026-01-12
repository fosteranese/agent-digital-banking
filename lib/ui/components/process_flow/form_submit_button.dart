import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/payee/payee_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/components/process_flow/process_controller.dart';
import 'package:my_sage_agent/ui/pages/collections.page.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/history.page.dart';
import 'package:my_sage_agent/ui/pages/more/more.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/receipt.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({
    super.key,
    required this.id,
    required this.formData,
    required this.amDoing,
    required this.controllers,
    required this.loader,
    required this.scheduleType,
    required this.scheduleDate,
    required this.activity,
  });

  final String id;
  final GeneralFlowFormData formData;
  final AmDoing amDoing;
  final Map<String, (TextEditingController, GeneralFlowFieldsDatum)> controllers;
  final Loader loader;
  final TextEditingController scheduleType;
  final TextEditingController scheduleDate;
  final ActivityDatum activity;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralFlowBloc, GeneralFlowState>(
      listener: (context, state) {
        if ((state as dynamic).routeName != id) {
          return;
        }

        if (state is ProcessingRequest || state is VerifyingRequest) {
          MessageUtil.displayLoading(context);
          return;
        } else {
          MessageUtil.stopLoading(context);
        }

        if (state is RequestProcessed) {
          _showRequestProcessed(context, state);
          return;
        }

        if (state is ProcessRequestError) {
          _showProcessRequestError(context, state);
          return;
        }

        if (state is VerifyRequestError) {
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }
      },
      builder: (context, state) {
        return BlocConsumer<PayeeBloc, PayeeState>(
          listener: (context, state1) {
            if (state1 is AddingPayee) {
              MessageUtil.displayLoading(context);
              return;
            } else {
              MessageUtil.stopLoading(context);
            }

            if (state1 is AddPayeeError && state1.routeName == id) {
              MessageUtil.displayErrorDialog(context, message: state1.result.message);
              return;
            }
          },
          builder: (context, state1) {
            return FormButton(
              loading: state1 is AddingPayee,
              text: _submitText,
              onPressed: () => _confirm(context),
            );
          },
        );
      },
    );
  }

  String get _submitText {
    if (formData.form!.requireVerification != 1 && amDoing == AmDoing.createSchedule) {
      return 'Schedule';
    }

    if (formData.form!.requireVerification != 1 && amDoing == AmDoing.addPayee) {
      return 'Save';
    }

    if (formData.form!.requireVerification == 1) {
      return 'Continue';
    }

    return 'Submit';
  }

  void _confirm(BuildContext context) {
    final controller = ProcessFormController(
      context: context,
      formData: formData,
      amDoing: amDoing,
      id: id,
      controllers: controllers,
      loader: loader,
      activity: activity,
    );

    controller.submit(scheduleType: scheduleType.text, scheduleDate: scheduleDate.text);
  }

  void _showRequestProcessed(BuildContext context, RequestProcessed state) {
    final loader = Loader();
    loader.successTransaction(
      title: 'Success',
      result: state.result,
      onClose: () {
        final destinations = [
          '/',
          DashboardPage.routeName,
          CollectionsPage.routeName,
          HistoryPage.routeName,
          MorePage.routeName,
        ];

        while (!destinations.contains(GoRouter.of(context).state.path)) {
          context.pop();
        }
      },
      onSaveBeneficiary: () {
        context.read<GeneralFlowBloc>().add(
          SaveBeneficiary(routeName: id, payload: state.result.data!),
        );
      },
      onScheduleTransaction: () {
        context.read<GeneralFlowBloc>().add(
          PrepareScheduler(
            routeName: DashboardPage.routeName,
            receiptId: state.result.data!.receiptId,
          ),
        );
      },
      onShowReceipt: () async {
        context.push(
          ReceiptPage.routeName,
          extra: {
            'request': state.result.data,
            'fblLogo': state.result.data?.fblLogo ?? '',
            'imageBaseUrl': state.result.imageBaseUrl,
            'imageDirectory': state.result.imageDirectory,
          },
        );
      },
    );
  }

  void _showProcessRequestError(BuildContext context, ProcessRequestError state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xffFFE0DF),
                child: Icon(Icons.error_outline_outlined, color: Color(0xffF10404)),
              ),
              const SizedBox(height: 15),
              Text(
                'Processing Failed',
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                state.result.message,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: const Color(0xff4F4F4F),
                ),
              ),
              const SizedBox(height: 30),
              if (formData.form?.formId != '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a')
                FormButton(
                  onPressed: () {
                    context.pop();
                    _confirm(context);
                  },
                  text: 'Try Again',
                )
              else
                FormButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: 'Ok',
                ),
              if (formData.form?.formId != '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a')
                const SizedBox(height: 15),
              if (formData.form?.formId != '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a')
                FormOutlineButton(
                  onPressed: () {
                    context.push(
                      ProcessFormPage.routeName,
                      extra: {
                        'form': GeneralFlowForm(
                          activityType: ActivityTypesConst.quickFlow,
                          formName: 'Submit a complaint',
                          categoryId: '0fdc593e-89f2-4950-a491-75c66749bbcc',
                          formId: '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a',
                        ),
                        'amDoing': AmDoing.transaction,
                        'activity': ActivityDatum(
                          activity: Activity(
                            activityId: '0fdc593e-89f2-4950-a491-75c66749bbcc',
                            activityType: ActivityTypesConst.quickFlow,
                            accessType: 'CUSTOMER',
                          ),
                        ),
                      },
                    );
                  },
                  text: 'Submit a Complaint',
                ),
            ],
          ),
        );
      },
    );
  }
}
