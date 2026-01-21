part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class PerformActivityEvent extends ActivityEvent {
  @override
  List<Object> get props => [];
}
