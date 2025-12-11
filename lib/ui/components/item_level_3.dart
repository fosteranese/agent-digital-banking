import 'package:flutter/material.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class ItemLevel3 extends StatelessWidget {
  const ItemLevel3({super.key, this.onPressed, required this.title, this.subtitle, this.subtitle2, this.icon, this.count, this.fullIcon, this.padding, this.trailing});
  final String title;
  final String? subtitle;
  final String? subtitle2;
  final Widget? icon;
  final void Function()? onPressed;
  final int? count;
  final Widget? fullIcon;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        // margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xffF8F8F8), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (fullIcon != null) fullIcon!,
            if (icon != null) CircleAvatar(backgroundColor: const Color(0xffF4F4F4), child: icon),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
                        ),
                        if (count != null && count! > 0)
                          TextSpan(
                            text: ' ($count)',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).primaryColor),
                          ),
                      ],
                    ),
                  ),
                  _getSubtitle!,
                ],
              ),
            ),
            if (trailing != null) trailing! else const Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }

  Widget? get _getSubtitle {
    if (subtitle == null) {
      return null;
    }

    if (subtitle2 == null) {
      return Text(
        subtitle ?? '',
        style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xff919195)),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          '$subtitle - $subtitle2',
          style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xff919195)),
        ),
        // const SizedBox(height: 2),
        // Text(
        //   subtitle2!,
        //   style: PrimaryTextStyle(
        //     fontWeight: FontWeight.w400,
        //     fontSize: 14,
        //     color: const Color(0xff919195),
        //   ),
        // ),
      ],
    );
  }
}
