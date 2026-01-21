import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/collection_model.dart';

import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:string_validator/string_validator.dart';

class CollectionHeader extends StatelessWidget {
  const CollectionHeader({super.key, required this.filterBy, this.onFilter});

  final ValueNotifier<String> filterBy;
  final void Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const .all(20),
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
                    style: const PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_outlined),
                      const SizedBox(width: 2),
                      Text(
                        'Filter',
                        style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<RetrieveDataBloc, RetrieveDataState>(
            builder: (context, state) {
              final List<CollectionModel> list =
                  context.read<RetrieveDataBloc>().data['RetrieveCollectionEvent'] ?? [];
              return MyTabHeader(
                controller: filterBy,
                tabItems: [
                  TabItem(title: getTitle(list, '', 'All')),
                  TabItem(
                    title: getTitle(list, FormsConst.mobileMoney.name, 'MoMo'),
                    id: FormsConst.mobileMoney.name,
                  ),
                  TabItem(
                    title: getTitle(list, FormsConst.cashDeposit.name, 'Cash'),
                    id: FormsConst.cashDeposit.name,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String getTitle(List<CollectionModel> list, String filter, title) {
    filter = filter.toLowerCase();
    final count = filter.isEmpty
        ? list.length
        : list.where((item) => item.collectionMode?.toLowerCase().equals(filter) ?? false).length;

    if (count > 100) {
      return '$title ($count+)';
    } else if (count > 0) {
      return '$title ($count)';
    }

    return title;
  }
}
