import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum WizardAnimationType { slide, scale, fade }

class Wizard extends StatefulWidget {
  const Wizard({
    super.key,
    required this.setup,
    this.init,
    this.initialIndex = 0,
    this.customTransition,
    this.animationType = WizardAnimationType.slide,
  });

  final List<Widget> Function(
    void Function() previous,
    void Function() next,
    void Function(int index) goTo,
  )
  setup;
  final void Function(void Function(int) goTo)? init;
  final int initialIndex;
  final Widget Function(Widget, Animation<double>)?
  customTransition;
  final WizardAnimationType animationType;

  @override
  State<Wizard> createState() => _WizardState();
}

class _WizardState extends State<Wizard> {
  late List<Widget> _stages;
  late int _lastIndex;
  late int _currentIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _stages = widget.setup(_previous, _next, _goTo);
    if (widget.init != null) {
      widget.init!(_goTo);
    }
    _lastIndex = _stages.length - 1;
    _currentIndex = widget.initialIndex;
    _previousIndex = widget.initialIndex;
  }

  void _next() {
    if (_currentIndex < _lastIndex) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex += 1;
      });
    }
  }

  void _goTo(int stage) {
    if (stage > 0) {
      setState(() {
        _previousIndex = stage - 1;
        _currentIndex = stage;
      });
    } else if (stage < _lastIndex) {
      setState(() {
        _previousIndex = stage - 1;
        _currentIndex = stage;
      });
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex -= 1;
      });
    }
  }

  Widget setupTransition(
    Widget child,
    Animation<double> animation,
  ) {
    switch (widget.animationType) {
      case WizardAnimationType.slide:
        return slideTransition(child, animation);

      case WizardAnimationType.scale:
        return scaleTransition(child, animation);

      default:
        return fadeTransition(child, animation);
    }
  }

  SlideTransition slideTransition(
    Widget child,
    Animation<double> animation,
  ) {
    final offsetAnimation = Tween(
      begin: _currentIndex >= _previousIndex
          ? const Offset(1.0, 0.0)
          : const Offset(-0.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  ScaleTransition scaleTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return ScaleTransition(scale: animation, child: child);
  }

  FadeTransition fadeTransition(
    Widget child,
    Animation<double> animation,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Widget build(BuildContext context) {
    {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 0),
        switchInCurve: Curves.linearToEaseOut,
        transitionBuilder: setupTransition,
        child: _stages[_currentIndex],
      );
    }
  }
}
