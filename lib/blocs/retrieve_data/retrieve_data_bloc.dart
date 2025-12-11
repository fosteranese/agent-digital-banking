import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/data/models/collection/institution.dart';
import 'package:agent_digital_banking/data/models/enquiry.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/data/repository/fbl_online.repo.dart';
import 'package:agent_digital_banking/data/repository/payment.repo.dart';
import 'package:agent_digital_banking/data/repository/quickflow.repo.dart';
import 'package:agent_digital_banking/utils/response.util.dart';

part 'retrieve_data_event.dart';
part 'retrieve_data_state.dart';

class RetrieveDataBloc extends Bloc<RetrieveDataEvent, RetrieveDataState> {
  RetrieveDataBloc({required this.fblOnlineRepo, required this.quickflow, required this.paymentRepo}) : super(RetrieveDataInitial(id: '', action: '')) {
    on(_onRetrieveCategories);
    on(_onRetrievePaymentCategories);
    on(_onRetrieveForm);
    on(_onRetrieveScheduleForm);
    on(_onRetrieveEnquiry);
  }

  final Map<String, dynamic> data = {};

  final FblOnlineRepo fblOnlineRepo;
  final QuickFlowRepo quickflow;
  final PaymentRepo paymentRepo;

  Future<void> _onRetrieveData<T>({required RetrieveDataEvent event, required Emitter<RetrieveDataState> emit, required Future<T> Function() retrieveFunc, Future<T> Function(dynamic payload)? storeFunc, Future<T> Function()? getStoredFunc, bool saveCurrent = true}) async {
    T currentData;
    try {
      if (!event.skipSavedData && saveCurrent && event.action != null) {
        currentData = data[event.action] ?? (getStoredFunc != null ? await getStoredFunc() : null);

        if (currentData != null && (currentData is! List || (currentData as List).isNotEmpty)) {
          emit(DataRetrieved<T>(id: event.id, action: event.action ?? '', data: currentData, event: event, stillLoading: true));

          // emit(
          //   RetrievingDataSilently(
          //     id: event.id,
          //     action: event.action ?? '',
          //     event: event,
          //   ),
          // );
        } else {
          emit(RetrievingData(id: event.id, action: event.action ?? '', event: event));
        }
      } else {
        emit(RetrievingData(id: event.id, action: event.action ?? '', event: event));
      }

      final resultData = await retrieveFunc();

      emit(DataRetrieved<T>(id: event.id, action: event.action ?? '', data: resultData, event: event));

      if (!saveCurrent || event.action != null) {
        currentData = resultData;
        data[event.action!] = currentData;
        if (storeFunc != null) {
          try {
            await storeFunc(currentData);
          } catch (_) {}
        }
      }
    } catch (error) {
      ResponseUtil.handleException(error, (error) => emit(RetrieveDataError(id: event.id, event: event, action: event.action ?? '', error: error)));
    }
  }

  Future<void> _onRetrieveCategories(RetrieveCategories event, Emitter<RetrieveDataState> emit) async {
    await _onRetrieveData(
      event: event,
      emit: emit,
      retrieveFunc: () async {
        switch (event.activityType) {
          case ActivityTypesConst.fblOnline:
            return await fblOnlineRepo.retrieveCategories(event.endpoint);

          case ActivityTypesConst.quickFlow:
            return await quickflow.retrieveCategories(event.endpoint);

          case ActivityTypesConst.fblCollect:
            return await paymentRepo.retrievePayments();

          case ActivityTypesConst.fblCollectCategory:
            return await paymentRepo.retrievePaymentCategoriesWithEndpoint(event.endpoint);
        }
      },
      saveCurrent: true,
      getStoredFunc: () async {
        switch (event.activityType) {
          case ActivityTypesConst.fblOnline:
            return await fblOnlineRepo.getStoredCategories(event.endpoint);

          case ActivityTypesConst.quickFlow:
            return await quickflow.getStoredCategories(event.endpoint);

          case ActivityTypesConst.fblCollect:
            return await paymentRepo.getStoredPayments();

          case ActivityTypesConst.fblCollectCategory:
            return await paymentRepo.getStoredPaymentCategoriesWithEndpoint(event.endpoint);
        }
      },
      storeFunc: (data) async {
        // await repo.saveWallets(data);
      },
    );
  }

