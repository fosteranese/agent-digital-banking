import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CommissionSearchBox extends StatefulWidget {
  const CommissionSearchBox({
    super.key,
    required this.dateFrom,
    required this.dateTo,
    this.onFilter,
  });

  final TextEditingController dateFrom;
  final TextEditingController dateTo;
  final void Function()? onFilter;

  @override
  State<CommissionSearchBox> createState() => _CommissionSearchBoxState();
}

class _CommissionSearchBoxState extends State<CommissionSearchBox> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.maxFinite, 50),
      child: Container(
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
                      'My Commissions',
                      style: const PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onFilter,
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
          ],
        ),
      ),
    );
  }
}
