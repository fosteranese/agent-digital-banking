import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/commission_model.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/commission_search_box.dart';
import 'package:my_sage_agent/ui/components/history/commission_filter_sheet.dart';
import 'package:my_sage_agent/ui/components/history/commission_list_item.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class CommissionsPage extends StatefulWidget {
  const CommissionsPage({super.key, this.showBackBtn = false});
  static const routeName = '/more/commissions';
  final bool showBackBtn;

  @override
  State<CommissionsPage> createState() => _CommissionsPageState();
}

class _CommissionsPageState extends State<CommissionsPage> {
  final _controller = TextEditingController();
  List<CommissionModel>? _sourceList;
  final _list = ValueNotifier<List<CommissionModel>>([]);
  final _fToast = FToast();
  final scrollController = ScrollController();

  final _dateFrom = TextEditingController();
  final _dateTo = TextEditingController();

  @override
  void initState() {
    context.read<RetrieveDataBloc>().add(
      RetrieveCommissionsEvent(
        id: Uuid().v4(),
        action: 'RetrieveCommissionsEvent',
        skipSavedData: false,
      ),
    );
    _sourceList = context.read<RetrieveDataBloc>().data['RetrieveCommissionsEvent'];
    _list.value = _sourceList ?? [];

    _fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      scrollController: scrollController,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<RetrieveDataBloc>().add(
          RetrieveCommissionsEvent(
            id: Uuid().v4(),
            action: 'RetrieveCommissionsEvent',
            skipSavedData: true,
          ),
        );
      },
      title: 'Commissions',
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
        SliverPersistentHeader(
          pinned: true,
          delegate: MyHeaderDelegate(
            maxHeight: 80,
            minHeight: 80,
            builder: (context, shrinkOffset, overlapsContent) {
              return CommissionSearchBox(
                dateFrom: _dateFrom,
                dateTo: _dateTo,
                onFilter: _onShowFilterDialog,
              );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _list,
          builder: (context, list, child) {
            return BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
              listener: (context, state) => _handleBlocListener(state),
              buildWhen: (previous, current) => current.event is RetrieveCommissionsEvent,
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
                      return CommissionListItem(record: record, onTap: null);
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
    if (state.event is! RetrieveCommissionsEvent) {
      return;
    }

    if (state is DataRetrieved && state.stillLoading) {
      _fToast.showToast(
        child: const Toaster('Loading commissions'),
        toastDuration: const Duration(hours: 1),
      );
      return;
    }

    if (state is DataRetrieved) {
      _sourceList = state.data ?? [];
      _list.value = _sourceList!;

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
                'No Commissions found',
                textAlign: .center,
                style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 18, fontWeight: .bold),
              ),
              Text(
                'Commissions you\'ve made will appear here.',
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
    showModalBottomSheet(
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => CommissionFilterSheet(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        onFilterSelected: (dateFrom, dateTo) {
          _list.value = [];

          context.read<RetrieveDataBloc>().add(
            RetrieveCommissionsEvent(
              id: Uuid().v4(),
              action: 'RetrieveCommissionsEvent',
              skipSavedData: true,
              dateFrom: dateFrom,
              dateTo: dateTo,
            ),
          );
        },
        onClearFilter: () {
          _dateFrom.text = '';
          _dateTo.text = '';
          context.read<RetrieveDataBloc>().add(
            RetrieveCommissionsEvent(
              id: Uuid().v4(),
              action: 'RetrieveCommissionsEvent',
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
    _controller.dispose();
    _list.dispose();
    _fToast.removeQueuedCustomToasts();
    _fToast.removeCustomToast();
    super.dispose();
  }
}
