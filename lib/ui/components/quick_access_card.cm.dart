import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class QuickAccessCard extends StatelessWidget {
  const QuickAccessCard({super.key, required this.title, required this.onTap, this.isPrimary = false, this.icon, this.img});

  final String title;
  final IconData? icon;
  final void Function() onTap;
  final bool isPrimary;
  final String? img;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xffF6F6F6), width: 1.33),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 20, color: isPrimary ? Color(0xffF8F8F8) : Colors.black),
            if (img != null)
              Builder(
                builder: (context) {
                  if (img?.isEmpty ?? true) {
                    return Icon(Icons.circle_outlined, color: isPrimary ? Color(0xffF8F8F8) : Colors.black);
                  }

                  if (img?.startsWith('http') ?? false) {
                    return CachedNetworkImage(
                      imageUrl: img!,
                      width: 20,
                      placeholder: (context, url) => Icon(Icons.circle_outlined, color: isPrimary ? Color(0xffF8F8F8) : Colors.black),
                      errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: isPrimary ? Color(0xffF8F8F8) : Colors.black, size: 20),
                    );
                  }

                  return Image.asset(img!, width: 20);
                },
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PrimaryTextStyle(fontSize: 13, color: isPrimary ? Color(0xffF8F8F8) : Colors.black, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
