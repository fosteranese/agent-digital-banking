import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_sage_agent/constants/field.const.dart';
import 'package:my_sage_agent/data/models/supervisor_activity_model/service_request.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorReceiptPage extends StatefulWidget {
  const SupervisorReceiptPage({super.key, required this.request});
  static const routeName = '/history/supervisor-receipt';
  final ServiceRequest request;

  @override
  State<SupervisorReceiptPage> createState() => _SupervisorReceiptPageState();
}

class _SupervisorReceiptPageState extends State<SupervisorReceiptPage> {
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
      title: 'Transaction Details',
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
                label: widget.request.request?.serviceName ?? 'N/A',
                value: widget.request.request?.transDate ?? '',
              ),
              SummaryTile(
                label: 'Client Name',
                value: widget.request.request?.customerName ?? 'John Doe',
                verticalPadding: 8,
              ),
              SummaryExtraTile(
                label: 'Agent Details',
                value: widget.request.request?.agentName ?? 'John Doe',
                value2: 'Agent Code: ${widget.request.agentCode}',
                verticalPadding: 8,
                onPressed: () {},
              ),
              if (widget.request.request?.collectionMode != null)
                SummaryTile(
                  label: 'Payment Method',
                  value:
                      '${widget.request.request?.collectionMode} (${widget.request.request?.customerAccountNumber})',
                  verticalPadding: 8,
                ),
              if (widget.request.request?.amount != null)
                SummaryTile(
                  label: 'Amount',
                  value: 'GHS ${FormatterUtil.currency(widget.request.request?.amount ?? 0)}',
                  verticalPadding: 8,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({
    super.key,
    required this.label,
    required this.name,
    this.dataType = FieldDataTypesConst.string,
  });

  final String label;
  final String name;
  final int dataType;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: dataType == FieldDataTypesConst.link
          ? () {
              final url = Uri.parse(name);
              launchUrl(url);
            }
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: PrimaryTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff4F4F4F),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              // overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              softWrap: true,
              style: PrimaryTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xff010203),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
