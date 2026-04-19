import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/dashboard/process_category.dart';
import 'package:my_sage_agent/ui/pages/dashboard/supervisor.dashboard.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/process_flow.util.dart';

import 'package:my_sage_agent/blocs/collection/collection_bloc.dart';
import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/utils/service.util.dart';
import 'package:my_sage_agent/ui/components/session_tracker.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/dashboard/agent.dashboard.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const routeName = '/dashboard';
  static final category = ValueNotifier<GeneralFlowCategory?>(null);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _loading = false;
  bool _isFormListOpened = false;
  late Response _response;
  GeneralFlowFormData? _formData;

  @override
  Widget build(BuildContext context) {
    return SessionTimeout(
      child: MultiBlocListener(
        listeners: [
          BlocListener<PaymentsBloc, PaymentsState>(
            listener: (context, state) => ServiceUtil.paymentsListener(
              context: context,
              state: state,
              routeName: DashboardPage.routeName,
              amDoing: AmDoing.transaction,
            ),
          ),
          BlocListener<GeneralFlowBloc, GeneralFlowState>(
            listener: (context, state) {
              ServiceUtil.generalFlowListener(
                context: context,
                state: state,
                routeName: DashboardPage.routeName,
                amDoing: AmDoing.transaction,
              );
            },
          ),
          BlocListener<RetrieveDataBloc, RetrieveDataState>(listener: _handleRetrieveDataState),
        ],
        child: Builder(
          builder: (context) {
            if (AppUtil.currentUser!.userType?.name != 'SUPERVISOR') {
              return const SupervisorDashboard();
            }
            return const AgentDashboard();
          },
        ),
      ),
    );
  }

  void _startLoading() {
    _loading = true;
    MessageUtil.displayLoading(context);
    return;
  }

  void _stopLoading() {
    if (_loading) {
      _loading = false;
      MessageUtil.stopLoading(context);
    }
  }

  void _openFormList() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      useSafeArea: true,
      builder: (context) {
        return ProcessFlowCategory(
          category: DashboardPage.category,
          onClose: () {
            _isFormListOpened = false;
            _formData = null;
          },
          response: _response,
          amDoing: AmDoing.transaction,
        );
      },
    );
  }

  void _handleRetrieveDataState(BuildContext context, RetrieveDataState state) {
    if (state.id != ProcessFlowUtil.id) {
      return;
    }

    if (state is RetrievingData) {
      _startLoading();
      return;
    }

    if (state is DataRetrieved) {
      _response = state.data!;
      if (_response.data is GeneralFlowCategory) {
        final GeneralFlowCategory category = _response.data;
        var isEmpty = category.forms?.isEmpty ?? true;
        if (isEmpty) {
          isEmpty = DashboardPage.category.value?.forms?.isEmpty ?? true;
        }

        if (state.stillLoading && isEmpty) {
          DashboardPage.category.value = category;
          _startLoading();
          return;
        } else if (isEmpty) {
          _stopLoading();
          MessageUtil.displayErrorDialog(
            context,
            title: 'Currently Unavailable',
            message: 'Sorry! this feature is currently unavailable.',
          );

          return;
        }

        _stopLoading();
        DashboardPage.category.value = category;
        if (!_isFormListOpened) {
          _isFormListOpened = true;
          _openFormList();
        }
        return;
      } else if (_response.data is GeneralFlowFormData) {
        final GeneralFlowFormData formData = _response.data;
        var isEmpty = formData.fieldsDatum?.isEmpty ?? true;
        if (isEmpty) {
          isEmpty = _formData?.fieldsDatum?.isEmpty ?? true;
        }

        if (state.stillLoading && isEmpty) {
          _formData = formData;
          _startLoading();
          return;
        } else if (isEmpty) {
          _stopLoading();
          MessageUtil.displayErrorDialog(
            context,
            title: 'Currently Unavailable',
            message: 'Sorry! this Service is currently unavailable.',
          );

          return;
        }

        _stopLoading();
        if (_formData == null || (state.event?.skipSavedData ?? false)) {
          context.push(
            ProcessFormPage.routeName,
            extra: ProcessFormPage(
              activity: ProcessFlowUtil.activityDatum,
              amDoing: AmDoing.transaction,
              formData: formData,
            ),
          );
        }
        _formData = formData;
        return;
      }
    }

    if (state is RetrieveDataError) {
      _stopLoading();
      MessageUtil.displayErrorDialog(context, message: state.error.message);
      return;
    }

    _stopLoading();
  }
}
