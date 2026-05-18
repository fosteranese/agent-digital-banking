part of 'process_flow_bloc.dart';

abstract class ProcessFlowEvent extends Equatable {
  const ProcessFlowEvent();

  @override
  List<Object?> get props => [];
}

// retrieve payments

class RetrieveProcessFlowCategories extends ProcessFlowEvent {
  const RetrieveProcessFlowCategories({
    required this.activityId,
    required this.endpoint,
    required this.routeName,
    this.activityType = ActivityTypesConst.fblOnline,
  });

  final String activityId;
  final String endpoint;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [activityId, endpoint, routeName, activityType];
}

class SilentRetrieveProcessFlowCategories extends ProcessFlowEvent {
  const SilentRetrieveProcessFlowCategories({
    required this.endpoint,
    this.activityType = ActivityTypesConst.fblOnline,
    this.routeName,
  });

  final String endpoint;
  final String activityType;
  final String? routeName;

  @override
  List<Object?> get props => [endpoint, activityType, routeName];
}

// retrieve payment categories

class RetrieveProcessFlowFormData extends ProcessFlowEvent {
  const RetrieveProcessFlowFormData({
    required this.routeName,
    required this.formId,
    this.activityType = ActivityTypesConst.fblOnline,
    this.qrCode,
    this.payeeId,
  });
  final String routeName;
  final String formId;
  final String? qrCode;
  final String activityType;
  final String? payeeId;

  @override
  List<Object?> get props => [routeName, formId, activityType, qrCode, payeeId];
}

class SilentRetrieveProcessFlowFormData extends ProcessFlowEvent {
  const SilentRetrieveProcessFlowFormData({
    required this.formId,
    this.activityType = ActivityTypesConst.fblOnline,
    this.qrCode,
    this.payeeId,
  });
  final String formId;
  final String? qrCode;
  final String activityType;
  final String? payeeId;

  @override
  List<Object?> get props => [formId, qrCode, activityType, payeeId];
}

// verify request

class VerifyRequest extends ProcessFlowEvent {
  const VerifyRequest({
    required this.routeName,
    required this.formData,
    required this.payload,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final ProcessFlowFormData formData;
  final Map<String, dynamic> payload;
  final String activityType;

  @override
  List<Object> get props => [routeName, formData, payload, activityType];
}

// process request

class ProcessRequest extends ProcessFlowEvent {
  const ProcessRequest({
    required this.routeName,
    required this.request,
    required this.payload,
    this.activityType = ActivityTypesConst.fblOnline,
  });

  final String routeName;
  final ProcessRequestModel request;
  final Map<String, dynamic> payload;
  final String activityType;

  @override
  List<Object> get props => [routeName, request, payload, activityType];
}

// save Beneficiaries

class SaveBeneficiary extends ProcessFlowEvent {
  const SaveBeneficiary({
    required this.routeName,
    required this.payload,
    this.activityType = ActivityTypesConst.fblOnline,
  });

  final String routeName;
  final RequestResponse payload;
  final String activityType;

  @override
  List<Object> get props => [routeName, payload, activityType];
}

// enquire general flow

class GeneralFlowEnquiry extends ProcessFlowEvent {
  const GeneralFlowEnquiry({
    required this.routeName,
    required this.form,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final ProcessFlowFormModel form;
  final String activityType;

  @override
  List<Object> get props => [routeName, form, activityType];
}

class SilentGeneralFlowEnquiry extends ProcessFlowEvent {
  const SilentGeneralFlowEnquiry({
    required this.routeName,
    required this.endpoint,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final String endpoint;
  final String activityType;

  @override
  List<Object> get props => [routeName, endpoint, activityType];
}

class GeneralFlowSubEnquiry extends ProcessFlowEvent {
  const GeneralFlowSubEnquiry({
    required this.routeName,
    required this.formId,
    required this.hashValue,
    required this.endpoint,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final String formId;
  final String hashValue;
  final String endpoint;
  final String activityType;

  @override
  List<Object> get props => [routeName, formId, hashValue, endpoint, activityType];
}

class SilentGeneralFlowSubEnquiry extends ProcessFlowEvent {
  const SilentGeneralFlowSubEnquiry({
    required this.routeName,
    required this.formId,
    required this.hashValue,
    required this.endpoint,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final String formId;
  final String hashValue;
  final String endpoint;
  final String activityType;

  @override
  List<Object> get props => [routeName, formId, hashValue, endpoint, activityType];
}

// prepare scheduler

class PrepareScheduler extends ProcessFlowEvent {
  const PrepareScheduler({required this.routeName, this.receiptId, this.payeeId});

  final String routeName;
  final String? receiptId;
  final String? payeeId;

  @override
  List<Object?> get props => [routeName, receiptId, payeeId];
}

// prepare scheduler

class ApproveReversalRequestEvent extends ProcessFlowEvent {
  const ApproveReversalRequestEvent({
    required this.id,
    required this.pin,
    required this.requestId,
    required this.comment,
    required this.username,
    required this.status,
  });

  final String id;
  final String pin;
  final String username;
  final String requestId;
  final String comment;
  final int status;

  @override
  List<Object?> get props => [id, pin, username, requestId, comment, status];
}
