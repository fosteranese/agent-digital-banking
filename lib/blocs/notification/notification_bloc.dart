import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/push_notification.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/notification.repo.dart';
import '../../utils/response.util.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class PushNotificationBloc
    extends Bloc<NotificationEvent, PushNotificationState> {
  PushNotificationBloc()
    : super(PushNotificationInitial()) {
    on(_onLoadNotification);
    on(_onReceiveNotification);
    on(_onDeletePushNotification);
    on(_onReadPushNotification);
    on(_onUnreadPushNotification);
  }

  final _repo = PushNotificationRepo();

  Future<void> _onLoadNotification(
    LoadPushNotification event,
    Emitter<PushNotificationState> emit,
  ) async {
    try {
      if (state is! PushNotificationLoaded) {
        emit(const LoadingPushNotification());
      }

      final result = await _repo
          .getStoredPushNotification();

      emit(PushNotificationLoaded(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(LoadPushNotificationError(error)),
      );
    }
  }

  Future<void> _onReceiveNotification(
    ReceivePushNotification event,
    Emitter<PushNotificationState> emit,
  ) async {
    try {
      final result = await _repo.savePushNotification(
        event.notification,
      );
      emit(PushNotificationLoaded(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(LoadPushNotificationError(error)),
      );
    }
  }

  Future<void> _onDeletePushNotification(
    DeletePushNotification event,
    Emitter<PushNotificationState> emit,
  ) async {
    try {
      final result = await _repo.deletePushNotification(
        event.notification,
      );
      emit(PushNotificationLoaded(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(LoadPushNotificationError(error)),
      );
    }
  }

  Future<void> _onReadPushNotification(
    ReadPushNotification event,
    Emitter<PushNotificationState> emit,
  ) async {
    try {
      final result = await _repo.readPushNotification(
        event.notification,
      );
      emit(PushNotificationLoaded(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(LoadPushNotificationError(error)),
      );
    }
  }

  Future<void> _onUnreadPushNotification(
    UnreadPushNotification event,
    Emitter<PushNotificationState> emit,
  ) async {
    try {
      final result = await _repo.unreadPushNotification(
        event.notification,
      );
      emit(PushNotificationLoaded(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(LoadPushNotificationError(error)),
      );
    }
  }
}
