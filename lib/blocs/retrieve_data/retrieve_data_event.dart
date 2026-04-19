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
