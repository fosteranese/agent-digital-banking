import 'package:flutter/material.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

import '../../../data/models/history/history.response.dart';
import '../../../data/models/response.modal.dart';
import '../../components/item.dart';

class HistoryFilterSheet extends StatelessWidget {
  final Response<HistoryResponse> sourceList;
  final String filterBy;
  final Function(String) onFilterSelected;

  const HistoryFilterSheet({super.key, required this.sourceList, required this.filterBy, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Filter by Category',
          style: PrimaryTextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: const Color(0x91F7C15A)),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Item(
            onPressed: () {
              onFilterSelected('');
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
            title: 'All',
          ),
          const Divider(color: Color(0xffF1F1F1)),
          ...(sourceList.data?.activity ?? []).map((e) {
            return Item(
              onPressed: () {
                onFilterSelected(e.activityName ?? '');
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              title: e.activityName ?? '',
            );
          }),
        ],
      ),
    );
  }
}
