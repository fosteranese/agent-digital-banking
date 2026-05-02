import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/reversal_request_model/reversal_request_model.dart';
import 'package:my_sage_agent/ui/components/history/history_shimmer.dart';
import 'package:my_sage_agent/ui/components/history/reversal_item.dart';
import 'package:my_sage_agent/ui/pages/request/requests.page.dart';
import 'package:my_sage_agent/ui/pages/request/reversal_details.page.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorPendingReversals extends StatefulWidget {
  const SupervisorPendingReversals({super.key});

  @override
  State<SupervisorPendingReversals> createState() => _SupervisorPendingReversalsState();
}

class _SupervisorPendingReversalsState extends State<SupervisorPendingReversals> {
  final _list = ValueNotifier(<ReversalRequestModel>[]);
  late final _bloc = context.read<RetrieveDataBloc>();

  @override
  void initState() {
    _list.value = _bloc.data['RetrievePendingReversalsEvent'] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: .symmetric(vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pending Reversals',
                    style: const PrimaryTextStyle(
                      fontSize: 16,
                      fontWeight: .w600,
                      color: ThemeUtil.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.push(RequestsPage.routeName);
                  },
                  child: Text(
                    'See all',
                    style: PrimaryTextStyle(
                      fontSize: 14,
                      fontWeight: .normal,
                      color: ThemeUtil.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BlocConsumer<RetrieveDataBloc, RetrieveDataState>(
          listener: (context, state) => _handleBlocListener(state),
          buildWhen: (previous, current) => current.event is RetrieveCollectionEvent,
          builder: (context, state) {
            if (_list.value.isEmpty && state is RetrievingData) {
              return const HistoryShimmerList();
            }

            if (_list.value.isEmpty) {
              return _buildEmptyState(context);
            }

            return ValueListenableBuilder(
              valueListenable: _list,
              builder: (context, list, child) {
                return SliverList.separated(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final record = list[index];
                    return ReversalItem(
                      key: ValueKey('reversal-item-$index'),
                      record: record,
                      onTap: () {
                        context.push(ReversalDetailsPage.routeName, extra: record);
                      },
                    );
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
    if (state.event is! RetrievePendingReversalsEvent) {
      return;
    }

    if (state is DataRetrieved) {
      _list.value = state.data ?? [];
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
              SvgPicture.asset('assets/img/empty.svg', width: 50),
              Text(
                'You have no pending reversals from your agents.',
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(
                  color: ThemeUtil.flat,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
