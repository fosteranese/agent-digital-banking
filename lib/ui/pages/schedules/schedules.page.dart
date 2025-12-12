// schedules_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:my_sage_agent/blocs/app/app_bloc.dart';
import 'package:my_sage_agent/blocs/payee/payee_bloc.dart';
import 'package:my_sage_agent/blocs/schedule/schedule_bloc.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/schedule/schedules.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/search_box.dart';
import 'package:my_sage_agent/ui/components/schedules/no_schedules.dart';
import 'package:my_sage_agent/ui/components/schedules/schedule_list.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/schedules/schedule_details.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/service.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage(this.action, {super.key});
  static const routeName = '/schedules';
  final ActivityDatum action;

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final _controller = TextEditingController();
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  final _loader = Loader();
  final _fToast = FToast();
  final formatter = DateFormat('dd MMM yyyy');

  late final ScheduleBloc _bloc = context.read<ScheduleBloc>();
  late Response<SchedulesData> _sourceList;
  List<Schedules> _list = [];
  bool _moving = false;
  bool _showUpdating = true;
  bool _showSearchBox = false;
  bool? _mainLoading;

  @override
  void initState() {
    super.initState();
    _bloc.add(const RetrieveSchedules(SchedulesPage.routeName));
    _sourceList = _bloc.schedulesData;
    _list = _sourceList.data?.schedules ?? [];
    _fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayeeBloc, PayeeState>(
      builder: (context, _) {
        return MainLayout(
          refreshController: _refreshController,
          onRefresh: _handleRefresh,
          showBackBtn: true,
          title: widget.action.activity?.activityName ?? 'Schedules',
          bottom: _showSearchBox ? SearchBox(controller: _controller, onSearch: (value) => _search(value, _sourceList.data?.schedules ?? [])) : null,
          actions: [
            IconButton(
              style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
              onPressed: () => setState(() {
                _controller.text = '';
                _search(_controller.text, _sourceList.data?.schedules ?? []);
                _showSearchBox = !_showSearchBox;
              }),
              icon: SvgPicture.asset('assets/img/search.svg', width: 20, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            ),
            const SizedBox(width: 10),
          ],
          sliver: MultiBlocListener(
            listeners: ServiceUtil.onShortcutListeners(nav: MyApp.navigatorKey.currentState, routeName: SchedulesPage.routeName, amDoing: AmDoing.createSchedule),
            child: BlocConsumer<ScheduleBloc, ScheduleState>(
              listener: _handleStateChange,
              buildWhen: (p, c) => c is RetrievingSchedules || c is SchedulesRetrieved || c is SchedulesRetrievedSilently,
              builder: (context, state) {
                if (state is RetrievingSchedules) {
                  return const SliverToBoxAdapter();
                  // return const ScheduleListLoading();
                }
                if (_list.isEmpty) {
                  return NoSchedulesView(onCreate: _navigateToCreate);
                }
                return ScheduleList(schedules: _list, formatter: formatter, onTap: _navigateToDetails, location: SchedulesPage.routeName);
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButtonMargin: 20,
          floatingActionButton: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is RetrievingSchedules) {
                return const SizedBox();
              }

              return _buildFAB();
            },
          ),
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    _showUpdating = false;
    _bloc.add(const SilentRetrieveSchedules(SchedulesPage.routeName));
  }

  void _handleStateChange(BuildContext context, ScheduleState state) {
    if (state is RetrievingSchedules) {
      _mainLoading = true;
      MessageUtil.displayLoading(context);
    } else if (_mainLoading == true) {
      _mainLoading = false;
      context.pop();
    }

    if (state is SilentRetrievingSchedules && _showUpdating) {
      _fToast.showToast(child: const Toaster('Updating'), toastDuration: const Duration(hours: 1));
    } else if (state is SchedulesRetrieved || state is SchedulesRetrievedSilently) {
      if (state is SchedulesRetrieved) {
        _sourceList = state.result;
      }
      if (state is SchedulesRetrievedSilently) {
        _sourceList = state.result;
      }

      _search('', _sourceList.data?.schedules ?? [], shouldSetState: false);
      _fToast.removeCustomToast();
      MainLayout.stopRefresh(context);
    } else if (state is RetrieveSchedulesError || state is SilentRetrieveSchedulesError) {
      _handleErrorState();
    } else if (state is ScheduleAdded) {
      final destinations = ['/', SchedulesPage.routeName];

      while (!destinations.contains(GoRouter.of(context).state.path)) {
        context.pop();
      }
      _showScheduleAdded(context, state);
    } else if (state is AddScheduleError) {
      MessageUtil.displayErrorDialog(context, message: state.result.message);
    } else if (state is DeletingSchedule) {
      MessageUtil.displayLoading(context, message: 'Deleting...');
    } else if (state is ScheduleDeleted) {
      context.pop();
      _bloc.add(const RetrieveSchedules(SchedulesPage.routeName));

      if (state.routeName != SchedulesPage.routeName) {
        context.pop();
      }

      MessageUtil.displaySuccessDialog(context, message: state.result.message);
    } else if (state is DeleteScheduleError) {
      context.pop();
      MessageUtil.displayErrorDialog(context, message: state.result.message);
    }
  }

  void _handleErrorState() {
    _fToast.removeCustomToast();
    MainLayout.stopRefresh(context);
    if (_moving) {
      _moving = false;
      _loader.stop();

      final destinations = ['/', DashboardPage.routeName, SchedulesPage.routeName];

      while (!destinations.contains(GoRouter.of(context).state.path)) {
        context.pop();
      }
    }
  }

  void _search(String value, List<Schedules> requests, {bool shouldSetState = true}) {
    final search = value.trim().toLowerCase();
    _list = requests.where((e) => e.payee?.formName?.toLowerCase().contains(search) ?? false).toList();
    if (shouldSetState) setState(() {});
  }

  void _navigateToCreate() {
    context.read<AppBloc>().add(SetScheduleStatusEvent(true));
    context.push(QuickActionsPage.routeName, extra: AmDoing.createSchedule);
  }

  void _navigateToDetails(Schedules schedule) {
    context.push(ScheduleDetailsPage.routeName, extra: schedule);
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _navigateToCreate,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showScheduleAdded(BuildContext context, ScheduleAdded state) {
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
                backgroundColor: Color(0xffCEFFCE),
                child: Icon(Icons.task_alt_outlined, color: Color(0xff067335)),
              ),
              const SizedBox(height: 15),
              Text(
                'Successful',
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                state.result.message,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff4F4F4F)),
              ),
              const SizedBox(height: 30),
              FormButton(
                onPressed: () {
                  context.pop();
                },
                text: 'Ok',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fToast.removeQueuedCustomToasts();
    _fToast.removeCustomToast();
    _controller.dispose();
    super.dispose();
  }
}