  Future<void> _onRetrievePaymentCategories(RetrievePaymentCategories event, Emitter<RetrieveDataState> emit) async {
    await _onRetrieveData(
      event: event,
      emit: emit,
      retrieveFunc: () async {
        return await paymentRepo.retrievePaymentCategories(event.categoryId);
      },
      saveCurrent: true,
      getStoredFunc: () async {
        return await paymentRepo.getStoredPaymentCategories(event.categoryId);
      },
      storeFunc: (data) async {
        // await repo.saveWallets(data);
      },
    );
  }

  Future<void> _onRetrieveForm(RetrieveForm event, Emitter<RetrieveDataState> emit) async {
    await _onRetrieveData(
      event: event,
      emit: emit,
      retrieveFunc: () async {
        switch (event.form) {
          case GeneralFlowForm form:
            switch (form.activityType) {
              case ActivityTypesConst.enquiry:
                return await fblOnlineRepo.retrieveEnquiry(form.verifyEndpoint!);

              case ActivityTypesConst.quickFlow:
              case ActivityTypesConst.quickFlowAlt:
                return await quickflow.retrieveFormData(id: form.formId!, qrCode: event.qrCode, payeeId: event.payeeId);

              case ActivityTypesConst.fblCollectCategory:
                return await paymentRepo.retrieveFormData1(formId: form.formId!, activityType: ActivityTypesConst.fblCollectCategory);

              default:
                return await fblOnlineRepo.retrieveFormData(id: form.formId!, qrCode: event.qrCode, payeeId: event.payeeId);
            }

          case Institution form:
            return await paymentRepo.retrieveInstitutionFormData1(institutionId: form.insId!, activity: event.activity);
        }
      },
      saveCurrent: true,
      getStoredFunc: () async {
        switch (event.form) {
          case GeneralFlowForm form:
            switch (form.activityType) {
              case ActivityTypesConst.enquiry:
                return await fblOnlineRepo.getStoredEnquiry(form.verifyEndpoint!);

              case ActivityTypesConst.quickFlow:
              case ActivityTypesConst.quickFlowAlt:
                return await quickflow.getStoredFormData(id: form.formId!, qrCode: event.qrCode, payeeId: event.payeeId);

              case ActivityTypesConst.fblCollectCategory:
                return await paymentRepo.getStoredCollectionForm1(formId: form.formId!, activityType: ActivityTypesConst.fblCollectCategory);

              default:
                return await fblOnlineRepo.getStoredFormData(id: form.formId!, qrCode: event.qrCode, payeeId: event.payeeId);
            }

          case Institution form:
            return await paymentRepo.getStoredInstitutionFormData1(form.insId!);
        }
      },
      storeFunc: (data) async {
        // await repo.saveWallets(data);
      },
    );
  }

  Future<void> _onRetrieveScheduleForm(RetrieveScheduleForm event, Emitter<RetrieveDataState> emit) async {
    await _onRetrieveData(
      event: event,
      emit: emit,
      retrieveFunc: () async {
        return await fblOnlineRepo.prepareScheduler(receiptId: event.receiptId, payeeId: event.payeeId);
      },
      saveCurrent: true,
      getStoredFunc: () async {
        return await fblOnlineRepo.getStoredPreparedSchedule(receiptId: event.receiptId, payeeId: event.payeeId);
      },
      storeFunc: (data) async {
        // await repo.saveWallets(data);
      },
    );
  }

  Future<void> _onRetrieveEnquiry(RetrieveEnquiry event, Emitter<RetrieveDataState> emit) async {
    await _onRetrieveData(
      event: event,
      emit: emit,
      retrieveFunc: () async {
        if (event.enquiry == null) {
          return await fblOnlineRepo.retrieveEnquiry(event.form.verifyEndpoint ?? '');
        } else {
          return await fblOnlineRepo.retrieveSubEnquiry(endpoint: event.enquiry!.endPoint ?? '', formId: event.enquiry!.formId ?? '', hashValue: event.enquiry!.header ?? '');
        }
      },
      saveCurrent: true,
      getStoredFunc: () async {
        if (event.enquiry == null) {
          return await fblOnlineRepo.getStoredEnquiry(event.form.verifyEndpoint ?? '');
        } else {
          return await fblOnlineRepo.getStoredSubEnquiry(endpoint: event.enquiry!.endPoint ?? '', formId: event.enquiry!.formId ?? '', hashValue: event.enquiry!.header ?? '');
        }
      },
      storeFunc: (data) async {
        // await repo.saveWallets(data);
      },
    );
  }
}
