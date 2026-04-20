import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';

import 'package:my_sage_agent/ui/components/dashboard/supervisor_pending_reversals.dart';
import 'package:my_sage_agent/ui/components/history/collection_summary_item.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/ui/components/tab_header_2.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorDashboardRecentTransactions extends StatefulWidget {
  const SupervisorDashboardRecentTransactions({super.key});

  @override
  State<SupervisorDashboardRecentTransactions> createState() =>
      _SupervisorDashboardRecentTransactionsState();
}

class _SupervisorDashboardRecentTransactionsState
    extends State<SupervisorDashboardRecentTransactions> {
  final _filterBy = ValueNotifier('collections');
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .only(top: 15, left: 20, right: 20),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: MyHeaderDelegate(
              maxHeight: 55,
              minHeight: 55,
              builder: (context, shrinkOffset, overlapsContent) {
                return BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
                  buildWhen: (previous, current) {
                    return current.event is RetrievePendingReversalsEvent;
                  },
                  builder: (context, state) {
                    final reversals = context
                        .read<RetrieveDataBloc>()
                        .data['RetrievePendingReversalsEvent'];

                    var reversalCount = '';
                    if (reversals != null) {
                      reversalCount = reversals.length > 10
                          ? ' (${reversals.length}+)'
                          : ' (${reversals.length})';
                    }

                    return MyTabHeader2(
                      controller: _filterBy,
                      tabItems: [
                        TabItem(title: 'Collection Summary', id: 'collections'),
                        TabItem(title: 'Reversals$reversalCount', id: 'requests'),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _filterBy,
            builder: (context, value, child) {
              if (value == "collections") {
                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: .symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Collections for today',
                                style: const PrimaryTextStyle(
                                  fontSize: 16,
                                  fontWeight: .w600,
                                  color: ThemeUtil.black,
                                ),
                              ),
                            ),
                            Text(
                              'as @ ${FormatterUtil.timeOnly(DateTime.now())}',
                              style: const PrimaryTextStyle(
                                fontSize: 14,
                                fontWeight: .w400,
                                color: ThemeUtil.flat,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList.list(
                      children: [
                        CollectionSummaryItem(
                          amount: AppUtil.currentUser?.supervisorData?.cashCollected ?? 0,
                          title: 'Cash Collected',
                          icon: 'assets/img/cash-collected.svg',
                          onTap: null,
                        ),
                        CollectionSummaryItem(
                          amount: AppUtil.currentUser?.supervisorData?.momoCollected ?? 0,
                          title: 'MoMo Collected',
                          icon: 'assets/img/wallet.svg',
                          onTap: null,
                        ),
                        CollectionSummaryItem(
                          amount: AppUtil.currentUser?.supervisorData?.cashAtHand ?? 0,
                          title: 'Cash at Hand',
                          icon: 'assets/img/cash-collected.svg',
                          onTap: null,
                        ),
                        CollectionSummaryItem(
                          amount: AppUtil.currentUser?.supervisorData?.cashDeposited ?? 0,
                          title: 'Cash Deposited',
                          icon: 'assets/img/money.svg',
                          onTap: null,
                        ),
                      ],
                    ),
                  ],
                );
              }

              return SupervisorPendingReversals();
            },
          ),
        ],
      ),
    );
  }
}
