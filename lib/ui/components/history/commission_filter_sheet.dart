import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/date_picker.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CommissionFilterSheet extends StatefulWidget {
  final TextEditingController dateFrom;
  final TextEditingController dateTo;
  final void Function(String dateFrom, String dateTo) onFilterSelected;
  final void Function() onClearFilter;

  const CommissionFilterSheet({
    super.key,
    required this.dateFrom,
    required this.dateTo,
    required this.onFilterSelected,
    required this.onClearFilter,
  });

  @override
  State<CommissionFilterSheet> createState() => _CommissionFilterSheetState();
}

class _CommissionFilterSheetState extends State<CommissionFilterSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
        titleSpacing: 0,
        title: Text(
          'Filter',
          style: PrimaryTextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClearFilter();
            },
            child: Text(
              'Clear Filter',
              style: PrimaryTextStyle(fontSize: 14, color: ThemeUtil.black),
            ),
          ),
          SizedBox(width: 10),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FormDatePicker(
            label: 'Date From',
            placeholder: 'DD/MM/YYYY',
            controller: widget.dateFrom,
          ),
          FormDatePicker(label: 'Date To', placeholder: 'DD/MM/YYYY', controller: widget.dateTo),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: .only(left: 20, right: 20, top: 20),
          child: FormButton(
            onPressed: () {
              widget.onFilterSelected(widget.dateFrom.text.trim(), widget.dateTo.text.trim());
              context.pop();
            },
            text: 'Show Results',
          ),
        ),
      ),
    );
  }
}
