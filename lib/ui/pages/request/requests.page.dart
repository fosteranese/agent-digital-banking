import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/ui/components/headers/request_header.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/history/request_item.dart';
import 'package:my_sage_agent/ui/components/history/team_member_item.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/request/request_details.page.dart';
import 'package:my_sage_agent/ui/pages/team/agent_details.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});
  static const routeName = '/requests';

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final _filterBy = ValueNotifier('');
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
      showBackBtn: true,
      backgroundColor: Colors.white,
      title: 'Requests',
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
                    onFilter: () {},
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
                      return RequestItem(
                        record: record,
                        onTap: () {
                          context.push(RequestDetailsPage.routeName, extra: record);
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
    if (state.event is! RetrieveActivitiesEvent) {
      return;
    }

    if (state is DataRetrieved && state.stillLoading) {
      _fToast.showToast(
        child: const Toaster('Loading members'),
        toastDuration: const Duration(hours: 1),
      );
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
                'No team member matches the search phrase ${_filterBy.value}.',
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
