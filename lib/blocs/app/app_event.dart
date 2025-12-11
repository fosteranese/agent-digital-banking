part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class DeviceStatusCheckEvent extends AppEvent {
  @override
  List<Object> get props => [];
}

class CheckDeviceSecurityEvent extends AppEvent {
  @override
  List<Object> get props => [];
}

class SilentDeviceCheckEvent extends AppEvent {
  @override
  List<Object> get props => [];
}

class RaiseSecurityThreadEvent extends AppEvent {
  const RaiseSecurityThreadEvent(this.error);

  final Response<dynamic> error;

  @override
  List<Object> get props => [
        error,
      ];
}

class SetScheduleStatusEvent extends AppEvent {
  const SetScheduleStatusEvent(this.status);

  final bool status;

  @override
  List<Object> get props => [
        status,
      ];
}