part of 'process_flow_bloc.dart';

abstract class ProcessFlowState extends Equatable {
  const ProcessFlowState();

  @override
  List<Object?> get props => [];
}

class GeneralFlowInitial extends ProcessFlowState {}

// retrieve payments

class RetrievingProcessFlowCategories extends ProcessFlowState {
  const RetrievingProcessFlowCategories({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class SilentRetrievingProcessFlowCategories extends ProcessFlowState {
  const SilentRetrievingProcessFlowCategories({required this.id, required this.activityType});

  final String id;
  final String activityType;

  @override
  List<Object> get props => [id, activityType];
}

class ProcessFlowCategoriesRetrieved extends ProcessFlowState {
  const ProcessFlowCategoriesRetrieved({
    required this.fblOnlineCategories,
    required this.routeName,
    required this.activityType,
    required this.endpoint,
  });

  final Response<ProcessFlowCategory> fblOnlineCategories;
  final String routeName;
  final String activityType;
  final String endpoint;

  @override
  List<Object> get props => [fblOnlineCategories, routeName, activityType, endpoint];
}

class ProcessFlowCategoriesRetrievedSilently extends ProcessFlowState {
  const ProcessFlowCategoriesRetrievedSilently({
    required this.fblOnlineCategories,
    required this.activityType,
    this.routeName,
  });
  final Response<ProcessFlowCategory> fblOnlineCategories;
  final String activityType;
  final String? routeName;

  @override
  List<Object?> get props => [fblOnlineCategories, activityType, routeName];
}

class RetrieveProcessFlowCategoriesError extends ProcessFlowState {
  const RetrieveProcessFlowCategoriesError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

class SilentRetrieveProcessFlowError extends ProcessFlowState {
  const SilentRetrieveProcessFlowError({
    required this.result,
    required this.activityType,
    this.routeName,
  });

  final Response<dynamic> result;
  final String activityType;
  final String? routeName;

  @override
  List<Object?> get props => [result, activityType, routeName];
}

// retrieve form

class RetrievingProcessFlowFormData extends ProcessFlowState {
  const RetrievingProcessFlowFormData({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class RetrievingProcessFlowFormDataSilently extends ProcessFlowState {
  const RetrievingProcessFlowFormDataSilently(this.activityType);

  final String activityType;

  @override
  List<Object> get props => [activityType];
}

class ProcessFlowFormDataRetrieved extends ProcessFlowState {
  const ProcessFlowFormDataRetrieved({
    required this.fblOnlineFormData,
    required this.routeName,
    required this.activityType,
  });
  final Response<ProcessFlowFormData> fblOnlineFormData;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [fblOnlineFormData, routeName, activityType];
}

class ProcessFlowFormDataRetrievedSilently extends ProcessFlowState {
  const ProcessFlowFormDataRetrievedSilently({
    required this.fblOnlineFormData,
    required this.activityType,
  });
  final Response<ProcessFlowFormData> fblOnlineFormData;
  final String activityType;

  @override
  List<Object> get props => [fblOnlineFormData, activityType];
}

class RetrieveProcessFlowFormDataError extends ProcessFlowState {
  const RetrieveProcessFlowFormDataError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

class SilentRetrieveProcessFlowFormDataError extends ProcessFlowState {
  const SilentRetrieveProcessFlowFormDataError({required this.result, required this.activityType});

  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [result, activityType];
}

// verify request

class VerifyingRequest extends ProcessFlowState {
  const VerifyingRequest({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class RequestVerified extends ProcessFlowState {
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
  List<Object> get props => [result, routeName, payload, formData, activityType];
}

class VerifyRequestError extends ProcessFlowState {
  const VerifyRequestError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

// make payment

class ProcessingRequest extends ProcessFlowState {
  const ProcessingRequest({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class RequestProcessed extends ProcessFlowState {
  const RequestProcessed({
    required this.result,
    required this.routeName,
    required this.activityType,
  });
  final Response<RequestResponse> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

class ProcessRequestError extends ProcessFlowState {
  const ProcessRequestError({
    required this.routeName,
    required this.result,
    required this.activityType,
  });

  final String routeName;
  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [routeName, result, activityType];
}

// save Beneficiaries

class SavingBeneficiary extends ProcessFlowState {
  const SavingBeneficiary({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class BeneficiarySaved extends ProcessFlowState {
  const BeneficiarySaved({
    required this.result,
    required this.routeName,
    required this.activityType,
  });
  final Response result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

class SaveBeneficiaryError extends ProcessFlowState {
  const SaveBeneficiaryError({
    required this.routeName,
    required this.result,
    required this.activityType,
  });

  final String routeName;
  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [routeName, result, activityType];
}

// enquire general flow
class EnquiringGeneralFlow extends ProcessFlowState {
  const EnquiringGeneralFlow({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class SilentEnquiringGeneralFlow extends ProcessFlowState {
  const SilentEnquiringGeneralFlow(this.activityType);

  final String activityType;

  @override
  List<Object> get props => [activityType];
}

class GeneralFlowEnquired extends ProcessFlowState {
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
  List<Object?> get props => [result, routeName, activityType, endpoint, formId, hashValue];
}

class GeneralFlowEnquiredSilently extends ProcessFlowState {
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
  List<Object?> get props => [result, activityType, endpoint, formId, hashValue];
}

class EnquireGeneralFlowError extends ProcessFlowState {
  const EnquireGeneralFlowError({
    required this.result,
    required this.routeName,
    required this.activityType,
  });

  final Response<dynamic> result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

class SilentEnquireGeneralFlowError extends ProcessFlowState {
  const SilentEnquireGeneralFlowError({required this.result, required this.activityType});

  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [result, activityType];
}

// schedule transaction

class PreparingScheduler extends ProcessFlowState {
  const PreparingScheduler({required this.routeName, required this.activityType});
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [routeName, activityType];
}

class SchedulerPrepared extends ProcessFlowState {
  const SchedulerPrepared({
    required this.result,
    required this.routeName,
    required this.activityType,
  });
  final Response result;
  final String routeName;
  final String activityType;

  @override
  List<Object> get props => [result, routeName, activityType];
}

class PrepareSchedulerError extends ProcessFlowState {
  const PrepareSchedulerError({
    required this.routeName,
    required this.result,
    required this.activityType,
  });

  final String routeName;
  final Response<dynamic> result;
  final String activityType;

  @override
  List<Object> get props => [routeName, result, activityType];
}

class CompleteGhanaCardVerification extends ProcessFlowState {
  const CompleteGhanaCardVerification({required this.data, required this.id, required this.event});

  final VerificationResponse data;
  final String id;
  final VerifyRequest event;

  @override
  List<Object> get props => [data, id, event];
}

class ApprovingReversalRequest extends ProcessFlowState {
  const ApprovingReversalRequest({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class ReversalRequestApproved extends ProcessFlowState {
  const ReversalRequestApproved({required this.id, required this.result});

  final String id;
  final Response result;

  @override
  List<Object> get props => [id, result];
}

class ReversalRequestDeclined extends ProcessFlowState {
  const ReversalRequestDeclined({required this.id, required this.result});

  final String id;
  final Response result;

  @override
  List<Object> get props => [id, result];
}

class ApproveReversalRequestError extends ProcessFlowState {
  const ApproveReversalRequestError({required this.id, required this.error});

  final String id;
  final Response error;

  @override
  List<Object> get props => [id, error];
}
