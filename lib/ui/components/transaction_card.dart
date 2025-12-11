import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/user_response/recent_activity.dart';
import '../../data/models/user_response/user_response.dart';
import '../../main.dart';
import '../../utils/service.util.dart';
import '../pages/dashboard/dashboard.page.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.recentActivity,
    required this.user,
  });

  final RecentActivity recentActivity;
  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ServiceUtil.onFavoritePressed(
        activity: recentActivity,
        context: context,
        routeName: DashboardPage.routeName,
      ),
      child: Container(
        width: (MediaQuery.of(MyApp.navigatorKey.currentContext!).size.width / 2) - 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(31),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: recentActivity.iconPath ?? '${user.imageBaseUrl}${user.imageDirectory}/${recentActivity.icon}',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: 32,
              ),
              width: 30,
              placeholder: (context, url) => CircleAvatar(
                radius: 32,
                child: Icon(
                  Icons.circle_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 32,
                child: Icon(
                  Icons.circle_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentActivity.formName ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    recentActivity.activityName ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}