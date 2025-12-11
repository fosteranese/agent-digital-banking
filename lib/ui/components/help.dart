import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

import '../pages/help.page.dart';
import 'form/floating_button.dart';

enum HelpButton { side, main }

class Help extends StatelessWidget {
  const Help({super.key, this.button = HelpButton.side});
  final HelpButton button;

  @override
  Widget build(BuildContext context) {
    if (button == HelpButton.side) {
      return FloatingButton(
        onPressed: () => onPressed(context),
        label: 'Help',
      );
    }

    return IconButton(
      onPressed: () => onPressed(context),
      icon: const Icon(Icons.help_outline),
    );
  }

  static void onPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpPage(),
      ),
    );
    return;
  }
}

class HelpItem extends StatelessWidget {
  const HelpItem({
    super.key,
    this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onPressed,
    this.iconSvg,
  });

  final IconData? icon;
  final String? iconSvg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Navigator.pop(context);

        if (onPressed != null) {
          onPressed!();
        }
      },
      dense: false,
      contentPadding: EdgeInsets.symmetric(vertical: 2),
      leading: Container(
        alignment: Alignment.center,
        width: 42,
        height: 42,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: iconColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Builder(
          builder: (context) {
            if (iconSvg?.isNotEmpty ?? false) {
              return SvgPicture.asset(iconSvg!);
            }

            return Icon(
              icon,
              color: Colors.white,
              size: 16,
            );
          },
        ),
      ),
      title: Text(
        title,
        style: PrimaryTextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      trailing: const Icon(
        Icons.navigate_next,
        color: Color(0xff919195),
      ),
    );
  }
}
