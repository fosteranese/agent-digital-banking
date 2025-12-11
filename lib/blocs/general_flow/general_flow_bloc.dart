import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/constants/status.const.dart';
import 'package:agent_digital_banking/data/models/collection/form_verification_response.dart';
import 'package:agent_digital_banking/data/models/enquiry.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_category.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form_data.dart';
import 'package:agent_digital_banking/data/models/process_request.model.dart';
import 'package:agent_digital_banking/data/models/request_response.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/verification.response.dart';
import 'package:agent_digital_banking/data/repository/fbl_online.repo.dart';
import 'package:agent_digital_banking/data/repository/payment.repo.dart';
import 'package:agent_digital_banking/data/repository/quickflow.repo.dart';
import 'package:agent_digital_banking/utils/response.util.dart';

part 'general_flow_event.dart';
part 'general_flow_state.dart';

class GeneralFlowBloc extends Bloc<GeneralFlowEvent, GeneralFlowState> {
  GeneralFlowBloc() : super(GeneralFlowInitial()) {
    on(_onRetrieveGeneralFlow);
    on(_onSilentRetrieveGeneralFlow);
    on(_onRetrieveGeneralFlowFormData);
    on(_onSilentRetrieveGeneralFlowFormData);

    on(_onVerifyRequest);
    on(_onProcessRequest);
    on(_onSaveBeneficiary);
    on(_onPrepareScheduler);

    on(_onEnquiryGeneralFlow);
    on(_onSilentEnquiryFlow);
    on(_onSubEnquiryGeneralFlow);
    on(_onSilentSubEnquiryFlow);
  }

  final _fblOnlineRepo = FblOnlineRepo();
  final _quickflow = QuickFlowRepo();
  final _paymentRepo = PaymentRepo();
  Response<GeneralFlowCategory> fblOnlineCategories = const Response(code: '', status: '', message: '', data: null);
  Map<String, Response<GeneralFlowCategory>> fblOnlineCategoriesMap = {};
  Response<GeneralFlowFormData> fblOnlineForms = const Response(code: '', status: '', message: '', data: null);
  Map<String, Response<GeneralFlowFormData>> fblOnlineFormsMap = {};
  Response<Enquiry> enquiry = const Response(code: '', status: '', message: '', data: null);
  Map<String, Response<Enquiry>> enquiryMap = {};
  String activityId = '';

  Future<void> _onRetrieveGeneralFlow(RetrieveGeneralFlowCategories event, Emitter<GeneralFlowState> emit) async {
    Response<GeneralFlowCategory>? stored;
    activityId = event.activityId;
    try {
      emit(RetrievingGeneralFlowCategories(routeName: event.routeName, activityType: event.activityType));
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          stored = await _fblOnlineRepo.getStoredCategories(event.endpoint);
          break;
        case ActivityTypesConst.quickFlow:
          stored = await _quickflow.getStoredCategories(event.endpoint);
          break;
      }

      if (stored != null && (stored.data?.forms?.isNotEmpty ?? false)) {
        fblOnlineCategoriesMap[event.endpoint] = stored;
        fblOnlineCategories = stored;
        emit(GeneralFlowCategoriesRetrieved(fblOnlineCategories: fblOnlineCategories, routeName: event.routeName, activityType: event.activityType, endpoint: event.endpoint));

        emit(SilentRetrievingGeneralFlowCategories(id: event.routeName, activityType: event.activityType));
      } else if (fblOnlineCategoriesMap[event.endpoint] != null) {
        fblOnlineCategories = fblOnlineCategoriesMap[event.endpoint]!;

        emit(SilentRetrievingGeneralFlowCategories(id: event.routeName, activityType: event.activityType));
      }

      late Response<GeneralFlowCategory> result;
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          result = await _fblOnlineRepo.retrieveCategories(event.endpoint);
          break;
        case ActivityTypesConst.quickFlow:
          result = await _quickflow.retrieveCategories(event.endpoint);
          break;
      }

      fblOnlineCategoriesMap[event.endpoint] = result;
      fblOnlineCategories = result;

