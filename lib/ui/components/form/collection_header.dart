import 'package:flutter/material.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';

import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionHeader extends StatelessWidget {
  const CollectionHeader({
    super.key,
    required this.filterBy,
    required this.controller,
    this.onFilter,
  });

  final ValueNotifier<String> filterBy;
  final TextEditingController controller;
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
          MyTabHeader(
            controller: filterBy,
            tabItems: [
              TabItem(title: 'All (100+)'),
              TabItem(title: 'MoMo (50)', id: FormsConst.cashDeposit),
              TabItem(title: 'Cash (20)', id: FormsConst.mobileMoney),
            ],
          ),
        ],
      ),
    );
  }
}
