part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class OnActivityToNotify extends ActivityState {}

class ActionJustPerformed extends ActivityState {}

class ActivityAlreadyAnnounced extends ActivityState {}