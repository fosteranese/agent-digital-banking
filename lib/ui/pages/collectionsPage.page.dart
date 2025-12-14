import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/history/history_bloc.dart';
import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/search_box.dart';
import 'package:my_sage_agent/ui/components/history/history_filter_sheet.dart';
import 'package:my_sage_agent/ui/components/history/history_list_item.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/receipt.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key, this.showBackBtn = false});
  static const routeName = '/history';
  final bool showBackBtn;

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final _controller = TextEditingController();
  String _filterBy = '';
  Response<HistoryResponse> _sourceList = const Response(
    code: '',
    message: '',
    status: '',
    data: HistoryResponse(),
  );
  List<RequestResponse> _list = [];
  final _fToast = FToast();
  bool _showUpdating = true;
  final scrollController = ScrollController();

  @override
  void initState() {
    context.read<HistoryBloc>().add(const LoadHistory(true));
    _sourceList = context.read<HistoryBloc>().history;
    _list = _sourceList.data?.request ?? [];
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
        _showUpdating = false;
        context.read<HistoryBloc>().add(const SilentLoadHistory());
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

      // bottom: SearchBox(
      //   controller: _controller,
      //   onSearch: (value) => _search(value, _sourceList.data?.request ?? []),
      //   filterBy: _filterBy,
      //   onFilter: () => _onShowFilterDialog(context),
      // ),
      slivers: [
        BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (_list.isEmpty) {
              return SliverToBoxAdapter(child: SizedBox.shrink());
            }

            return SliverPersistentHeader(
              pinned: true,
              delegate: MyHeaderDelegate(
                maxHeight: 120,
                minHeight: 80,
                builder: (context, shrinkOffset, overlapsContent) {
                  return SearchBox(
                    controller: _controller,
                    onSearch: (value) => _search(value, _sourceList.data?.request ?? []),
                    filterBy: _filterBy,
                    onFilter: () => _onShowFilterDialog(context),
                  );
                },
              ),
            );
          },
        ),
        BlocConsumer<HistoryBloc, HistoryState>(
          listener: (context, state) => _handleBlocListener(state),
          buildWhen: (previous, current) =>
              current is LoadingHistory ||
              current is HistoryLoaded ||
              current is HistoryLoadedSilently,
          builder: (context, state) {
            if (state is LoadingHistory) {
              return const HistoryShimmerList();
            }

            if (state is! HistoryLoaded && state is! HistoryLoadedSilently) {
              return const SliverToBoxAdapter();
            }

            if (_list.isEmpty) {
              return _buildEmptyState(context);
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              sliver: SliverList.separated(
                itemCount: _list.length,
                itemBuilder: (_, index) {
                  final record = _list[index];
                  return HistoryListItem(
                    record: record,
                    sourceList: _sourceList,
                    onTap: record.showReceipt == 1 ? () => _openReceipt(record) : null,
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(height: 10),
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleBlocListener(HistoryState state) {
    if (state is SilentLoadingHistory && _showUpdating) {
      _fToast.showToast(child: const Toaster('Updating'), toastDuration: const Duration(hours: 1));
    }

    if (state is HistoryLoaded || state is HistoryLoadedSilently) {
      if (state is HistoryLoaded) {
        _sourceList = state.result;
      } else if (state is HistoryLoadedSilently) {
        _sourceList = state.result;
      }

      _search('', _sourceList.data?.request ?? [], shouldSetState: false);
      _fToast.removeCustomToast();
      MainLayout.stopRefresh(context);
    }

    if (state is LoadHistoryError || state is SilentLoadHistoryError) {
      _fToast.removeCustomToast();
      MainLayout.stopRefresh(context);
    }
  }

  void _search(String value, List<RequestResponse> requests, {bool shouldSetState = true}) {
    logger.i(value);
    final search = value.trim().toLowerCase();
    _list = requests.where((e) => e.formName?.toLowerCase().contains(search) ?? false).toList();
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
                'No $_filterBy collections found',
                style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 18, fontWeight: .bold),
              ),
              const Text(
                'Collections you\'ve made will appear here.',
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

  void _onShowFilterDialog(BuildContext mainContext) {
    showModalBottomSheet(
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => HistoryFilterSheet(
        sourceList: _sourceList,
        filterBy: _filterBy,
        onFilterSelected: (filter) {
          setState(() => _filterBy = filter);
          if (filter.isEmpty) {
            mainContext.read<HistoryBloc>().add(const LoadAllHistory());
          } else {
            final activity = _sourceList.data?.activity?.firstWhere(
              (e) => e.activityName == filter,
            );
            if (activity != null) {
              mainContext.read<HistoryBloc>().add(FilterHistory(activity));
            }
          }
        },
      ),
    );
  }

  void _openReceipt(RequestResponse record) {
    context.push(
      ReceiptPage.routeName,
      extra: {
        'request': record,
        'imageBaseUrl': _sourceList.imageBaseUrl,
        'imageDirectory': _sourceList.imageDirectory,
        'fblLogo': _sourceList.data?.fblLogo ?? '',
      },
    );
  }

  @override
  void dispose() {
    _fToast.removeQueuedCustomToasts();
    _fToast.removeCustomToast();
    super.dispose();
  }
}