      if ((result.data?.forms?.isEmpty ?? true) || (result.data?.category == null)) {
        emit(
          RetrieveGeneralFlowCategoriesError(
            result: const Response(code: StatusConstants.error, status: StatusConstants.error, message: "This service is currently not available"),
            routeName: event.routeName,
            activityType: event.activityType,
          ),
        );
        return;
      }

      if (stored == null || (stored.data?.forms?.isEmpty ?? false)) {
        emit(GeneralFlowCategoriesRetrieved(fblOnlineCategories: result, routeName: event.routeName, activityType: event.activityType, endpoint: event.endpoint));
      } else {
        emit(GeneralFlowCategoriesRetrievedSilently(fblOnlineCategories: result, activityType: event.activityType, routeName: event.routeName));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.forms?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(RetrieveGeneralFlowCategoriesError(result: error, routeName: event.routeName, activityType: event.activityType)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveGeneralFlowError(result: error, activityType: event.activityType)));
      }
    }
  }

  Future<void> _onSilentRetrieveGeneralFlow(SilentRetrieveGeneralFlowCategories event, Emitter<GeneralFlowState> emit) async {
    try {
      emit(SilentRetrievingGeneralFlowCategories(activityType: event.activityType, id: event.routeName ?? ''));
      late Response<GeneralFlowCategory> result;
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          result = await _fblOnlineRepo.retrieveCategories(event.endpoint);
          break;
        case ActivityTypesConst.quickFlow:
          result = await _quickflow.retrieveCategories(event.endpoint);
          break;
      }
      fblOnlineCategories = result;
      emit(GeneralFlowCategoriesRetrievedSilently(fblOnlineCategories: result, activityType: event.activityType, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveGeneralFlowError(result: error, activityType: event.activityType)));
    }
  }

  Future<void> _onRetrieveGeneralFlowFormData(RetrieveGeneralFlowFormData event, Emitter<GeneralFlowState> emit) async {
    Response<GeneralFlowFormData>? stored;
    try {
      emit(RetrievingGeneralFlowFormData(routeName: event.routeName, activityType: event.activityType));
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          stored = await _fblOnlineRepo.getStoredFormData(id: event.formId, qrCode: event.qrCode, payeeId: event.payeeId);
          break;
        case ActivityTypesConst.quickFlow:
          stored = await _quickflow.getStoredFormData(id: event.formId, qrCode: event.qrCode, payeeId: event.payeeId);
          break;
      }

      if (stored != null && (stored.data?.fieldsDatum?.isNotEmpty ?? false)) {
        fblOnlineFormsMap[event.formId] = stored;
        fblOnlineForms = stored;
        emit(GeneralFlowFormDataRetrieved(fblOnlineFormData: fblOnlineForms, routeName: event.routeName, activityType: event.activityType));

        emit(RetrievingGeneralFlowFormDataSilently(event.activityType));
      } else if (fblOnlineFormsMap[event.formId] != null) {
        fblOnlineForms = fblOnlineFormsMap[event.formId]!;
      }

      late Response<GeneralFlowFormData> result;
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          result = await _fblOnlineRepo.retrieveFormData(id: event.formId, qrCode: event.qrCode, payeeId: event.payeeId);
          break;
        case ActivityTypesConst.quickFlow:
          result = await _quickflow.retrieveFormData(id: event.formId, qrCode: event.qrCode, payeeId: event.payeeId);
          break;
      }

      if (result.data?.fieldsDatum?.isNotEmpty ?? false) {
        fblOnlineFormsMap[event.formId] = result;
        fblOnlineForms = result;
      } else if (fblOnlineFormsMap[event.formId] != null) {
        fblOnlineForms = fblOnlineFormsMap[event.formId]!;
      } else {
        fblOnlineForms = result;
      }

      if (stored == null || (stored.data?.fieldsDatum?.isEmpty ?? false)) {
        emit(GeneralFlowFormDataRetrieved(fblOnlineFormData: fblOnlineForms, routeName: event.routeName, activityType: event.activityType));
      } else {
        emit(GeneralFlowFormDataRetrievedSilently(fblOnlineFormData: fblOnlineForms, activityType: event.activityType));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.fieldsDatum?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(RetrieveGeneralFlowFormDataError(result: error, routeName: event.routeName, activityType: event.activityType)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveGeneralFlowFormDataError(result: error, activityType: event.activityType)));
      }
    }
  }

  Future<void> _onSilentRetrieveGeneralFlowFormData(SilentRetrieveGeneralFlowFormData event, Emitter<GeneralFlowState> emit) async {
    try {
      emit(RetrievingGeneralFlowFormDataSilently(event.activityType));
      late Response<GeneralFlowFormData> result;
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          result = await _fblOnlineRepo.retrieveFormData(id: event.formId, qrCode: event.qrCode, payeeId: event.payeeId);
          break;
        case ActivityTypesConst.quickFlow:
          result = await _quickflow.retrieveFormData(id: event.formId, qrCode: event.qrCode, payeeId: event.payeeId);
          break;
      }

      fblOnlineForms = result;
      emit(GeneralFlowFormDataRetrievedSilently(fblOnlineFormData: result, activityType: event.activityType));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveGeneralFlowFormDataError(result: error, activityType: event.activityType)));
    }
  }

  Future<void> _onVerifyRequest(VerifyRequest event, Emitter<GeneralFlowState> emit) async {
    Response<FormVerificationResponse>? stored;
    try {
      emit(VerifyingRequest(routeName: event.routeName, activityType: event.activityType));

      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          stored = await _fblOnlineRepo.verifyRequest(formData: event.formData, payload: event.payload);
          break;
        case ActivityTypesConst.quickFlow:
          stored = await _quickflow.verifyRequest(formData: event.formData, payload: event.payload);
          break;
        case ActivityTypesConst.fblCollect:
        case ActivityTypesConst.fblCollectCategory:
          stored = await _paymentRepo.verifyForm(formData: event.formData, payload: event.payload);
          break;
      }

      emit(RequestVerified(result: stored!, routeName: event.routeName, formData: event.formData, payload: event.payload, activityType: event.activityType));
    } catch (ex) {
      if ((ex is Response && ex.code == '2000') || (ex is Response<dynamic> && ex.code == '2000')) {
        final data = VerificationResponse.fromMap(ex.data as Map<String, dynamic>);
        emit(CompleteGhanaCardVerification(id: event.routeName, data: data, event: event));
        return;
      }

      ResponseUtil.handleException(ex, (error) => emit(VerifyRequestError(result: error, routeName: event.routeName, activityType: event.activityType)));
    }
  }

  Future<void> _onProcessRequest(ProcessRequest event, Emitter<GeneralFlowState> emit) async {
    try {
      emit(ProcessingRequest(routeName: event.routeName, activityType: event.activityType));
      late Response<RequestResponse> stored;
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          stored = await _fblOnlineRepo.processRequest(request: event.request, payload: event.payload);
          break;
        case ActivityTypesConst.quickFlow:
          stored = await _quickflow.processRequest(request: event.request, payload: event.payload);
          break;
        case ActivityTypesConst.fblCollect:
        case ActivityTypesConst.fblCollectCategory:
          stored = await _paymentRepo.makePayment(payment: event.request, payload: event.payload);
          break;
      }

      emit(RequestProcessed(result: stored, routeName: event.routeName, activityType: event.activityType));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(ProcessRequestError(result: error, routeName: event.routeName, activityType: event.activityType)));
    }
  }

  Future<void> _onSaveBeneficiary(SaveBeneficiary event, Emitter<GeneralFlowState> emit) async {
    try {
      emit(SavingBeneficiary(routeName: event.routeName, activityType: event.activityType));

      late Response stored;
      switch (event.activityType) {
        case ActivityTypesConst.fblOnline:
          stored = await _fblOnlineRepo.saveBeneficiary(event.payload);
          break;
        case ActivityTypesConst.quickFlow:
          stored = await _quickflow.saveBeneficiary(event.payload);
          break;
      }

      emit(BeneficiarySaved(result: stored, routeName: event.routeName, activityType: event.activityType));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SaveBeneficiaryError(result: error, routeName: event.routeName, activityType: event.activityType)));
    }
  }

  Future<void> _onEnquiryGeneralFlow(GeneralFlowEnquiry event, Emitter<GeneralFlowState> emit) async {
    Response<Enquiry>? stored;
    final endpoint = event.form.verifyEndpoint ?? '';
    try {
      emit(EnquiringGeneralFlow(routeName: event.routeName, activityType: event.activityType));

      stored = await _fblOnlineRepo.getStoredEnquiry(endpoint);

      if (stored != null && (stored.data?.sources?.isNotEmpty ?? false)) {
        enquiry = stored;
        enquiryMap[endpoint] = stored;

        emit(GeneralFlowEnquired(result: enquiry, routeName: event.routeName, activityType: event.activityType, endpoint: event.form.verifyEndpoint ?? ''));

        await Future.delayed(const Duration(milliseconds: 200));
        emit(SilentEnquiringGeneralFlow(event.activityType));
      } else if (enquiryMap[endpoint] != null) {
        enquiry = enquiryMap[endpoint]!;

        await Future.delayed(const Duration(milliseconds: 200));
        emit(SilentEnquiringGeneralFlow(event.activityType));
      }

      final result = await _fblOnlineRepo.retrieveEnquiry(endpoint);
      if (result.data?.sources?.isNotEmpty ?? false) {
        enquiryMap[endpoint] = result;
        enquiry = result;
      } else if (enquiryMap[endpoint] != null) {
        enquiry = enquiryMap[endpoint]!;
      } else {
        enquiry = result;
      }

      if (stored == null || (stored.data?.sources?.isEmpty ?? false)) {
        emit(GeneralFlowEnquired(result: enquiry, routeName: event.routeName, activityType: event.activityType, endpoint: event.form.verifyEndpoint ?? ''));
      } else {
        emit(GeneralFlowEnquiredSilently(result: enquiry, activityType: event.activityType, endpoint: event.form.verifyEndpoint ?? ''));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.sources?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(EnquireGeneralFlowError(result: error, routeName: event.routeName, activityType: event.activityType)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentEnquireGeneralFlowError(result: error, activityType: event.activityType)));
      }
    }
  }

  Future<void> _onSilentEnquiryFlow(SilentGeneralFlowEnquiry event, Emitter<GeneralFlowState> emit) async {
    try {
      emit(SilentEnquiringGeneralFlow(event.activityType));

      final result = await _fblOnlineRepo.retrieveEnquiry(event.endpoint);

      enquiry = result;
      emit(GeneralFlowEnquiredSilently(result: result, activityType: event.activityType, endpoint: event.endpoint));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentEnquireGeneralFlowError(result: error, activityType: event.activityType)));
    }
  }

  Future<void> _onSubEnquiryGeneralFlow(GeneralFlowSubEnquiry event, Emitter<GeneralFlowState> emit) async {
    Response<Enquiry>? stored;
    final key = '${event.endpoint}/${event.formId}/${event.hashValue}';
    try {
      emit(EnquiringGeneralFlow(routeName: event.routeName, activityType: event.activityType));

      stored = await _fblOnlineRepo.getStoredSubEnquiry(endpoint: event.endpoint, formId: event.formId, hashValue: event.hashValue);

      if (stored != null && (stored.data?.sources?.isNotEmpty ?? false)) {
        enquiry = stored;
        enquiryMap[key] = stored;

        emit(GeneralFlowEnquired(result: enquiry, routeName: event.routeName, activityType: event.activityType, endpoint: event.endpoint));

        emit(SilentEnquiringGeneralFlow(event.activityType));
      } else if (enquiryMap[key] != null) {
        enquiry = enquiryMap[key]!;

        emit(SilentEnquiringGeneralFlow(event.activityType));
      }

      final result = await _fblOnlineRepo.retrieveSubEnquiry(endpoint: event.endpoint, formId: event.formId, hashValue: event.hashValue);
      if (result.data?.sources?.isNotEmpty ?? false) {
        enquiryMap[key] = result;
        enquiry = result;
      } else if (enquiryMap[key] != null) {
        enquiry = enquiryMap[key]!;
      } else {
        enquiry = result;
      }

      if (stored == null || (stored.data?.sources?.isEmpty ?? false)) {
        emit(GeneralFlowEnquired(result: enquiry, routeName: event.routeName, activityType: event.activityType, endpoint: event.endpoint, formId: event.formId, hashValue: event.hashValue));
      } else {
        emit(GeneralFlowEnquiredSilently(result: enquiry, activityType: event.activityType, endpoint: event.endpoint, formId: event.formId, hashValue: event.hashValue));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.sources?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(EnquireGeneralFlowError(result: error, routeName: event.routeName, activityType: event.activityType)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentEnquireGeneralFlowError(result: error, activityType: event.activityType)));
      }
    }
  }

  Future<void> _onSilentSubEnquiryFlow(SilentGeneralFlowSubEnquiry event, Emitter<GeneralFlowState> emit) async {
    try {
      emit(SilentEnquiringGeneralFlow(event.activityType));

      final result = await _fblOnlineRepo.retrieveSubEnquiry(endpoint: event.endpoint, formId: event.formId, hashValue: event.hashValue);

      enquiry = result;
      emit(GeneralFlowEnquiredSilently(result: result, activityType: event.activityType, endpoint: event.endpoint, formId: event.formId, hashValue: event.hashValue));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(SilentEnquireGeneralFlowError(result: error, activityType: event.activityType)));
    }
  }

  Future<void> _onPrepareScheduler(PrepareScheduler event, Emitter<GeneralFlowState> emit) async {
    Response<GeneralFlowFormData>? stored;
    try {
      emit(RetrievingGeneralFlowFormData(routeName: event.routeName, activityType: ActivityTypesConst.fblOnline));
      stored = await _fblOnlineRepo.getStoredPreparedSchedule(receiptId: event.receiptId, payeeId: event.payeeId);

      final key = (event.receiptId?.isNotEmpty ?? false) ? 'r-${event.receiptId}' : 'p-${event.payeeId}';
      if (stored != null && (stored.data?.fieldsDatum?.isNotEmpty ?? false)) {
        fblOnlineFormsMap[key] = stored;
        fblOnlineForms = stored;
        emit(GeneralFlowFormDataRetrieved(fblOnlineFormData: fblOnlineForms, routeName: event.routeName, activityType: ActivityTypesConst.fblOnline));

        emit(const RetrievingGeneralFlowFormDataSilently(ActivityTypesConst.fblOnline));
      } else if (fblOnlineFormsMap[key] != null) {
        fblOnlineForms = fblOnlineFormsMap[key]!;
      }

      final result = await _fblOnlineRepo.prepareScheduler(receiptId: event.receiptId, payeeId: event.payeeId);

      if (result.data?.fieldsDatum?.isNotEmpty ?? false) {
        fblOnlineFormsMap[key] = result;
        fblOnlineForms = result;
      } else if (fblOnlineFormsMap[key] != null) {
        fblOnlineForms = fblOnlineFormsMap[key]!;
      } else {
        fblOnlineForms = result;
      }

      if (stored == null || (stored.data?.fieldsDatum?.isEmpty ?? false)) {
        emit(GeneralFlowFormDataRetrieved(fblOnlineFormData: fblOnlineForms, routeName: event.routeName, activityType: ActivityTypesConst.fblOnline));
      } else {
        emit(GeneralFlowFormDataRetrievedSilently(fblOnlineFormData: fblOnlineForms, activityType: ActivityTypesConst.fblOnline));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.fieldsDatum?.isEmpty ?? false)) {
        ResponseUtil.handleException(ex, (error) => emit(RetrieveGeneralFlowFormDataError(result: error, routeName: event.routeName, activityType: ActivityTypesConst.fblOnline)));
      } else {
        ResponseUtil.handleException(ex, (error) => emit(SilentRetrieveGeneralFlowFormDataError(result: error, activityType: ActivityTypesConst.fblOnline)));
      }
    }
  }
}
