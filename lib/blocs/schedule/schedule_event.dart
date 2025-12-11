part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

// retrieve groups

class RetrieveSchedules extends ScheduleEvent {
  const RetrieveSchedules(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrieveSchedules extends ScheduleEvent {
  const SilentRetrieveSchedules(this.routeName);

  final String? routeName;

  @override
  List<Object?> get props => [
        routeName,
      ];
}

// retrieve groups

class RetrieveScheduleMembers extends ScheduleEvent {
  const RetrieveScheduleMembers({
    required this.list,
    required this.routeName,
  });
  final dynamic list;
  final String routeName;

  @override
  List<Object> get props => [
        list,
        routeName,
      ];
}

class SilentRetrieveScheduleMembers extends ScheduleEvent {
  const SilentRetrieveScheduleMembers({
    required this.list,
    required this.routeName,
  });
  final dynamic list;
  final String routeName;

  @override
  List<Object> get props => [
        list,
        routeName,
      ];
}

// create groups

class AddPayeesToSchedule extends ScheduleEvent {
  const AddPayeesToSchedule({
    required this.list,
    required this.payees,
    required this.routeName,
  });
  final dynamic list;
  final List<String> payees;
  final String routeName;

  @override
  List<Object> get props => [
        list,
        payees,
        routeName,
      ];
}

// Go to new group

class GotoNew extends ScheduleEvent {
  const GotoNew();

  @override
  List<Object> get props => [];
}

// Delete Bulk Payment

class DeleteSchedule extends ScheduleEvent {
  const DeleteSchedule({
    required this.scheduleId,
    required this.routeName,
  });
  final String scheduleId;
  final String routeName;

  @override
  List<Object> get props => [
        scheduleId,
        routeName,
      ];
}

// Delete Bulk Payment

class RemovePayeeFromSchedule extends ScheduleEvent {
  const RemovePayeeFromSchedule({
    required this.list,
    required this.payee,
    required this.routeName,
  });
  final Schedules list;
  final Payees payee;
  final String routeName;

  @override
  List<Object> get props => [
        list,
        payee,
        routeName,
      ];
}

// make group Payment

class MakeSchedule extends ScheduleEvent {
  const MakeSchedule({
    required this.list,
    required this.pin,
    required this.routeName,
  });
  final dynamic list;
  final String pin;
  final String routeName;

  @override
  List<Object> get props => [
        list,
        pin,
        routeName,
      ];
}

// add payee

class AddSchedule extends ScheduleEvent {
  const AddSchedule({
    required this.routeName,
    required this.request,
    required this.payload,
    required this.schedulePayload,
  });

  final String routeName;
  final ProcessRequestModel request;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> schedulePayload;

  @override
  List<Object> get props => [
        routeName,
        request,
        payload,
        schedulePayload,
      ];
}