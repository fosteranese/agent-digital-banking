import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/models/push_notification.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/firebase_options.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/pages/notifications.page.dart';
import 'package:my_sage_agent/utils/messenger.util.dart';

/// Service for managing Firebase and push notifications.
///
/// Handles Firebase initialization, FCM token management, and notification display.
class NotificationService {
  static String? fcmToken;
  static Response deviceStatus = const Response(
    code: StatusConstants.pending,
    status: StatusConstants.pending,
    message: 'Checking Device compatibility status',
  );

  /// Initialize Firebase and set up FCM listeners.
  static Future<String?> initFirebase() async {
    final int text = 1;
    if (text == 1) {
      return '';
    }

    final info = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    info.setAutomaticDataCollectionEnabled(true);
    info.setAutomaticResourceManagementEnabled(true);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    final fcm = FirebaseMessaging.instance;
    try {
      final _ = await fcm.getAPNSToken();

      fcmToken = await fcm.getToken();
      await fcm.setAutoInitEnabled(true);
    } catch (ex) {
      logger.i(ex);
    }

    FirebaseMessaging.onMessage.listen((message) async {
      MyApp.navigatorKey.currentContext!.read<PushNotificationBloc>().add(
        ReceivePushNotification(
          PushNotification(
            id: message.messageId,
            title: message.notification?.title ?? '',
            content: message.notification?.body ?? '',
            customData: message.data,
            image: message.notification?.title,
            read: false,
            sentTime: DateTime.now(),
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final record = PushNotification(
        id: event.messageId,
        title: event.notification?.title ?? '',
        content: event.notification?.body ?? '',
        customData: event.data,
        image: event.notification?.title,
        read: true,
        sentTime: DateTime.now(),
      );
      MyApp.navigatorKey.currentContext!.read<PushNotificationBloc>().add(
        ReceivePushNotification(record),
      );

      showDetails(record, MyApp.navigatorKey.currentContext!);
    });

    logger.i('fcmToken: $fcmToken');

    return fcmToken;
  }

  /// Get the notification icon widget.
  static Widget get notificationIcon {
    return BlocBuilder<PushNotificationBloc, PushNotificationState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            context.push(PushNotificationsPage.routeName);
          },
          icon: const Icon(Icons.notifications_none_outlined),
        );
      },
    );
  }

  /// Display a push notification detail in a custom alert dialog.
  static void showDetails(PushNotification record, BuildContext context) {
    context.read<PushNotificationBloc>().add(ReadPushNotification(record));
    final formatter = DateFormat('dd MMM, yyyy HH:mm');

    final messenger = Messenger();
    messenger.customAlert(
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.title ?? '',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
          ),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xff919195)),
              const SizedBox(width: 5),
              Text(
                formatter.format(record.sentTime ?? DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(record.content ?? '', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 40),
          FormButton(
            text: 'Ok',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
