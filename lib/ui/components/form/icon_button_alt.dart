import 'package:flutter/material.dart';

class FormIconButtonAlt extends StatelessWidget {
  const FormIconButtonAlt({
    super.key,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.height = 53,
    this.width = 53,
    this.icon,
    this.iconSize,
    this.padding,
    this.borderRadius = 7,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final void Function() onPressed;
  final double height;
  final double width;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsets? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColorLight,
          foregroundColor: textColor ?? Colors.white,
          textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: 1,
              ),
          padding: padding ?? const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Icon(
          icon ?? Icons.filter_list,
          size: iconSize ?? (width / 2),
        ),
      ),
    );
  }
}