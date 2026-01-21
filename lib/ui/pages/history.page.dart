import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/history/activity.dart';
import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/activity_search_box.dart';
import 'package:my_sage_agent/ui/components/history/history_filter_sheet.dart';
import 'package:my_sage_agent/ui/components/history/history_list_item.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, this.showBackBtn = false});
  static const routeName = '/history';
  final bool showBackBtn;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _filterBy = ValueNotifier<Activity?>(null);
  final _controller = TextEditingController();
  HistoryResponse? _sourceList;
  final _list = ValueNotifier<List<RequestResponse>>([]);
  final _fToast = FToast();
  final scrollController = ScrollController();

  final _dateFrom = TextEditingController();
  final _dateTo = TextEditingController();

  @override
  void initState() {
    _sourceList = context.read<RetrieveDataBloc>().data['RetrieveActivitiesEvent'];
    _list.value = _sourceList?.request ?? [];

    _fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      onBackPressed: () {
        context.replace(DashboardPage.routeName);
      },
      scrollController: scrollController,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<RetrieveDataBloc>().add(
          RetrieveActivitiesEvent(
            id: Uuid().v4(),
            action: 'RetrieveActivitiesEvent',
            skipSavedData: true,
            activity: _filterBy.value,
            dateFrom: _dateFrom.text.trim(),
            dateTo: _dateTo.text.trim(),
          ),
        );
      },
      title: 'Activities',
      backIcon: IconButton(
        style: IconButton.styleFrom(
          fixedSize: const Size(35, 35),
          backgroundColor: const Color(0x91F7C15A),
        ),
        onPressed: () {
          if (widget.showBackBtn) {
            context.pop();
          } else {
            context.replace(DashboardPage.routeName);
          }
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      showBackBtn: true,
      slivers: [
        ValueListenableBuilder(
          valueListenable: _filterBy,
          builder: (context, filter, child) {
            return SliverPersistentHeader(
              pinned: true,
              delegate: MyHeaderDelegate(
                maxHeight: 120,
                minHeight: 84,
                builder: (context, shrinkOffset, overlapsContent) {
                  return ActivitySearchBox(
                    filterBy: _filterBy,
                    controller: _controller,
                    onSearch: (value) {
                      _search(value, _sourceList?.request ?? []);
                    },
                    onFilter: _onShowFilterDialog,
                  );
                },
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: _list,
          builder: (context, list, child) {
            return BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
              listener: (context, state) => _handleBlocListener(state),
              buildWhen: (previous, current) => current.event is RetrieveActivitiesEvent,
              builder: (context, state) {
                if (list.isEmpty && state is RetrievingData) {
                  return const HistoryShimmerList();
                }

                if (list.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverList.separated(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      final record = list[index];
                      return HistoryListItem(record: record, onTap: null);
                    },
                    separatorBuilder: (_, _) =>
                        Divider(thickness: 1, color: ThemeUtil.headerBackground, height: 0),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _handleBlocListener(RetrieveDataState state) {
    if (state.event is! RetrieveActivitiesEvent) {
      return;
    }

    if (state is DataRetrieved && state.stillLoading) {
      _fToast.showToast(child: const Toaster('Loading'), toastDuration: const Duration(hours: 1));
      return;
    }

    if (state is DataRetrieved) {
      _sourceList = state.data ?? [];

      _search('', _sourceList?.request ?? []);
      _fToast.removeCustomToast();
      MainLayout.stopRefresh(context);
      return;
    }

    if (state is RetrieveDataError) {
      _fToast.removeCustomToast();
      MainLayout.stopRefresh(context);
      return;
    }
  }

  void _search(String value, List<RequestResponse> requests) {
    final search = value.trim().toLowerCase();
    _list.value = requests.where((e) {
      return (e.formName?.toLowerCase().contains(search) ?? false) ||
          (e.activityName?.toLowerCase().contains(search) ?? false);
    }).toList();
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        alignment: .center,
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              SvgPicture.asset('assets/img/empty.svg', width: 100),
              Text(
                'No collections found',
                textAlign: .center,
                style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 18, fontWeight: .bold),
              ),
              Text(
                '${_filterBy.value?.activityName} Collections you\'ve made will appear here.',
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(
                  color: ThemeUtil.flat,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _onShowFilterDialog() {
    if (_sourceList == null) {
      MessageUtil.displayErrorDialog(
        context,
        message: 'There are currently no activities to filter',
      );
      return;
    }

    showModalBottomSheet(
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => HistoryFilterSheet(
        sourceList: _sourceList!,
        filterBy: _filterBy,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        onFilterSelected: (filter, dateFrom, dateTo) {
          if (_filterBy.value != filter) {
            // _sourceList = null;
            _list.value = [];
          }

          _filterBy.value = filter;
          context.read<RetrieveDataBloc>().add(
            RetrieveActivitiesEvent(
              id: Uuid().v4(),
              action: 'RetrieveActivitiesEvent',
              skipSavedData: true,
              activity: filter,
              dateFrom: dateFrom,
              dateTo: dateTo,
            ),
          );
        },
        onClearFilter: () {
          _filterBy.value = null;
          _dateFrom.text = '';
          _dateTo.text = '';
          context.read<RetrieveDataBloc>().add(
            RetrieveActivitiesEvent(
              id: Uuid().v4(),
              action: 'RetrieveActivitiesEvent',
              skipSavedData: true,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    _filterBy.dispose();
    _controller.dispose();
    _dateFrom.dispose();
    _dateTo.dispose();
    _list.dispose();
    _fToast.removeQueuedCustomToasts();
    _fToast.removeCustomToast();
    super.dispose();
  }
}
