import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_summary_model/collection_summary.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_summary_model/supervisor_collection_summary_model.dart';
import 'package:my_sage_agent/ui/components/headers/collection_header.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/history/supervisor_collection_summary_item.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorCollectionsPage extends StatefulWidget {
  const SupervisorCollectionsPage({super.key, this.showBackBtn = false});
  final bool showBackBtn;

  @override
  State<SupervisorCollectionsPage> createState() => _SupervisorCollectionsPageState();
}

class _SupervisorCollectionsPageState extends State<SupervisorCollectionsPage> {
  final _filterBy = ValueNotifier('');
  SupervisorCollectionSummaryModel? _sourceList;
  final _fToast = FToast();
  final scrollController = ScrollController();

  @override
  void initState() {
    _sourceList = context.read<RetrieveDataBloc>().data['RetrieveCollectionEvent'] ?? [];

    _fToast.init(context);
    super.initState();
  }

  List<CollectionSummary> get _list {
    return _applyFilter(_filterBy.value);
  }

  List<CollectionSummary> _applyFilter(String filter) {
    filter = filter.trim().toLowerCase();

    if (filter == FormsConst.cashAtHand.id) {
      return _sourceList?.cashAtHand?.toList() ?? [];
    }

    if (filter == FormsConst.mobileMoney.id) {
      return _sourceList?.summaryMomo?.toList() ?? [];
    }

    if (filter == FormsConst.deposit.id) {
      return _sourceList?.summaryDeposited?.toList() ?? [];
    }

    if (filter == FormsConst.cash.id) {
      return _sourceList?.summaryCash?.toList() ?? [];
    }

    return _sourceList?.cashAtHand?.toList() ?? [];
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
          RetrieveCollectionEvent(
            id: Uuid().v4(),
            action: 'RetrieveCollectionEvent',
            skipSavedData: true,
          ),
        );
      },
      title: 'Collections',
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
        BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
          builder: (context, state) {
            return SliverPersistentHeader(
              pinned: true,
              delegate: MyHeaderDelegate(
                maxHeight: 140,
                minHeight: 95,
                builder: (context, shrinkOffset, overlapsContent) {
                  return CollectionHeader(filterBy: _filterBy);
                },
              ),
            );
          },
        ),
        BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
          listener: (context, state) => _handleBlocListener(state),
          buildWhen: (previous, current) => current.event is RetrieveCollectionEvent,
          builder: (context, state) {
            if (_list.isEmpty && state is RetrievingData) {
              return const HistoryShimmerList();
            }

            if (_list.isEmpty) {
              return _buildEmptyState(context);
            }

            return ValueListenableBuilder(
              valueListenable: _filterBy,
              builder: (context, value, child) {
                if (_list.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverPadding(
                  padding: const .symmetric(horizontal: 15),
                  sliver: SliverList.separated(
                    itemCount: _list.length,
                    itemBuilder: (_, index) {
                      final record = _list[index];
                      return SupervisorCollectionSummaryItem(record: record, onTap: null);
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
    if (state.event is! RetrieveCollectionEvent) {
      return;
    }

    if (state is DataRetrieved && state.stillLoading) {
      _fToast.showToast(child: const Toaster('Loading'), toastDuration: const Duration(hours: 1));
      return;
    }

    if (state is DataRetrieved) {
      _sourceList = state.data ?? [];

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
                'No collections found',
                textAlign: .center,
                style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 18, fontWeight: .bold),
              ),
              Text(
                '${_filterBy.value} Collections you\'ve made will appear here.',
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

  @override
  void dispose() {
    _fToast.removeQueuedCustomToasts();
    _fToast.removeCustomToast();
    super.dispose();
  }
}
