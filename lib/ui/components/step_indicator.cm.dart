import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.title,
  });
  final int index;
  final int currentIndex;
  final String title;

  bool get showDot {
    return index == currentIndex;
  }

  Color get _colorIsActive {
    if (index < currentIndex) {
      return ThemeUtil.success;
    }

    if (index == currentIndex) {
      return ThemeUtil.primaryColor1;
    }

    return ThemeUtil.flora;
  }

  FontWeight get _fontWeight {
    return index == currentIndex ? FontWeight.bold : FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      children: [
        if (showDot)
          Container(
            width: 6,
            height: 6,
            margin: const .only(right: 5),

            decoration: BoxDecoration(color: _colorIsActive, shape: BoxShape.circle),
          ),
        Text(
          title,
          style: PrimaryTextStyle(fontWeight: _fontWeight, color: _colorIsActive, fontSize: 14),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
