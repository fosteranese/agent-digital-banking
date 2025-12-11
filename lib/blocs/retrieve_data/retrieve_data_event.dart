part of 'retrieve_data_bloc.dart';

sealed class RetrieveDataEvent extends Equatable {
  final String id;
  final String? action;
  final bool skipSavedData;

  const RetrieveDataEvent({
    required this.id,
    this.action,
    this.skipSavedData = false,
  });

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
  List<Object?> get props => [
    id,
    action,
    skipSavedData,
    activityId,
    endpoint,
    activityType,
  ];
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
  List<Object?> get props => [
    id,
    action,
    skipSavedData,
    categoryId,
  ];
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
  });

  final dynamic form;
  final String? payeeId;
  final String? qrCode;
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
  List<Object?> get props => [
    id,
    action,
    skipSavedData,
    payeeId,
    receiptId,
  ];
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
  List<Object?> get props => [
    id,
    action,
    skipSavedData,
    form,
    enquiry,
  ];
}
