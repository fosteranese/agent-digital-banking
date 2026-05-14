import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/collection_model.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_summary_model/collection_summary.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_summary_model/supervisor_collection_summary_model.dart';
import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/ui/components/tab_header_2.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionHeader extends StatelessWidget {
  const CollectionHeader({super.key, required this.filterBy, this.onFilter});

  final ValueNotifier<String> filterBy;
  final void Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const .all(20),
      width: .maxFinite,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: .spaceAround,
              crossAxisAlignment: .center,
              children: [
                Expanded(
                  child: Text(
                    'Collections',
                    style: const PrimaryTextStyle(fontSize: 20, fontWeight: .w600),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_outlined),
                      const SizedBox(width: 2),
                      Text('Filter', style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
            builder: (context, state) {
              final source = AppUtil.currentUser?.userType == 'SUPERVISOR'
                  ? context
                        .read<RetrieveDataBloc>()
                        .data['RetrieveSupervisorCollectionSummaryEvent']
                  : (context.read<RetrieveDataBloc>().data['RetrieveCollectionEvent'] ?? []);

              var cashAtHand = source;
              var summaryDeposited = source;
              var summaryMomo = source;
              var summaryCash = source;
              if (source is SupervisorCollectionSummaryModel) {
                cashAtHand = source.cashAtHand;
                summaryDeposited = source.summaryDeposited;
                summaryMomo = source.summaryMomo;
                summaryCash = source.summaryCash;
              }

              return SizedBox(
                width: .maxFinite,
                height: 55,
                child: MyTabHeader2(
                  controller: filterBy,
                  scrollable: true,
                  tabItems: [
                    TabItem(
                      title: getTitle(
                        cashAtHand,
                        FormsConst.cashAtHand.id,
                        FormsConst.cashAtHand.name,
                      ),
                      id: FormsConst.cashAtHand.id,
                    ),
                    TabItem(
                      title: getTitle(
                        summaryDeposited,
                        FormsConst.deposit.id,
                        FormsConst.deposit.name,
                      ),
                      id: FormsConst.deposit.id,
                    ),
                    TabItem(
                      title: getTitle(
                        summaryMomo,
                        FormsConst.mobileMoney.id,
                        FormsConst.mobileMoney.name,
                      ),
                      id: FormsConst.mobileMoney.id,
                    ),
                    TabItem(
                      title: getTitle(summaryCash, FormsConst.cash.id, FormsConst.cash.name),
                      id: FormsConst.cash.id,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String getTitle(dynamic list, String filter, title) {
    if (AppUtil.currentUser?.userType == 'SUPERVISOR') {
      return getSupervisorTitle(list ?? [], title);
    }

    return getGeneralTitle(list, filter, title);
  }

  String getGeneralTitle(List<CollectionModel> list, String filter, title) {
    filter = filter.toLowerCase();
    final count = filter.isEmpty
        ? list.length
        : list.where((item) {
            if (item.supervisor != null) {
              return item.supervisor?.collection?.collectionMode?.toLowerCase() == filter;
            }

            return item.agent?.collectionMode?.toLowerCase() == filter;
          }).length;

    if (count > 100) {
      return '$title ($count+)';
    } else if (count > 0) {
      return '$title ($count)';
    }

    return title;
  }

  String getSupervisorTitle(List<CollectionSummary> list, title) {
    final count = list.length;

    if (count > 100) {
      return '$title ($count+)';
    } else if (count > 0) {
      return '$title ($count)';
    }

    return title;
  }
}
