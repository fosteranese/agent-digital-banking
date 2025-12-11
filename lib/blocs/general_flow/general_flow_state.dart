part of 'general_flow_bloc.dart';

abstract class GeneralFlowState extends Equatable {
  const GeneralFlowState();

  @override
  List<Object?> get props => [];
}

class GeneralFlowInitial extends GeneralFlowState {}

// retrieve payments

class RetrievingGeneralFlowCategories
    extends GeneralFlowState {
  const RetrievingGeneralFlowCategories({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class SilentRetrievingGeneralFlowCategories
    extends GeneralFlowState {
  const SilentRetrievingGeneralFlowCategories({
    required this.id,
    required this.activityType,
  });

  final String id;
  final String activityType;

  @override
  List<Object> get props => [id, activityType];
}

class GeneralFlowCategoriesRetrieved
    extends GeneralFlowState {
  const GeneralFlowCategoriesRetrieved({
    required this.fblOnlineCategories,
    required this.routeName,
    required this.activityType,
    required this.endpoint,
  });

  final Response<GeneralFlowCategory> fblOnlineCategories;
  final String routeName;
  final String activityType;
  final String endpoint;

  @override
  List<Object> get props => [
    fblOnlineCategories,
    routeName,
    activityType,
    endpoint,
  ];
}

class GeneralFlowCategoriesRetrievedSilently
    extends GeneralFlowState {
  const GeneralFlowCategoriesRetrievedSilently({
    required this.fblOnlineCategories,
    required this.activityType,
    this.routeName,
  });
  final Response<GeneralFlowCategory> fblOnlineCategories;
  final String activityType;
  final String? routeName;

  @override
  List<Object?> get props => [
    fblOnlineCategories,
    activityType,
    routeName,
  ];
}

class RetrieveGeneralFlowCategoriesError
    extends GeneralFlowState {
  const RetrieveGeneralFlowCategoriesError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

class SilentRetrieveGeneralFlowError
    extends GeneralFlowState {
  const SilentRetrieveGeneralFlowError({
    required this.result,
    required this.activityType,
    this.routeName,
  });

  final Response<dynamic> result;
  final String activityType;
  final String? routeName;

  @override
  List<Object?> get props => [
    result,
    activityType,
    routeName,
  ];
}

// retrieve form

class RetrievingGeneralFlowFormData
    extends GeneralFlowState {
  const RetrievingGeneralFlowFormData({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class RetrievingGeneralFlowFormDataSilently
    extends GeneralFlowState {
  const RetrievingGeneralFlowFormDataSilently(
    this.activityType,
  );

  final String activityType;

  @override
  List<Object> get props => [activityType];
}

class GeneralFlowFormDataRetrieved
    extends GeneralFlowState {
  const GeneralFlowFormDataRetrieved({
    required this.fblOnlineFormData,
    required this.routeName,
    required this.activityType,
  });
  final Response<GeneralFlowFormData> fblOnlineFormData;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    fblOnlineFormData,
    routeName,
    activityType,
  ];
}

class GeneralFlowFormDataRetrievedSilently
    extends GeneralFlowState {
  const GeneralFlowFormDataRetrievedSilently({
    required this.fblOnlineFormData,
    required this.activityType,
  });
  final Response<GeneralFlowFormData> fblOnlineFormData;
  final String activityType;

  @override
  List<Object> get props => [
    fblOnlineFormData,
    activityType,
  ];
}

class RetrieveGeneralFlowFormDataError
    extends GeneralFlowState {
  const RetrieveGeneralFlowFormDataError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

class SilentRetrieveGeneralFlowFormDataError
    extends GeneralFlowState {
  const SilentRetrieveGeneralFlowFormDataError({
    required this.result,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [result, activityType];
}

// verify request

class VerifyingRequest extends GeneralFlowState {
  const VerifyingRequest({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class RequestVerified extends GeneralFlowState {
  const RequestVerified({
    required this.result,
    required this.routeName,
    required this.payload,
    required this.formData,
    required this.activityType,
  });
  final Response<FormVerificationResponse> result;
  final String routeName;
  final Map<String, dynamic> payload;
  final dynamic formData;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    payload,
    formData,
    activityType,
  ];
}

class VerifyRequestError extends GeneralFlowState {
  const VerifyRequestError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

// make payment

class ProcessingRequest extends GeneralFlowState {
  const ProcessingRequest({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class RequestProcessed extends GeneralFlowState {
  const RequestProcessed({
    required this.result,
    required this.routeName,
    required this.activityType,
  });
  final Response<RequestResponse> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

class ProcessRequestError extends GeneralFlowState {
  const ProcessRequestError({
    required this.routeName,
    required this.result,
    required this.activityType,
  });

  final String routeName;
  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [
    routeName,
    result,
    activityType,
  ];
}

// save Beneficiaries

class SavingBeneficiary extends GeneralFlowState {
  const SavingBeneficiary({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class BeneficiarySaved extends GeneralFlowState {
  const BeneficiarySaved({
    required this.result,
    required this.routeName,
    required this.activityType,
  });
  final Response result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

class SaveBeneficiaryError extends GeneralFlowState {
  const SaveBeneficiaryError({
    required this.routeName,
    required this.result,
    required this.activityType,
  });

  final String routeName;
  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [
    routeName,
    result,
    activityType,
  ];
}

// enquire general flow
class EnquiringGeneralFlow extends GeneralFlowState {
  const EnquiringGeneralFlow({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class SilentEnquiringGeneralFlow extends GeneralFlowState {
  const SilentEnquiringGeneralFlow(this.activityType);

  final String activityType;

  @override
  List<Object> get props => [activityType];
}

class GeneralFlowEnquired extends GeneralFlowState {
  const GeneralFlowEnquired({
    required this.result,
    required this.routeName,
    required this.activityType,
    required this.endpoint,
    this.formId,
    this.hashValue,
  });
  final Response<Enquiry> result;
  final String routeName;
  final String activityType;
  final String endpoint;
  final String? formId;
  final String? hashValue;

  @override
  List<Object?> get props => [
    result,
    routeName,
    activityType,
    endpoint,
    formId,
    hashValue,
  ];
}

class GeneralFlowEnquiredSilently extends GeneralFlowState {
  const GeneralFlowEnquiredSilently({
    required this.result,
    required this.activityType,
    required this.endpoint,
    this.formId,
    this.hashValue,
  });
  final Response<dynamic> result;
  final String activityType;
  final String endpoint;
  final String? formId;
  final String? hashValue;

  @override
  List<Object?> get props => [
    result,
    activityType,
    endpoint,
    formId,
    hashValue,
  ];
}

class EnquireGeneralFlowError extends GeneralFlowState {
  const EnquireGeneralFlowError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

class SilentEnquireGeneralFlowError
    extends GeneralFlowState {
  const SilentEnquireGeneralFlowError({
    required this.result,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [result, activityType];
}

// schedule transaction

class PreparingScheduler extends GeneralFlowState {
  const PreparingScheduler({
    required this.routeName,
    required this.activityType,
  });
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class SchedulerPrepared extends GeneralFlowState {
  const SchedulerPrepared({
    required this.result,
    required this.routeName,
    required this.activityType,
  });
  final Response result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [
    result,
    routeName,
    activityType,
  ];
}

class PrepareSchedulerError extends GeneralFlowState {
  const PrepareSchedulerError({
    required this.routeName,
    required this.result,
    required this.activityType,
  });

  final String routeName;
  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [
    routeName,
    result,
    activityType,
  ];
}

class CompleteGhanaCardVerification
    extends GeneralFlowState {
  const CompleteGhanaCardVerification({
    required this.data,
    required this.id,
    required this.event,
  });

  final VerificationResponse data;
  final String id;
  final VerifyRequest event;

  @override
  List<Object> get props => [data, id, event];
}
