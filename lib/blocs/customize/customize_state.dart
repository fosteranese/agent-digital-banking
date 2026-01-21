part of 'customize_bloc.dart';

abstract class CustomizeState extends Equatable {
  const CustomizeState();

  @override
  List<Object> get props => [];
}

class CustomizeInitial extends CustomizeState {}

class TogglingShowOnDashboard extends CustomizeState {
  const TogglingShowOnDashboard(this.activityId);

  final String activityId;

  @override
  List<Object> get props => [activityId];
}

class ShowOnDashboardToggled extends CustomizeState {
  const ShowOnDashboardToggled({required this.status, required this.activityId});

  final bool status;
  final String activityId;

  @override
  List<Object> get props => [status, activityId];
}

class ToggleShowOnDashboardError extends CustomizeState {
  const ToggleShowOnDashboardError(this.result);

  final Response<dynamic> result;
}
