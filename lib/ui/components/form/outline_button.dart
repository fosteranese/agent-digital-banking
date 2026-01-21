import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class FormOutlineButton extends StatelessWidget {
  const FormOutlineButton({
    super.key,
    this.height = 56,
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.padding, // = const EdgeInsets.all(20),
    this.icon,
    this.elevation,
    this.shape,
    this.side,
    this.textStyle,
    this.textAlign,
  });

  final double height;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final void Function() onPressed;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final double? elevation;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: padding == null ? height : null,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: padding,
          side: side ?? BorderSide(color: backgroundColor ?? Color(0xffC3C3C3), width: 1),
          elevation: 0,
          shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 2)),
        ),
        onPressed: onPressed,
        child: icon == null
            ? FittedBox(
                child: Text(
                  text,
                  textAlign: textAlign,
                  style:
                      textStyle ??
                      PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                ),
              )
            : FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon!,
                    const SizedBox(width: 10),
                    Text(
                      text,
                      textAlign: textAlign,
                      style:
                          textStyle ??
                          PrimaryTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
