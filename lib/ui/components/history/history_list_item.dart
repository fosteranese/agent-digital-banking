import 'package:flutter/material.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

import '../../../constants/status.const.dart';
import '../../../data/models/history/history.response.dart';
import '../../../data/models/request_response.dart';
import '../../../data/models/response.modal.dart';

class HistoryListItem extends StatelessWidget {
  final RequestResponse record;
  final Response<HistoryResponse> sourceList;
  final VoidCallback? onTap;

  const HistoryListItem({super.key, required this.record, required this.sourceList, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildIcon(), const SizedBox(width: 10), _buildDetails(), _buildAmountOrStatus()]),
      ),
    );
  }

  Widget _buildIcon() {
    if (record.amount?.isEmpty ?? true) {
      return _iconContainer(const Icon(Icons.settings_outlined, color: Color(0xff919195)));
    }

    if (record.status == 1) {
      return _iconContainer(Icon(Icons.north_east_outlined, color: _statusColor()));
    }

    if (record.status == 0) {
      return _iconContainer(Icon(Icons.south_west_outlined, color: _statusColor()));
    }

    return _iconContainer(const SizedBox());
  }

  Widget _iconContainer(Widget child) {
    return Container(
      height: 43,
      width: 43,
      decoration: BoxDecoration(color: const Color(0xffF8F8F8), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.formName ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            record.receiptDate ?? '',
            style: PrimaryTextStyle(color: const Color(0xff919195), fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountOrStatus() {
    if (record.amount?.isEmpty ?? true) {
      return _statusBadge();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          record.amount ?? '',
          style: PrimaryTextStyle(color: _statusColor(), fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          record.statusLabel?.toUpperCase() ?? '',
          style: PrimaryTextStyle(color: const Color(0xff919195), fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _statusBadge() {
    final label = (record.status == 1)
        ? 'Sent'
        : (record.status == 0)
        ? 'Failed'
        : 'Pending';
    final icon = (record.status == 1)
        ? Icons.check
        : (record.status == 0)
        ? Icons.close
        : Icons.hourglass_bottom_outlined;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: const Color(0xffF8F8F8), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: _statusColor(),
            child: Icon(icon, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 5),
          Text(label, style: PrimaryTextStyle(color: const Color(0xff4F4F4F), fontSize: 13)),
        ],
      ),
    );
  }

  Color _statusColor() {
    switch (record.statusLabel?.toUpperCase()) {
      case StatusConstants.success:
        return const Color(0xff219653);
      case StatusConstants.pending:
        return Colors.amber;
      case StatusConstants.failed:
      case StatusConstants.error:
        return const Color(0xffFF0600);
      default:
        return Colors.blueGrey;
    }
  }
}
