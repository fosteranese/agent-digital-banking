import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class MyIcon extends StatelessWidget {
  const MyIcon({
    super.key,
    required this.icon,
    this.iconColor = ThemeUtil.primaryColor,
    this.iconBackgroundColor = ThemeUtil.highlight,
  });
  final String icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (icon.contains('http://') || icon.contains('https://')) {
          return CachedNetworkImage(
            imageUrl: icon,
            width: 33,
            height: 33,
            placeholder: (context, url) => CircleAvatar(
              radius: 16.5,
              backgroundColor: iconBackgroundColor ?? ThemeUtil.highlight,
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 16.5,
              backgroundColor: iconBackgroundColor ?? ThemeUtil.highlight,
            ),
          );
        } else if (icon.endsWith('.svg')) {
          return CircleAvatar(
            radius: 16.5,
            backgroundColor: iconBackgroundColor ?? ThemeUtil.highlight,
            child: SvgPicture.asset(
              icon,
              width: 18,
              colorFilter: ColorFilter.mode(iconColor ?? ThemeUtil.primaryColor, BlendMode.srcIn),
            ),
          );
        }

        return CircleAvatar(
          radius: 16.5,
          backgroundColor: iconBackgroundColor ?? ThemeUtil.highlight,
          child: Icon(Icons.circle_outlined, color: iconColor ?? ThemeUtil.primaryColor, size: 18),
        );
      },
    );
  }
}
