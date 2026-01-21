part of 'notification_bloc.dart';

abstract class PushNotificationState extends Equatable {
  const PushNotificationState();

  @override
  List<Object> get props => [];
}

class PushNotificationInitial extends PushNotificationState {}

class LoadingPushNotification extends PushNotificationState {
  const LoadingPushNotification();

  @override
  List<Object> get props => [];
}

class SilentLoadingPushNotification extends PushNotificationState {
  const SilentLoadingPushNotification();

  @override
  List<Object> get props => [];
}

class PushNotificationLoaded extends PushNotificationState {
  const PushNotificationLoaded(this.result);
  final List<PushNotification> result;

  @override
  List<Object> get props => [result];
}

class PushNotificationLoadedSilently extends PushNotificationState {
  const PushNotificationLoadedSilently({required this.result});
  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class LoadPushNotificationError extends PushNotificationState {
  const LoadPushNotificationError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class SilentLoadPushNotificationError extends PushNotificationState {
  const SilentLoadPushNotificationError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}
