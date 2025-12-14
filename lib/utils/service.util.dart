import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/collection/collection_bloc.dart';
import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/payee/payees_response.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/data/models/user_response/recent_activity.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/qrcode.util.dart';

class ServiceUtil {
  static final _loader = Loader();
  static String activityType = '';

  static Future<void> paymentsListener({
    required BuildContext context,
    required PaymentsState state,
    required String routeName,
    required AmDoing amDoing,
  }) async {
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

  static void generalFlowListener({
    required BuildContext context,
    required GeneralFlowState state,
    required String routeName,
    String categoryPageRouteName = '',
    String formVerificationPageRouteName = '',
    String formPageRouteName = '',
    required AmDoing amDoing,
  }) {
    if (state is RetrievingGeneralFlowCategories && state.routeName == routeName) {
      _loader.start('Loading');
      return;
    }

    if (state is GeneralFlowCategoriesRetrieved && state.routeName == routeName) {
      context.pop();
      context.push(
        categoryPageRouteName,
        extra: {
          'fblOnlineCategory': state.fblOnlineCategories,
          'activityType': state.activityType,
          'amDoing': amDoing,
          'endpoint': state.endpoint,
        },
      );

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
          context.push(
            formVerificationPageRouteName,
            extra: {
              'formData': state.fblOnlineFormData,
              'activityType': state.activityType,
              'amDoing': amDoing,
            },
          );
        } else {
          context.push(
            formPageRouteName,
            extra: {
              'formData': state.fblOnlineFormData,
              'activityType': state.activityType,
              'amDoing': amDoing,
            },
          );
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

      context.push(
        '',
        extra: {
          'enquiry': state.result,
          'activityType': state.activityType,
          'amDoing': amDoing,
          'endpoint': state.endpoint,
          'formId': state.formId,
          'hashValue': state.hashValue,
        },
      );

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

  static void onActionPressed({
    required BuildContext context,
    required ActivityDatum action,
    required String routeName,
    String? id,
  }) {
    logger.i("${action.activity?.activityName} => ${action.activity?.activityId}");

    switch (action.activity?.activityType) {
      case ActivityTypesConst.fblCollect:
        activityType = ActivityTypesConst.fblCollect;
        context.read<PaymentsBloc>().add(
          RetrievePayments(activityId: action.activity?.activityId ?? '', routeName: routeName),
        );
        break;
      case ActivityTypesConst.fblCollectCategory:
        context.read<PaymentsBloc>().add(
          RetrievePaymentCategoriesWithEndpoint(
            endpoint: action.activity?.endpoint ?? '',
            routeName: routeName,
            activityId: action.activity?.activityId ?? '',
          ),
        );
        break;
      case ActivityTypesConst.fblOnline:
        activityType = ActivityTypesConst.fblOnline;
        context.read<GeneralFlowBloc>().add(
          RetrieveGeneralFlowCategories(
            activityId: action.activity?.activityId ?? '',
            endpoint: action.activity?.endpoint ?? '',
            routeName: id ?? routeName,
            activityType: ActivityTypesConst.fblOnline,
          ),
        );
        break;
      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
        activityType = ActivityTypesConst.quickFlow;
        context.read<GeneralFlowBloc>().add(
          RetrieveGeneralFlowCategories(
            activityId: action.activity?.activityId ?? '',
            endpoint: action.activity?.endpoint ?? '',
            routeName: routeName,
            activityType: ActivityTypesConst.quickFlow,
          ),
        );
        break;
      case ActivityTypesConst.scanToPay:
        QrCodeUtil.openScanToPay(
          scanToPay: AppUtil.currentUser.scanToPay!,
          iconBaseUrl: '${AppUtil.currentUser.imageBaseUrl}${AppUtil.currentUser.imageDirectory}',
        );
        break;
      default:
        MessageUtil.displayErrorDialog(
          context,
          message: '${action.activity?.activityName ?? 'Service'} currently unavailable',
        );
        break;
    }
  }

  static void onFavoritePressed({
    required BuildContext context,
    required RecentActivity activity,
    required String routeName,
    Payees? payee,
  }) {
    logger.i("${activity.activityName} => ${activity.activityId}");

    switch (activity.activityType) {
      case ActivityTypesConst.fblCollect:
      case ActivityTypesConst.fblCollectCategory:
        activityType = ActivityTypesConst.fblCollect;
        context.read<PaymentsBloc>().add(
          RetrieveCollectionForm(
            activityId: activity.activityId ?? '',
            formId: activity.formId ?? '',
            routeName: '${routeName}fav',
            payeeId: payee?.payeeId,
          ),
        );
        return;

      case ActivityTypesConst.fblOnline:
        activityType = ActivityTypesConst.fblOnline;
        context.read<GeneralFlowBloc>().activityId = activity.activityId ?? '';
        context.read<GeneralFlowBloc>().add(
          RetrieveGeneralFlowFormData(
            routeName: '${routeName}fav',
            activityType: ActivityTypesConst.fblOnline,
            formId: activity.formId ?? '',
            payeeId: payee?.payeeId,
          ),
        );
        return;

      case ActivityTypesConst.quickFlow:
      case ActivityTypesConst.quickFlowAlt:
        activityType = ActivityTypesConst.quickFlow;
        context.read<GeneralFlowBloc>().activityId = activity.activityId ?? '';
        context.read<GeneralFlowBloc>().add(
          RetrieveGeneralFlowFormData(
            routeName: '${routeName}fav',
            activityType: ActivityTypesConst.quickFlow,
            formId: activity.formId ?? '',
            payeeId: payee?.payeeId,
          ),
        );
        return;

      default:
        MessageUtil.displayErrorDialog(
          context,
          message: '${activity.activityName ?? 'Service'} currently unavailable',
        );
        break;
    }
  }

  static List<BlocListener> onShortcutListeners({
    required String routeName,
    NavigatorState? nav,
    required AmDoing amDoing,
  }) {
    routeName += 'fav';

    return [
      BlocListener<GeneralFlowBloc, GeneralFlowState>(
        listener: (context, state) {
          generalFlowListener(
            context: context,
            routeName: routeName,
            state: state,
            amDoing: amDoing,
          );
        },
      ),
    ];
  }

  static void onActivityPressed({
    required BuildContext context,
    required Activity activity,
    required String routeName,
  }) {
    logger.i("${activity.activityName} => ${activity.activityId}");

    switch (activity.activityType) {
      case ActivityTypesConst.fblOnline:
        activityType = ActivityTypesConst.fblOnline;
        context.read<GeneralFlowBloc>().add(
          RetrieveGeneralFlowCategories(
            activityId: activity.activityId ?? '',
            endpoint: activity.endpoint ?? '',
            routeName: routeName,
            activityType: ActivityTypesConst.fblOnline,
          ),
        );
        break;
      default:
        MessageUtil.displayErrorDialog(
          context,
          message: '${activity.activityName ?? 'Service'} currently unavailable',
        );
        break;
    }
  }

  static void onGeneralFlowFormPressed({
    required BuildContext context,
    required GeneralFlowForm form,
    required String activityType,
    String routeName = '',
  }) {
    switch (form.activityType) {
      case ActivityTypesConst.enquiry:
        context.read<GeneralFlowBloc>().add(
          GeneralFlowEnquiry(form: form, routeName: routeName, activityType: activityType),
        );
        break;
      default:
        context.read<GeneralFlowBloc>().add(
          RetrieveGeneralFlowFormData(
            formId: form.formId ?? '',
            routeName: routeName,
            activityType: activityType,
          ),
        );
        break;
    }
  }
}
