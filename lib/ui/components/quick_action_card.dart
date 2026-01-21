import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import '../../data/models/user_response/activity_datum.dart';
import '../../data/models/user_response/user_response.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.action,
    required this.user,
    this.onPressed,
    this.useSecondVersion = false,
  });

  final ActivityDatum action;
  final UserResponse user;
  final void Function(ActivityDatum action)? onPressed;
  final bool useSecondVersion;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed != null ? onPressed!(action) : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(
        //     color: Colors.transparent,
        //     width: 1.5,
        //   ),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  '${user.imageBaseUrl}${user.imageDirectory}/${!useSecondVersion ? action.activity?.icon : action.activity?.customCss}',
              width: 50,
              placeholder: (context, url) =>
                  Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 50),
              errorWidget: (context, url, error) =>
                  Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 50),
            ),
            const SizedBox(height: 10),
            Text(
              action.activity?.activityName ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: PrimaryTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: const Color(0xff202020),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
