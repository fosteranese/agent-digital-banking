import 'package:flutter/material.dart';

import '../../utils/string.util.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.text,
    this.size = 21,
    this.textSize,
    this.border,
  });
  final String text;
  final double size;
  final double? textSize;
  final Border? border;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  List<Color> _colors = [
    Colors.black,
    Colors.white,
  ];

  @override
  void initState() {
    _colors = StringUtil.getColorFromText(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size * 2,
      height: widget.size * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _colors.first,
        borderRadius: BorderRadius.circular(widget.size),
        border: widget.border,
      ),
      // constraints: const BoxConstraints.expand(),
      child: Text(
        StringUtil.getInitials(widget.text),
        style: TextStyle(
          color: _colors.last,
          fontSize: widget.textSize,
        ),
      ),
    );
  }
}