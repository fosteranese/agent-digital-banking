part of 'general_flow_bloc.dart';

abstract class GeneralFlowEvent extends Equatable {
  const GeneralFlowEvent();

  @override
  List<Object?> get props => [];
}

// retrieve payments

class RetrieveGeneralFlowCategories
    extends GeneralFlowEvent {
  const RetrieveGeneralFlowCategories({
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
  List<Object> get props => [
    activityId,
    endpoint,
    routeName,
    activityType,
  ];
}

class SilentRetrieveGeneralFlowCategories
    extends GeneralFlowEvent {
  const SilentRetrieveGeneralFlowCategories({
    required this.endpoint,
    this.activityType = ActivityTypesConst.fblOnline,
    this.routeName,
  });

  final String endpoint;
  final String activityType;
  final String? routeName;

  @override
  List<Object?> get props => [
    endpoint,
    activityType,
    routeName,
  ];
}

// retrieve payment categories

class RetrieveGeneralFlowFormData extends GeneralFlowEvent {
  const RetrieveGeneralFlowFormData({
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
  List<Object?> get props => [
    routeName,
    formId,
    activityType,
    qrCode,
    payeeId,
  ];
}

class SilentRetrieveGeneralFlowFormData
    extends GeneralFlowEvent {
  const SilentRetrieveGeneralFlowFormData({
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
  List<Object?> get props => [
    formId,
    qrCode,
    activityType,
    payeeId,
  ];
}

// verify request

class VerifyRequest extends GeneralFlowEvent {
  const VerifyRequest({
    required this.routeName,
    required this.formData,
    required this.payload,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final GeneralFlowFormData formData;
  final Map<String, dynamic> payload;
  final String activityType;

  @override
  List<Object> get props => [
    routeName,
    formData,
    payload,
    activityType,
  ];
}

// process request

class ProcessRequest extends GeneralFlowEvent {
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
  List<Object> get props => [
    routeName,
    request,
    payload,
    activityType,
  ];
}

// save Beneficiaries

class SaveBeneficiary extends GeneralFlowEvent {
  const SaveBeneficiary({
    required this.routeName,
    required this.payload,
    this.activityType = ActivityTypesConst.fblOnline,
  });

  final String routeName;
  final RequestResponse payload;
  final String activityType;

  @override
  List<Object> get props => [
    routeName,
    payload,
    activityType,
  ];
}

// enquire general flow

class GeneralFlowEnquiry extends GeneralFlowEvent {
  const GeneralFlowEnquiry({
    required this.routeName,
    required this.form,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final GeneralFlowForm form;
  final String activityType;

  @override
  List<Object> get props => [routeName, form, activityType];
}

class SilentGeneralFlowEnquiry extends GeneralFlowEvent {
  const SilentGeneralFlowEnquiry({
    required this.routeName,
    required this.endpoint,
    this.activityType = ActivityTypesConst.fblOnline,
  });
  final String routeName;
  final String endpoint;
  final String activityType;

  @override
  List<Object> get props => [
    routeName,
    endpoint,
    activityType,
  ];
}

class GeneralFlowSubEnquiry extends GeneralFlowEvent {
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
  List<Object> get props => [
    routeName,
    formId,
    hashValue,
    endpoint,
    activityType,
  ];
}

class SilentGeneralFlowSubEnquiry extends GeneralFlowEvent {
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
  List<Object> get props => [
    routeName,
    formId,
    hashValue,
    endpoint,
    activityType,
  ];
}

// prepare scheduler

class PrepareScheduler extends GeneralFlowEvent {
  const PrepareScheduler({
    required this.routeName,
    this.receiptId,
    this.payeeId,
  });

  final String routeName;
  final String? receiptId;
  final String? payeeId;

  @override
  List<Object?> get props => [
    routeName,
    receiptId,
    payeeId,
  ];
}
