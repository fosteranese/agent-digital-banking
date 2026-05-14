part of 'retrieve_data_bloc.dart';

sealed class RetrieveDataEvent extends Equatable {
  final String id;
  final String? action;
  final bool skipSavedData;

  const RetrieveDataEvent({required this.id, this.action, this.skipSavedData = false});

  @override
  List<Object?> get props => [id, action, skipSavedData];
}

class RetrieveCategories extends RetrieveDataEvent {
  const RetrieveCategories({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.activityId,
    required this.endpoint,
    required this.activityType,
  });

  final String activityId;
  final String endpoint;
  final String activityType;

  @override
  List<Object?> get props => [id, action, skipSavedData, activityId, endpoint, activityType];
}

class RetrievePaymentCategories extends RetrieveDataEvent {
  const RetrievePaymentCategories({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.categoryId,
  });

  final String categoryId;

  @override
  List<Object?> get props => [id, action, skipSavedData, categoryId];
}

class RetrieveForm extends RetrieveDataEvent {
  const RetrieveForm({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.form,
    required this.activity,
    this.payeeId,
    this.qrCode,
    this.collectionId,
  });

  final dynamic form;
  final String? payeeId;
  final String? qrCode;
  final String? collectionId;
  final ActivityDatum activity;

  @override
  List<Object?> get props => [
    id,
    action,
    skipSavedData,
    form,
    activity,
    payeeId,
    qrCode,
    collectionId,
  ];
}

class RetrieveScheduleForm extends RetrieveDataEvent {
  const RetrieveScheduleForm({
    required super.id,
    required super.action,
    required super.skipSavedData,
    this.payeeId,
    this.receiptId,
  });

  final String? payeeId;
  final String? receiptId;

  @override
  List<Object?> get props => [id, action, skipSavedData, payeeId, receiptId];
}

class RetrieveEnquiry extends RetrieveDataEvent {
  const RetrieveEnquiry({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.form,
    this.enquiry,
  });

  final Enquiry? enquiry;
  final GeneralFlowForm form;

  @override
  List<Object?> get props => [id, action, skipSavedData, form, enquiry];
}

class RetrieveActivitiesEvent extends RetrieveDataEvent {
  const RetrieveActivitiesEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    this.activity,
    this.dateFrom,
    this.dateTo,
  });

  final Activity? activity;
  final String? dateFrom;
  final String? dateTo;

  @override
  List<Object?> get props => [id, action, skipSavedData, activity, dateFrom, dateTo];
}

class RetrieveCollectionEvent extends RetrieveDataEvent {
  const RetrieveCollectionEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
  });

  @override
  List<Object?> get props => [id, action, skipSavedData];
}

class RetrieveSupervisorCollectionSummaryEvent extends RetrieveDataEvent {
  const RetrieveSupervisorCollectionSummaryEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
  });

  @override
  List<Object?> get props => [id, action, skipSavedData];
}

class RetrieveCommissionsEvent extends RetrieveDataEvent {
  const RetrieveCommissionsEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    this.dateFrom,
    this.dateTo,
  });
  final String? dateFrom;
  final String? dateTo;

  @override
  List<Object?> get props => [id, action, skipSavedData, dateFrom, dateTo];
}

class RetrieveTeamMembersEvent extends RetrieveDataEvent {
  const RetrieveTeamMembersEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    this.name,
    this.code,
  });
  final String? name;
  final String? code;

  @override
  List<Object?> get props => [id, action, skipSavedData, name, code];
}

class RetrievePendingReversalsEvent extends RetrieveDataEvent {
  const RetrievePendingReversalsEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
  });

  @override
  List<Object?> get props => [id, action, skipSavedData];
}

class RetrieveSupervisorAgentCollectionsEvent extends RetrieveDataEvent {
  const RetrieveSupervisorAgentCollectionsEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.agentCode,
    this.startDate,
    this.endDate,
  });

  final String agentCode;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id, action, skipSavedData, agentCode, startDate, endDate];
}

class RetrieveSupervisorAgentActivitiesEvent extends RetrieveDataEvent {
  const RetrieveSupervisorAgentActivitiesEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.agentCode,
    this.startDate,
    this.endDate,
  });

  final String agentCode;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id, action, skipSavedData, agentCode, startDate, endDate];
}

class RetrieveSupervisorAgentReversalsEvent extends RetrieveDataEvent {
  const RetrieveSupervisorAgentReversalsEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.agentCode,
    this.startDate,
    this.endDate,
  });

  final String agentCode;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id, action, skipSavedData, agentCode, startDate, endDate];
}

class RetrieveSupervisorReversalsEvent extends RetrieveDataEvent {
  const RetrieveSupervisorReversalsEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    this.startDate,
    this.endDate,
  });

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id, action, skipSavedData, startDate, endDate];
}

class RetrieveSupervisorAgentCommissionsEvent extends RetrieveDataEvent {
  const RetrieveSupervisorAgentCommissionsEvent({
    required super.id,
    required super.action,
    required super.skipSavedData,
    required this.agentCode,
    this.startDate,
    this.endDate,
  });

  final String agentCode;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id, action, skipSavedData, agentCode, startDate, endDate];
}

final class RetrieveLocationFromLatLng extends RetrieveDataEvent {
  const RetrieveLocationFromLatLng({
    super.action,
    required super.id,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [id, action, latitude, longitude];
}

final class RetrievePlaces extends RetrieveDataEvent {
  const RetrievePlaces({
    super.action,
    required super.id,
    required this.latitude,
    required this.longitude,
    required this.search,
  });

  final double latitude;
  final double longitude;
  final String search;

  @override
  List<Object?> get props => [id, action, latitude, longitude, search];
}

final class RetrievePlaceDetails extends RetrieveDataEvent {
  const RetrievePlaceDetails({super.action, required super.id, required this.placeId});

  final String placeId;

  @override
  List<Object?> get props => [id, action, placeId];
}
