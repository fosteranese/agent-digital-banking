import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:agent_digital_banking/blocs/collection/collection_bloc.dart';
import 'package:agent_digital_banking/blocs/general_flow/general_flow_bloc.dart';
import 'package:agent_digital_banking/blocs/payee/payee_bloc.dart';
import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form.dart';
import 'package:agent_digital_banking/data/models/payee/payees_response.dart';
import 'package:agent_digital_banking/data/models/user_response/activity.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/data/models/user_response/recent_activity.dart';
import 'package:agent_digital_banking/logger.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/outline_button.dart';
import 'package:agent_digital_banking/ui/components/popover.dart';
import 'package:agent_digital_banking/ui/pages/bulk_payments/bulk_payment_groups.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/process_form.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/ui/pages/recipient/recipient.page.dart';
import 'package:agent_digital_banking/ui/pages/schedules/schedules.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/authentication.util.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/qrcode.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class ServiceUtil {
  static final _loader = Loader();
  static String activityType = '';

  static Future<void> paymentsListener({required BuildContext context, required PaymentsState state, required String routeName, required AmDoing amDoing}) async {
    if (state is RetrievingPayments && state.routeName == routeName) {
      MessageUtil.displayLoading(context);
      return;
    }

    if (state is RetrievePaymentsError && state.routeName == routeName) {
      context.pop();
      MessageUtil.displayErrorDialog(context, message: state.result.message);

      return;
    }
    if (state is RetrievingPayments && state.routeName == routeName) {
      MessageUtil.displayLoading(context);
      return;
    }

    if (state is StopLoadingPayments && state.routeName == routeName) {
      context.pop();
      return;
    }

    if (state is PaymentsRetrieved && state.routeName == routeName) {
      context.pop();

      if (state.payments.data?.isEmpty ?? true) {
        MessageUtil.displayErrorDialog(context, message: 'Currently not available');
      }

      return;
    }

    if (state is RetrievePaymentsError && state.routeName == routeName) {
      context.pop();
      MessageUtil.displayErrorDialog(context, message: state.result.message);
      return;
    }

    if (state is RetrievingPaymentCategories && state.routeName == routeName) {
      MessageUtil.displayLoading(context);
      return;
    }

    if (state is PaymentCategoriesRetrieved && state.routeName == routeName) {
      context.pop();

      if (state.paymentCategories.data?.institution?.isEmpty ?? true) {
        MessageUtil.displayErrorDialog(context, message: 'Currently not available');
      }

      return;
    }

    if (state is RetrievePaymentCategoriesError && state.routeName == routeName) {
      context.pop();
      MessageUtil.displayErrorDialog(context, message: state.result.message);
      return;
    }

    if (state is RetrievingInstitutionForms && state.routeName == routeName) {
      MessageUtil.displayLoading(context);
      return;
    }

    if (state is InstitutionFormsRetrieved && state.routeName == routeName) {
      context.pop();

      if (state.result.data?.institutionData?.formsData?.isEmpty ?? true) {
        MessageUtil.displayErrorDialog(context, message: 'Currently not available');
      }

      return;
    }

    if (state is RetrieveInstitutionFormsError && state.routeName == routeName) {
      _loader.stop();

      Future.delayed(const Duration(seconds: 0), () {
        MessageUtil.displayErrorDialog(context, message: state.result.message);
      });
      return;
    }
  }

  static void generalFlowListener({required BuildContext context, required GeneralFlowState state, required String routeName, String categoryPageRouteName = '', String formVerificationPageRouteName = '', String formPageRouteName = '', required AmDoing amDoing}) {
    if (state is RetrievingGeneralFlowCategories && state.routeName == routeName) {
      _loader.start('Loading');
      return;
    }

    if (state is GeneralFlowCategoriesRetrieved && state.routeName == routeName) {
      context.pop();
      context.push(categoryPageRouteName, extra: {'fblOnlineCategory': state.fblOnlineCategories, 'activityType': state.activityType, 'amDoing': amDoing, 'endpoint': state.endpoint});

      return;
    }

    if (state is RetrieveGeneralFlowCategoriesError && state.routeName == routeName) {
      context.pop();
      MessageUtil.displayErrorDialog(context, message: state.result.message);
      return;
    }

    if (state is RetrievingGeneralFlowFormData && state.routeName == routeName) {
      MessageUtil.displayLoading(context);
      return;
    }

    if (state is GeneralFlowFormDataRetrieved && state.routeName == routeName) {
      context.pop();
      if (state.fblOnlineFormData.data?.fieldsDatum?.isEmpty ?? true) {
        MessageUtil.displayErrorDialog(context, message: 'Currently not available');
      } else {
        if (state.fblOnlineFormData.data?.form?.requireVerification == 1) {
          context.push(formVerificationPageRouteName, extra: {'formData': state.fblOnlineFormData, 'activityType': state.activityType, 'amDoing': amDoing});
        } else {
          context.push(formPageRouteName, extra: {'formData': state.fblOnlineFormData, 'activityType': state.activityType, 'amDoing': amDoing});
        }
      }

      return;
    }

    if (state is RetrieveGeneralFlowFormDataError && state.routeName == routeName) {
      context.pop();
      MessageUtil.displayErrorDialog(context, message: state.result.message);
      return;
    }

    if (state is EnquiringGeneralFlow && state.routeName == routeName) {
      MessageUtil.displayLoading(context);
      return;
    }

    if (state is GeneralFlowEnquired && state.routeName == routeName) {
      context.pop();

      context.push('', extra: {'enquiry': state.result, 'activityType': state.activityType, 'amDoing': amDoing, 'endpoint': state.endpoint, 'formId': state.formId, 'hashValue': state.hashValue});

      return;
    }

    if (state is EnquireGeneralFlowError && state.routeName == routeName) {
      _loader.stop();

      Future.delayed(const Duration(seconds: 0), () {
        MessageUtil.displayErrorDialog(context, message: state.result.message);
      });
      return;
    }
  }

  static void onActionPressed({required BuildContext context, required ActivityDatum action, required String routeName, String? id}) {
    logger.i("${action.activity?.activityName} => ${action.activity?.activityId}");

    switch (action.activity?.activityType) {
      case ActivityTypesConst.fblCollect:
        activityType = ActivityTypesConst.fblCollect;
        context.read<PaymentsBloc>().add(RetrievePayments(activityId: action.activity?.activityId ?? '', routeName: routeName));
        break;
      case ActivityTypesConst.fblCollectCategory:
        context.read<PaymentsBloc>().add(RetrievePaymentCategoriesWithEndpoint(endpoint: action.activity?.endpoint ?? '', routeName: routeName, activityId: action.activity?.activityId ?? ''));
        break;
      case ActivityTypesConst.fblOnline:
        activityType = ActivityTypesConst.fblOnline;
        context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowCategories(activityId: action.activity?.activityId ?? '', endpoint: action.activity?.endpoint ?? '', routeName: id ?? routeName, activityType: ActivityTypesConst.fblOnline));
        break;
      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
        activityType = ActivityTypesConst.quickFlow;
        context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowCategories(activityId: action.activity?.activityId ?? '', endpoint: action.activity?.endpoint ?? '', routeName: routeName, activityType: ActivityTypesConst.quickFlow));
        break;
      case ActivityTypesConst.scanToPay:
        QrCodeUtil.openScanToPay(scanToPay: AppUtil.currentUser.scanToPay!, iconBaseUrl: '${AppUtil.currentUser.imageBaseUrl}${AppUtil.currentUser.imageDirectory}');
        break;
      case ActivityTypesConst.bulkPayment:
        activityType = ActivityTypesConst.bulkPayment;
        context.push(BulkPaymentGroupsPage.routeName, extra: action);
        break;
      case ActivityTypesConst.schedule:
        activityType = ActivityTypesConst.schedule;
        context.push(SchedulesPage.routeName, extra: action);
        break;
      default:
        MessageUtil.displayErrorDialog(context, message: '${action.activity?.activityName ?? 'Service'} currently unavailable');
        break;
    }
  }

  static void onFavoritePressed({required BuildContext context, required RecentActivity activity, required String routeName, Payees? payee}) {
    logger.i("${activity.activityName} => ${activity.activityId}");

    switch (activity.activityType) {
      case ActivityTypesConst.fblCollect:
      case ActivityTypesConst.fblCollectCategory:
        activityType = ActivityTypesConst.fblCollect;
        context.read<PaymentsBloc>().add(RetrieveCollectionForm(activityId: activity.activityId ?? '', formId: activity.formId ?? '', routeName: '${routeName}fav', payeeId: payee?.payeeId));
        return;

      case ActivityTypesConst.fblOnline:
        activityType = ActivityTypesConst.fblOnline;
        context.read<GeneralFlowBloc>().activityId = activity.activityId ?? '';
        context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowFormData(routeName: '${routeName}fav', activityType: ActivityTypesConst.fblOnline, formId: activity.formId ?? '', payeeId: payee?.payeeId));
        return;

      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
        activityType = ActivityTypesConst.quickFlow;
        context.read<GeneralFlowBloc>().activityId = activity.activityId ?? '';
        context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowFormData(routeName: '${routeName}fav', activityType: ActivityTypesConst.quickFlow, formId: activity.formId ?? '', payeeId: payee?.payeeId));
        return;

      default:
        MessageUtil.displayErrorDialog(context, message: '${activity.activityName ?? 'Service'} currently unavailable');
        break;
    }
  }

  static List<BlocListener> onShortcutListeners({required String routeName, NavigatorState? nav, required AmDoing amDoing}) {
    routeName += 'fav';

    return [
      BlocListener<GeneralFlowBloc, GeneralFlowState>(
        listener: (context, state) {
          generalFlowListener(context: context, routeName: routeName, state: state, amDoing: amDoing);
        },
      ),
    ];
  }

  static void onActivityPressed({required BuildContext context, required Activity activity, required String routeName}) {
    logger.i("${activity.activityName} => ${activity.activityId}");

    switch (activity.activityType) {
      case ActivityTypesConst.fblOnline:
        activityType = ActivityTypesConst.fblOnline;
        context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowCategories(activityId: activity.activityId ?? '', endpoint: activity.endpoint ?? '', routeName: routeName, activityType: ActivityTypesConst.fblOnline));
        break;
      default:
        MessageUtil.displayErrorDialog(context, message: '${activity.activityName ?? 'Service'} currently unavailable');
        break;
    }
  }

  static void onGeneralFlowFormPressed({required BuildContext context, required GeneralFlowForm form, required String activityType, String routeName = ''}) {
    switch (form.activityType) {
      case ActivityTypesConst.enquiry:
        context.read<GeneralFlowBloc>().add(GeneralFlowEnquiry(form: form, routeName: routeName, activityType: activityType));
        break;
      default:
        context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowFormData(formId: form.formId ?? '', routeName: routeName, activityType: activityType));
        break;
    }
  }

  static void sendPayeeNow({required BuildContext parentContext, required Payees payee, required String routeName}) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: parentContext,
      builder: (context) {
        return PopOver(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: SvgPicture.asset('assets/img/send-now.svg'),
                  onTap: () {
                    parentContext.pop();

                    AuthenticationUtil.pin(
                      onSuccess: (pin) {
                        PayeesPageState.id = Uuid().v4();
                        parentContext.read<PayeeBloc>().add(SendPayeeNow(routeName: PayeesPageState.id, payee: payee, pin: pin));
                      },
                      allowBiometric: true,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text('Send Again', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next, color: Color(0xff919195)),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/edit.svg'),
                  onTap: () {
                    context.pop();
                    context.push(
                      ProcessFormPage.routeName,
                      extra: {
                        'form': GeneralFlowForm(activityType: payee.activityType, formName: payee.formName, caption: payee.shortTitle, description: payee.title, tooltip: payee.title, formId: payee.formId, requireVerification: 1, allowSchedule: 0, allowBeneficiary: 0, showInFavourite: 0, showReceipt: 0, showInHistory: 0, icon: payee.icon),
                        'amDoing': AmDoing.payeeTransaction,
                        'activity': ActivityDatum(
                          activity: Activity(activityName: payee.activityName, activityId: payee.activityId, activityType: payee.activityType),
                        ),
                        'payee': payee,
                      },
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text('Edit and Send Again', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next, color: Color(0xff919195)),
                ),
                ListTile(
                  leading: Icon(Icons.edit_calendar_outlined, size: 22, color: Color(0xff919195)),
                  onTap: () {
                    context.pop();
                    context.push(
                      ProcessFormPage.routeName,
                      extra: {
                        'form': GeneralFlowForm(activityType: payee.activityType, formName: payee.formName, caption: payee.shortTitle, description: payee.title, tooltip: payee.title, formId: payee.formId, requireVerification: 1, allowSchedule: 0, allowBeneficiary: 0, showInFavourite: 0, showReceipt: 0, showInHistory: 0, icon: payee.icon),
                        'amDoing': AmDoing.createSchedule,
                        'activity': ActivityDatum(
                          activity: Activity(activityName: payee.activityName, activityId: payee.activityId, activityType: payee.activityType),
                        ),
                        'payee': payee,
                      },
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text('Schedule', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next, color: Color(0xff919195)),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/img/delete.svg'),
                  onTap: () {
                    context.pop();
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return PopOver(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Delete Beneficiary',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                const Text(
                                  'Are you sure you want to delete this beneficiary ?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                ),
                                const SizedBox(height: 30),
                                FormButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  text: 'No, Stop',
                                ),
                                const SizedBox(height: 10),
                                FormOutlineButton(
                                  backgroundColor: Colors.red,
                                  textColor: Colors.red,
                                  onPressed: () {
                                    context.pop();
                                    context.read<PayeeBloc>().add(DeletePayee(payee: payee, routeName: PayeesPage.routeName));
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                  text: 'Yes, Delete',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text('Delete beneficiary', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  trailing: const Icon(Icons.navigate_next, color: Color(0xff919195)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
