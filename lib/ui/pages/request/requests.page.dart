import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/reversal_request_model/reversal_request_model.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/headers/request_header.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/history/request_filter_sheet.dart';
import 'package:my_sage_agent/ui/components/history/reversal_item.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/request/reversal_details.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});
  static const routeName = '/requests';

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final _filterBy = ValueNotifier<String?>('');
  final _controller = TextEditingController();
  List<ReversalRequestModel>? _sourceList;
  final _list = ValueNotifier<List<ReversalRequestModel>>([]);
  final _fToast = FToast();
  final scrollController = ScrollController();

  final _dateFrom = TextEditingController();
  final _dateTo = TextEditingController();

  @override
  void initState() {
    _load(false);
    _sourceList = context.read<RetrieveDataBloc>().data['RetrieveSupervisorReversalsEvent'];
    _list.value = _sourceList ?? [];

    _fToast.init(context);
    super.initState();
  }

  void _load(bool skipSavedData) {
    DateTime? startDate;
    var dateFrom = _dateFrom.text.trim();
    if (dateFrom.isNotEmpty) {
      startDate = DateFormat("dd MMM yyyy").parse(dateFrom);
    }

    DateTime? endDate;
    var dateTo = _dateTo.text.trim();
    if (dateTo.isNotEmpty) {
      endDate = DateFormat("dd MMM yyyy").parse(dateTo);
    }

    context.read<RetrieveDataBloc>().add(
      RetrieveSupervisorReversalsEvent(
        id: Uuid().v4(),
        action: 'RetrieveSupervisorReversalsEvent',
        skipSavedData: skipSavedData,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showBackBtn: true,
      backgroundColor: Colors.white,
      title: 'Requests',
      onRefresh: () async {
        _load(true);
      },
      slivers: [
        BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
          builder: (context, state) {
            // if (_list.isEmpty) {
            //   return SliverToBoxAdapter(child: SizedBox.shrink());
            // }

            return SliverPersistentHeader(
              pinned: true,
              delegate: MyHeaderDelegate(
                maxHeight: 120,
                minHeight: 80,
                builder: (context, shrinkOffset, overlapsContent) {
                  return RequestsSearchBox(
                    filterBy: _filterBy,
                    controller: TextEditingController(),
                    onSearch: (value) {},
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
              buildWhen: (previous, current) => current.event is RetrieveSupervisorReversalsEvent,
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
                      return ReversalItem(
                        record: record,
                        onTap: () {
                          context.push(ReversalDetailsPage.routeName, extra: record);
                        },
                      );
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
    if (state.event is! RetrieveSupervisorReversalsEvent) {
      return;
    }

    if (state is DataRetrieved && state.stillLoading) {
      _fToast.showToast(
        child: const Toaster('Loading ...'),
        toastDuration: const Duration(hours: 5),
      );
      return;
    }

    if (state is DataRetrieved) {
      _sourceList = state.data ?? [];

      _search('', _sourceList ?? []);
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

  void _search(String value, List<ReversalRequestModel> requests) {
    final search = value.trim().toLowerCase();
    if (search.isEmpty) {
      _list.value = requests;
      return;
    }

    final list = requests.where((e) {
      return (e.collection?.agentName?.toLowerCase().contains(search) ?? false) ||
          (e.collection?.customerName?.toLowerCase().contains(search) ?? false);
    }).toList();

    _list.value = list;
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
                'No requests found',
                textAlign: .center,
                style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 18, fontWeight: .bold),
              ),
              Text(
                'No request matches the search phrase ${_filterBy.value}.',
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
        message: 'There are currently no reversals to filter',
      );
      return;
    }

    showModalBottomSheet(
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => ReversalRequestFilterSheet(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        onFilterSelected: (dateFrom, dateTo) {
          _list.value = [];

          // _filterBy.value = '';
          _load(false);
        },
        onClearFilter: () {
          _filterBy.value = null;
          _dateFrom.text = '';
          _dateTo.text = '';
          _load(false);
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
