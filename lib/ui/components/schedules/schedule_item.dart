import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({super.key, required this.keyName, required this.value});

  final String keyName;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            keyName.trim(),
            style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff4F4F4F)),
          ),
          const SizedBox(width: 10),
          Text(
            value.trim(),
            textAlign: TextAlign.end,
            style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xff010203)),
          ),
        ],
      ),
    );
  }
}
