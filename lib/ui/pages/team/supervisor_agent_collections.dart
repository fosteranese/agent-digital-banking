import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/ui/components/headers/supervisor_agent_details_searchbox.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/toaster.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorAgentCollections<T> extends StatefulWidget {
  const SupervisorAgentCollections({
    super.key,
    required this.agent,
    required this.sourceList,
    required this.list,
    required this.filter,
    required this.itemFunc,
    required this.emptyListMessageTitle,
    required this.emptyListMessageFunc,
    required this.search,
    required this.conditionFunc,
    this.sourceListFunc,
  });
  final Agent agent;
  final ValueNotifier<List<T>> list;
  final ValueNotifier<List<T>?> sourceList;
  final void Function() filter;
  final Widget Function(dynamic record) itemFunc;
  final String emptyListMessageTitle;
  final String Function(String filter) emptyListMessageFunc;
  final void Function(String value, List<T> requests) search;
  final bool Function(RetrieveDataEvent event) conditionFunc;
  final List<T> Function(dynamic data)? sourceListFunc;

  @override
  State<SupervisorAgentCollections<T>> createState() => _SupervisorAgentCollectionsState<T>();
}

class _SupervisorAgentCollectionsState<T> extends State<SupervisorAgentCollections<T>> {
  final _filterBy = ValueNotifier('');
  final _fToast = FToast();

  @override
  initState() {
    widget.list.value = widget.sourceList.value ?? [];

    _fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        ValueListenableBuilder(
          valueListenable: widget.list,
          builder: (context, value, child) {
            if (value.isEmpty && _filterBy.value.isEmpty) {
              return const SliverToBoxAdapter();
            }

            return SliverPersistentHeader(
              pinned: true,
              delegate: MyHeaderDelegate(
                maxHeight: 73,
                minHeight: 73,
                builder: (context, shrinkOffset, overlapsContent) {
                  return SupervisorAgentDetailsSearchBox(
                    filterBy: _filterBy,
                    onFilter: widget.filter,
                    onSearch: (searchValue) {
                      _filterBy.value = searchValue.trim();
                      widget.search(_filterBy.value, widget.sourceList.value ?? []);
                    },
                  );
                },
              ),
            );
          },
        ),
        BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
          listener: (context, state) => _handleBlocListener(state),
          buildWhen: (previous, current) => widget.conditionFunc(current.event!),
          builder: (context, state) {
            return ValueListenableBuilder(
              valueListenable: widget.list,
              builder: (context, list, child) {
                if (list.isEmpty && state is RetrievingData) {
                  return const HistoryShimmerList();
                }

                if (list.isEmpty) {
                  return _buildEmptyState(context);
                }

                return SliverList.separated(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return widget.itemFunc(list[index]);
                  },
                  separatorBuilder: (_, _) =>
                      Divider(thickness: 1, color: ThemeUtil.headerBackground, height: 0),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _handleBlocListener(RetrieveDataState state) {
    if (!widget.conditionFunc(state.event!)) {
      return;
    }

    if (state is DataRetrieved && state.stillLoading) {
      _fToast.showToast(
        child: const Toaster('Loading...'),
        toastDuration: const Duration(hours: 1),
      );
      return;
    }

    if (state is DataRetrieved) {
      if (widget.sourceListFunc != null) {
        widget.sourceList.value = widget.sourceListFunc!(state.data);
      } else {
        widget.sourceList.value = state.data ?? [];
      }
      widget.search('', widget.sourceList.value ?? []);

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
              SvgPicture.asset('assets/img/empty.svg', width: 80),
              Text(
                widget.emptyListMessageTitle,
                textAlign: .center,
                style: PrimaryTextStyle(color: ThemeUtil.black, fontSize: 18, fontWeight: .bold),
              ),
              Text(
                widget.emptyListMessageFunc(_filterBy.value),
                textAlign: .center,
                style: PrimaryTextStyle(color: ThemeUtil.flat, fontSize: 14, fontWeight: .normal),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
