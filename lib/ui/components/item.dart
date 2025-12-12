import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class Item extends StatelessWidget {
  const Item({super.key, this.onPressed, required this.title, this.subtitle, this.icon, this.count, this.fullIcon, this.padding, this.trailing});
  final String title;
  final String? subtitle;
  final Widget? icon;
  final void Function()? onPressed;
  final int? count;
  final Widget? fullIcon;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: padding,
      onTap: onPressed,
      tileColor: Colors.white,
      leading: fullIcon ?? (icon != null || fullIcon != null ? icon : null),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: PrimaryTextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16),
            ),
            if (count != null && count! > 0) TextSpan(text: ' ($count)', style: PrimaryTextStyle(fontSize: 16)),
          ],
        ),
      ),
      subtitle: subtitle?.isNotEmpty ?? false ? Text(subtitle ?? '', style: Theme.of(context).textTheme.bodySmall) : null,
      trailing: trailing ?? const Icon(Icons.navigate_next, color: Color(0xff919195)),
    );
  }
}
