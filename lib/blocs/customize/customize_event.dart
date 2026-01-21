part of 'customize_bloc.dart';

abstract class CustomizeEvent extends Equatable {
  const CustomizeEvent();

  @override
  List<Object> get props => [];
}

class ToggleShowOnDashboardEvent extends CustomizeEvent {
  const ToggleShowOnDashboardEvent({required this.activityId, required this.status});
  final bool status;
  final String activityId;

  @override
  List<Object> get props => [activityId, status];
}
