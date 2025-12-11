import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  const MySlider({
    super.key,
    required this.children,
    required this.height,
    required this.width,
  });

  final List<Widget> children;
  final double height;
  final double width;

  @override
  MySliderState createState() => MySliderState();
}

class MySliderState extends State<MySlider> {
  final ScrollController _controller = ScrollController(
    initialScrollOffset: 0,
  );
  double _scrollExtent = 0;

  Timer? _timer;
  bool _pause = false;

  @override
  void initState() {
    _slide();
    super.initState();
  }

  void _slide() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pause) {
        return;
      }
      if (_controller.position.extentAfter <= 0) {
        _scrollExtent = 0;
        _controller.jumpTo(_scrollExtent);
      } else {
        _scrollExtent += 100;
        _controller.animateTo(
          _scrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.linear,
        );
      }
    });
  }

  final buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: GestureDetector(
        onLongPressStart: (_) {
          _pause = true;
        },
        onLongPressEnd: (_) {
          _pause = false;
        },
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.start,
            controller: _controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.children,
            )),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}