import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class MySegmentButton extends StatefulWidget {
  const MySegmentButton({
    super.key,
    required this.controller,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.showIcon = false,
    required this.onSelected,
    this.isSelectable = true,
  });
  final String label;
  final String value;
  final bool showDivider;
  final bool showIcon;
  final TextEditingController controller;
  final void Function(String value) onSelected;
  final bool isSelectable;

  @override
  State<MySegmentButton> createState() => _MySegmentButtonState();
}

class _MySegmentButtonState extends State<MySegmentButton> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          widget.onSelected(widget.value);

          if (widget.isSelectable) {
            widget.controller.value = TextEditingValue(text: widget.value);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: widget.controller.text == widget.value
                ? Theme.of(context).primaryColor
                : Colors.white,
            border: widget.showDivider
                ? const Border(
                    right: BorderSide(color: Color(0xffF1F1F1), style: BorderStyle.solid, width: 1),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.showIcon)
                SvgPicture.asset(
                  'assets/img/map.svg',
                  // height: 14,
                  colorFilter: ColorFilter.mode(
                    widget.controller.text == widget.value ? Colors.white : const Color(0xff202020),
                    BlendMode.srcIn,
                  ),
                ),
              if (widget.showIcon) const SizedBox(width: 5),
              FittedBox(
                child: Text(
                  widget.label,
                  style: PrimaryTextStyle(
                    color: widget.controller.text == widget.value
                        ? Colors.white
                        : const Color(0xff202020),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
