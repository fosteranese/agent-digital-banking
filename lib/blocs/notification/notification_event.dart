part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadPushNotification extends NotificationEvent {
  const LoadPushNotification();

  @override
  List<Object> get props => [];
}

class ReceivePushNotification extends NotificationEvent {
  const ReceivePushNotification(this.notification);

  final PushNotification notification;

  @override
  List<Object?> get props => [
        notification,
      ];
}

class DeletePushNotification extends NotificationEvent {
  const DeletePushNotification(this.notification);

  final PushNotification notification;

  @override
  List<Object?> get props => [
        notification,
      ];
}

class ReadPushNotification extends NotificationEvent {
  const ReadPushNotification(this.notification);

  final PushNotification notification;

  @override
  List<Object?> get props => [
        notification,
      ];
}

class UnreadPushNotification extends NotificationEvent {
  const UnreadPushNotification(this.notification);

  final PushNotification notification;

  @override
  List<Object?> get props => [
        notification,
      ];
}