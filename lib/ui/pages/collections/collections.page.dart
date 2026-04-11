import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/collection_model.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/ui/components/form/collection_header.dart';
import 'package:my_sage_agent/ui/components/history/collection_item.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key, this.showBackBtn = false});
  static const routeName = '/collections';
  final bool showBackBtn;

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final _filterBy = ValueNotifier('');
  List<CollectionModel> _sourceList = [];
  List<CollectionModel> _list = [];
  final _fToast = FToast();
  final scrollController = ScrollController();

  @override
  void initState() {
    _sourceList = context.read<RetrieveDataBloc>().data['RetrieveCollectionEvent'] ?? [];
    _list = _sourceList;
    _fToast.init(context);
    super.initState();
  }

  List<CollectionModel> _applyFilter(String filter) {
    filter = filter.trim().toLowerCase();

    return _list.where((e) {
      if (filter.isEmpty) return true;

      return e.collectionMode?.toLowerCase() == filter;
    }).toList();
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
            if (_list.isEmpty) {
              return SliverToBoxAdapter(child: SizedBox.shrink());
            }

            return SliverPersistentHeader(
              pinned: true,
              delegate: MyHeaderDelegate(
                maxHeight: 140,
                minHeight: 84,
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
                final collections = _applyFilter(value);

                if (collections.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverList.separated(
                    itemCount: collections.length,
                    itemBuilder: (_, index) {
                      final record = collections[index];
                      return CollectionItem(record: record, onTap: null);
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

      _search('', _sourceList, shouldSetState: false);
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

  void _search(String value, List<CollectionModel> requests, {bool shouldSetState = true}) {
    logger.i(value);
    final search = value.trim().toLowerCase();
    _list = requests
        .where((e) => e.collectionMode?.toLowerCase().contains(search) ?? false)
        .toList();
    if (shouldSetState) setState(() {});
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
