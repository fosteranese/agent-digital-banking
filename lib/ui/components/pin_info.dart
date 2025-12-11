import 'package:flutter/material.dart';

import '../../utils/theme.util.dart';

class PinInfo extends StatelessWidget {
  const PinInfo({super.key, required this.info});

  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.blue,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  info,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: ThemeUtil.fontHelveticaNeue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}