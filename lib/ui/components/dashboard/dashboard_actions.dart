import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_category.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/dashboard/dashboard_button.dart';
import 'package:my_sage_agent/ui/components/dashboard/process_category.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/register_client.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/process_flow.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class DashboardActions extends StatefulWidget {
  const DashboardActions({super.key});

  @override
  State<DashboardActions> createState() => _DashboardActionsState();
}

class _DashboardActionsState extends State<DashboardActions> {
  late Response _response;
  GeneralFlowFormData? _formData;

  List<Map<String, dynamic>> _actions(BuildContext context) => [
    {
      'activity': AppUtil.currentUser.activities![0],
      'onPressed': (ActivityDatum activity) {},
      'color': Color(0x295801B6),
      'icon': 'assets/img/client-deposit.svg',
      'title': 'Deposit for Client',
      'caption': 'Deposit for client',
    },
    {
      'onPressed': () {
        context.push(RegisterClientPage.routeName);
      },
      'color': Color(0x29034D89),
      'icon': 'assets/img/group.svg',
      'title': 'Onboard Client',
      'caption': 'Register new client',
    },
    {
      'activity': AppUtil.currentUser.activities![1],
      'onPressed': (ActivityDatum activity) {},
      'color': Color(0x292719CA),
      'icon': 'assets/img/invest.svg',
      'title': 'Investment',
      'caption': 'Invest for client',
    },
    {
      'activity': AppUtil.currentUser.activities![2],
      'onPressed': (ActivityDatum activity) {},
      'color': Color(0x2919CA74),
      'icon': 'assets/img/loan.svg',
      'title': 'Loan Request',
      'caption': 'Loan request for client',
    },
  ];

  final _category = ValueNotifier<GeneralFlowCategory?>(null);
  bool _loading = false;
  bool _isFormListOpened = false;

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
          isEmpty = _category.value?.forms?.isEmpty ?? true;
        }

        if (state.stillLoading && isEmpty) {
          _category.value = category;
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
        _category.value = category;
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
        if (_formData == null) {
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
          category: _category,
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

  @override
  Widget build(BuildContext context) {
    final actions = _actions(context);
    return BlocListener<RetrieveDataBloc, RetrieveDataState>(
      listener: _handleRetrieveDataState,
      child: SliverPadding(
        padding: const .only(top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Text(
                'What do you want to do?',
                style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 320,
                child: GridView(
                  padding: .zero,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  children: actions.map((item) {
                    return DashboardButton(category: _category, item: item);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
