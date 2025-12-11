import '../database/db.dart';
import '../models/push_notification.dart';

class PushNotificationRepo {
  final _db = Database();

  Future<List<PushNotification>>
  getStoredPushNotification() async {
    // _db.delete('notifications');

    final result = await _db.read('notifications');

    if (result == null || result['notifications'] == null) {
      return [];
    }

    final list = result['notifications'] as List<dynamic>;
    final notifications = list.map(
      (e) => PushNotification.fromMap(
        e as Map<String, dynamic>,
      ),
    );

    return notifications.toList();
  }

  Future<List<PushNotification>> savePushNotification(
    PushNotification notification,
  ) async {
    final list = await getStoredPushNotification();

    if (list.isEmpty) {
      list.add(notification);
    } else {
      list.insert(0, notification);
    }

    _save(list);
    return list;
  }

  Future<List<PushNotification>> deletePushNotification(
    PushNotification notification,
  ) async {
    final list = await getStoredPushNotification();

    if (list.isEmpty) {
      return [];
    }

    final records = list.where((e) {
      return e.id != notification.id;
    }).toList();

    _save(records);
    return records;
  }

  Future<List<PushNotification>> readPushNotification(
    PushNotification notification,
  ) async {
    final list = await getStoredPushNotification();

    if (list.isEmpty) {
      return [];
    }

    final records = list.map((e) {
      if (e.id == notification.id) {
        return e.copyWith(read: true);
      }

      return e;
    }).toList();

    _save(records);
    return records;
  }

  Future<List<PushNotification>> unreadPushNotification(
    PushNotification notification,
  ) async {
    final list = await getStoredPushNotification();

    if (list.isEmpty) {
      return [];
    }

    final records = list.map((e) {
      if (e.id == notification.id) {
        return e.copyWith(read: false);
      }

      return e;
    }).toList();

    _save(records);
    return records;
  }

  void _save(List<PushNotification> list) {
    final records = list.map((e) {
      return e.toMap();
    }).toList();

    _db.add(
      key: 'notifications',
      payload: {'notifications': records},
    );
  }
}
