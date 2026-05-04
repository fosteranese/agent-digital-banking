import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key, required this.request});
  static const routeName = '/history/receipt';
  final RequestResponse request;
  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Colors.white,
      showBackBtn: true,
      showNavBarOnPop: false,
      title: 'Activity Details',
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          color: Colors.white,
          padding: .all(20),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SummaryMinimalTile(
                label: widget.request.formName ?? 'N/A',
                value: widget.request.receiptDate ?? '',
              ),
              if (widget.request.reference?.isNotEmpty ?? false)
                SummaryTile(
                  label: 'Reference',
                  value: widget.request.reference ?? 'N/A',
                  verticalPadding: 8,
                ),

              SummaryStatusTile(
                label: 'Status',
                value: widget.request.statusLabel ?? 'N/A',
                code: widget.request.status ?? 0,
                verticalPadding: 8,
                useValue: widget.request.amount?.isNotEmpty ?? false,
              ),
              if (widget.request.amount?.isNotEmpty ?? false)
                SummaryTile(
                  label: 'Amount',
                  value: widget.request.amount ?? 'N/A',
                  verticalPadding: 8,
                ),
              SummaryTile(
                label: 'Activity',
                value: widget.request.activityName ?? 'N/A',
                verticalPadding: 8,
              ),
              ...widget.request.previewData?.map((item) {
                    return SummaryTile(
                      label: item.key ?? 'N/A',
                      value: item.value ?? 'N/A',
                      verticalPadding: 8,
                    );
                  }) ??
                  [],
              if (widget.request.comment?.isNotEmpty ?? false)
                SummaryTile(
                  label: 'Comment',
                  value: widget.request.comment?.trim() ?? 'N/A',
                  verticalPadding: 8,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
