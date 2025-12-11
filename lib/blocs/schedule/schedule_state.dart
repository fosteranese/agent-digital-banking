part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

// retrieve groups

class RetrievingSchedules extends ScheduleState {
  const RetrievingSchedules(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievingSchedules extends ScheduleState {
  const SilentRetrievingSchedules(this.routeName);

  final String? routeName;

  @override
  List<Object?> get props => [
        routeName,
      ];
}

class SchedulesRetrieved extends ScheduleState {
  const SchedulesRetrieved({
    required this.result,
    required this.routeName,
  });

  final Response<SchedulesData> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SchedulesRetrievedSilently extends ScheduleState {
  const SchedulesRetrievedSilently({
    required this.result,
    this.routeName,
  });
  final Response<SchedulesData> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

class RetrieveSchedulesError extends ScheduleState {
  const RetrieveSchedulesError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SilentRetrieveSchedulesError extends ScheduleState {
  const SilentRetrieveSchedulesError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// retrieve group members

class RetrievingScheduleMembers extends ScheduleState {
  const RetrievingScheduleMembers(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievingScheduleMembers extends ScheduleState {
  const SilentRetrievingScheduleMembers(this.routeName);

  final String? routeName;

  @override
  List<Object?> get props => [
        routeName,
      ];
}

class ScheduleMembersRetrieved extends ScheduleState {
  const ScheduleMembersRetrieved({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class ScheduleMembersRetrievedSilently extends ScheduleState {
  const ScheduleMembersRetrievedSilently({
    required this.result,
    this.routeName,
  });
  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

class RetrieveScheduleMembersError extends ScheduleState {
  const RetrieveScheduleMembersError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SilentRetrieveScheduleMembersError extends ScheduleState {
  const SilentRetrieveScheduleMembersError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// Add payees to group

class AddingPayeesToSchedule extends ScheduleState {
  const AddingPayeesToSchedule(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class PayeesAddedToSchedule extends ScheduleState {
  const PayeesAddedToSchedule({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class AddPayeesToScheduleError extends ScheduleState {
  const AddPayeesToScheduleError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// delete bulk payment group

class DeletingSchedule extends ScheduleState {
  const DeletingSchedule(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class ScheduleDeleted extends ScheduleState {
  const ScheduleDeleted({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class DeleteScheduleError extends ScheduleState {
  const DeleteScheduleError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// remove payee from bulk payment group

class RemovingPayeeFromSchedule extends ScheduleState {
  const RemovingPayeeFromSchedule(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class PayeeRemovedFromSchedule extends ScheduleState {
  const PayeeRemovedFromSchedule({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class RemovePayeeFromScheduleError extends ScheduleState {
  const RemovePayeeFromScheduleError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// make bulk payment

class MakingSchedule extends ScheduleState {
  const MakingSchedule(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class ScheduleMade extends ScheduleState {
  const ScheduleMade({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class MakeScheduleError extends ScheduleState {
  const MakeScheduleError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// Go to new

class MovingToNew extends ScheduleState {
  const MovingToNew();

  @override
  List<Object> get props => [];
}

class MovedToNew extends ScheduleState {
  const MovedToNew(this.list);

  final dynamic list;

  @override
  List<Object> get props => [
        list,
      ];
}

class MoveToNewError extends ScheduleState {
  const MoveToNewError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}

// add payee

class AddingSchedule extends ScheduleState {
  const AddingSchedule(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class ScheduleAdded extends ScheduleState {
  const ScheduleAdded({
    required this.result,
    required this.routeName,
  });
  final Response result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class AddScheduleError extends ScheduleState {
  const AddScheduleError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}