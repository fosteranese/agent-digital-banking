import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RotatedBox(
        quarterTurns: 3,
        child: Material(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              alignment: Alignment.center,
              height: 25,
              width: 104,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}