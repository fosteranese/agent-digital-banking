import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/collection/form_verification_response.dart';
import '../../data/models/collection/forms_datum.dart';
import '../../data/models/collection/institution_form_data.dart';
import '../../data/models/collection/payment.dart';
import '../../data/models/collection/payment_categories.dart';
import '../../data/models/process_request.model.dart';
import '../../data/models/request_response.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/payment.repo.dart';
import '../../utils/response.util.dart';

part 'fbl_collect_event.dart';
part 'fbl_collect_state.dart';

class PaymentsBloc
    extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc() : super(PaymentsInitial()) {
    on(_onRetrievePayments);
    on(_onSilentRetrievePayments);
    on(_onRetrievePaymentCategories);
    on(_onSilentRetrievePaymentCategories);
    on(_onRetrievePaymentCategoriesWithEndpoint);
    on(_onSilentRetrievePaymentCategoriesWithEndpoint);
    on(_onRetrieveInstitutionForms);
    on(_onSilentRetrieveInstitutionForms);

    on(_onMakePayment);
    on(_onSaveBeneficiary);

    on(_onRetrieveCollectionForm);
    on(_onSilentRetrieveCollectionForm);
  }

  final _repo = PaymentRepo();
  Response<List<Payment>> payments = const Response(
    code: '',
    status: '',
    message: '',
    data: [],
  );
  Map<String, Response<List<Payment>>> paymentsMap = {};
  Response<PaymentCategories> paymentCategories =
      const Response(
        code: '',
        status: '',
        message: '',
        data: null,
      );
  Map<String, Response<PaymentCategories>>
  paymentCategoriesMap = {};
  Response<InstitutionFormData> institutionForms =
      const Response(
        code: '',
        status: '',
        message: '',
        data: null,
      );
  Map<String, Response<InstitutionFormData>>
  institutionFormsMap = {};
  String activityId = '';

  Future<void> _onRetrievePayments(
    RetrievePayments event,
    Emitter<PaymentsState> emit,
  ) async {
    Response<List<Payment>>? stored;
    activityId = event.activityId;
    try {
      emit(RetrievingPayments(event.routeName));
      stored = await _repo.getStoredPayments();
      if (stored != null &&
          (stored.data?.isNotEmpty ?? false)) {
        paymentsMap[event.activityId] = stored;
        payments = stored;
        emit(
          PaymentsRetrieved(
            payments: payments,
            routeName: event.routeName,
          ),
        );

        emit(SilentRetrievingPayments());
      } else if (paymentsMap[event.activityId] != null) {
        paymentsMap[event.activityId] =
            paymentsMap[event.activityId]!;

        emit(SilentRetrievingPayments());
      }

      final result = await _repo.retrievePayments();
      if (result.data?.isNotEmpty ?? false) {
        paymentsMap[event.activityId] = result;
        payments = result;
      } else if (paymentsMap[event.activityId] != null) {
        payments = paymentsMap[event.activityId]!;
      } else {
        payments = result;
      }

      if (stored == null ||
          (stored.data?.isEmpty ?? false)) {
        emit(
          PaymentsRetrieved(
            payments: payments,
            routeName: event.routeName,
          ),
        );
      } else {
        emit(PaymentsRetrievedSilently(payments));
      }
    } catch (ex) {
      if (stored == null ||
          (stored.data?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            RetrievePaymentsError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) =>
              emit(SilentRetrievePaymentsError(error)),
        );
      }
    }
  }

  Future<void> _onSilentRetrievePayments(
    SilentRetrievePayments event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(SilentRetrievingPayments());
      final result = await _repo.retrievePayments();
      payments = result;
      emit(PaymentsRetrievedSilently(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(SilentRetrievePaymentsError(error)),
      );
    }
  }

  Future<void> _onRetrievePaymentCategories(
    RetrievePaymentCategories event,
    Emitter<PaymentsState> emit,
  ) async {
    Response<PaymentCategories>? stored;
    try {
      emit(RetrievingPaymentCategories(event.routeName));
      stored = await _repo.getStoredPaymentCategories(
        event.categoryId,
      );
      if (stored != null &&
          (stored.data?.institution?.isNotEmpty ?? false)) {
        paymentCategoriesMap[event.categoryId] = stored;
        paymentCategories = stored;

        if (paymentCategories.data!.institution!.length ==
            1) {
          emit(StopLoadingPayments(event.routeName));

          final institution =
              paymentCategories.data!.institution!.first;
          await _onRetrieveInstitutionForms(
            RetrieveInstitutionForms(
              institutionId: institution.insId ?? '',
              routeName: event.routeName,
            ),
            emit,
          );
        } else {
          emit(
            PaymentCategoriesRetrieved(
              paymentCategories: paymentCategories,
              routeName: event.routeName,
            ),
          );
        }
      } else if (paymentCategoriesMap[event.categoryId] !=
          null) {
        paymentCategories =
            paymentCategoriesMap[event.categoryId]!;

        if (paymentCategories.data!.institution!.length ==
            1) {
          final institution =
              paymentCategories.data!.institution!.first;
          await _onRetrieveInstitutionForms(
            RetrieveInstitutionForms(
              institutionId: institution.insId ?? '',
              routeName: event.routeName,
            ),
            emit,
          );
        } else {
          emit(SilentRetrievingPaymentCategories());
        }
      }

      final result = await _repo.retrievePaymentCategories(
        event.categoryId,
      );

      if (result.data?.institution?.isNotEmpty ?? false) {
        paymentCategoriesMap[event.categoryId] = result;
        paymentCategories = result;
      } else if (paymentCategoriesMap[event.categoryId] !=
          null) {
        paymentCategories =
            paymentCategoriesMap[event.categoryId]!;
      } else {
        paymentCategories = result;
      }

      if (stored == null ||
          (stored.data?.institution?.isEmpty ?? false)) {
        if (paymentCategories.data!.institution!.length ==
            1) {
          emit(StopLoadingPayments(event.routeName));
          final institution =
              paymentCategories.data!.institution!.first;
          await _onRetrieveInstitutionForms(
            RetrieveInstitutionForms(
              institutionId: institution.insId ?? '',
              routeName: event.routeName,
            ),
            emit,
          );
        } else {
          emit(
            PaymentCategoriesRetrieved(
              paymentCategories: paymentCategories,
              routeName: event.routeName,
            ),
          );
        }
      } else {
        emit(
          PaymentCategoriesRetrievedSilently(
            paymentCategories,
          ),
        );
      }
    } catch (ex) {
      if (stored == null ||
          (stored.data?.institution?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            RetrievePaymentCategoriesError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            SilentRetrievePaymentCategoriesError(error),
          ),
        );
      }
    }
  }

  Future<void> _onSilentRetrievePaymentCategories(
    SilentRetrievePaymentCategories event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(SilentRetrievingPaymentCategories());
      final result = await _repo.retrievePaymentCategories(
        event.categoryId,
      );
      paymentCategories = result;
      emit(PaymentCategoriesRetrievedSilently(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SilentRetrievePaymentCategoriesError(error),
        ),
      );
    }
  }

  Future<void> _onRetrievePaymentCategoriesWithEndpoint(
    RetrievePaymentCategoriesWithEndpoint event,
    Emitter<PaymentsState> emit,
  ) async {
    Response<PaymentCategories>? stored;
    try {
      emit(RetrievingPaymentCategories(event.routeName));
      stored = await _repo
          .getStoredPaymentCategoriesWithEndpoint(
            event.endpoint,
          );
      if (stored != null &&
          (stored.data?.institution?.isNotEmpty ?? false)) {
        paymentCategoriesMap[event.endpoint] = stored;
        paymentCategories = stored;

        if (paymentCategories.data!.institution!.length ==
            1) {
          emit(StopLoadingPayments(event.routeName));

          final institution =
              paymentCategories.data!.institution!.first;
          await _onRetrieveInstitutionForms(
            RetrieveInstitutionForms(
              institutionId: institution.insId ?? '',
              routeName: event.routeName,
            ),
            emit,
          );
        } else {
          emit(
            PaymentCategoriesRetrieved(
              paymentCategories: paymentCategories,
              routeName: event.routeName,
            ),
          );
        }
      } else if (paymentCategoriesMap[event.endpoint] !=
          null) {
        paymentCategories =
            paymentCategoriesMap[event.endpoint]!;

        if (paymentCategories.data!.institution!.length ==
            1) {
          final institution =
              paymentCategories.data!.institution!.first;
          await _onRetrieveInstitutionForms(
            RetrieveInstitutionForms(
              institutionId: institution.insId ?? '',
              routeName: event.routeName,
            ),
            emit,
          );
        } else {
          emit(SilentRetrievingPaymentCategories());
        }
      }

      final result = await _repo
          .retrievePaymentCategoriesWithEndpoint(
            event.endpoint,
          );

      if (result.data?.institution?.isNotEmpty ?? false) {
        paymentCategoriesMap[event.endpoint] = result;
        paymentCategories = result;
      } else if (paymentCategoriesMap[event.endpoint] !=
          null) {
        paymentCategories =
            paymentCategoriesMap[event.endpoint]!;
      } else {
        paymentCategories = result;
      }

      if (stored == null ||
          (stored.data?.institution?.isEmpty ?? false)) {
        if (paymentCategories.data!.institution!.length ==
            1) {
          emit(StopLoadingPayments(event.routeName));
          final institution =
              paymentCategories.data!.institution!.first;
          await _onRetrieveInstitutionForms(
            RetrieveInstitutionForms(
              institutionId: institution.insId ?? '',
              routeName: event.routeName,
            ),
            emit,
          );
        } else {
          emit(
            PaymentCategoriesRetrieved(
              paymentCategories: paymentCategories,
              routeName: event.routeName,
            ),
          );
        }
      } else {
        emit(
          PaymentCategoriesRetrievedSilently(
            paymentCategories,
          ),
        );
      }
    } catch (ex) {
      if (stored == null ||
          (stored.data?.institution?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            RetrievePaymentCategoriesError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            SilentRetrievePaymentCategoriesError(error),
          ),
        );
      }
    }
  }

  Future<void>
  _onSilentRetrievePaymentCategoriesWithEndpoint(
    SilentRetrievePaymentCategoriesWithEndpoint event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(SilentRetrievingPaymentCategories());
      final result = await _repo
          .retrievePaymentCategoriesWithEndpoint(
            event.endpoint,
          );
      paymentCategories = result;
      emit(PaymentCategoriesRetrievedSilently(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SilentRetrievePaymentCategoriesError(error),
        ),
      );
    }
  }

  Future<void> _onRetrieveInstitutionForms(
    RetrieveInstitutionForms event,
    Emitter<PaymentsState> emit,
  ) async {
    Response<InstitutionFormData>? stored;
    try {
      emit(RetrievingInstitutionForms(event.routeName));
      stored = await _repo.getStoredInstitutionFormData(
        event.institutionId,
      );
      if (stored != null &&
          (stored
                  .data
                  ?.institutionData
                  ?.formsData
                  ?.isNotEmpty ??
              false)) {
        institutionFormsMap[event.institutionId] = stored;
        institutionForms = stored;
        emit(
          InstitutionFormsRetrieved(
            result: institutionForms,
            routeName: event.routeName,
          ),
        );

        emit(SilentRetrievingInstitutionForms());
      } else if (institutionFormsMap[event.institutionId] !=
          null) {
        institutionForms =
            institutionFormsMap[event.institutionId]!;
      }

      final result = await _repo
          .retrieveInstitutionFormData(event.institutionId);
      if (result
              .data
              ?.institutionData
              ?.formsData
              ?.isNotEmpty ??
          false) {
        institutionFormsMap[event.institutionId] = result;
        institutionForms = result;
      } else if (institutionFormsMap[event.institutionId] !=
          null) {
        institutionForms =
            institutionFormsMap[event.institutionId]!;
      } else {
        institutionForms = result;
      }

      if (stored == null ||
          (stored
                  .data
                  ?.institutionData
                  ?.formsData
                  ?.isEmpty ??
              false)) {
        emit(
          InstitutionFormsRetrieved(
            result: institutionForms,
            routeName: event.routeName,
          ),
        );
      } else {
        emit(
          InstitutionFormsRetrievedSilently(
            institutionForms,
          ),
        );
      }
    } catch (ex) {
      if (stored == null ||
          (stored
                  .data
                  ?.institutionData
                  ?.formsData
                  ?.isEmpty ??
              false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            RetrieveInstitutionFormsError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            SilentRetrieveInstitutionFormsError(error),
          ),
        );
      }
    }
  }

  Future<void> _onSilentRetrieveInstitutionForms(
    SilentRetrieveInstitutionForms event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(SilentRetrievingInstitutionForms());
      final result = await _repo
          .retrieveInstitutionFormData(event.institutionId);
      institutionForms = result;
      emit(InstitutionFormsRetrievedSilently(result));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SilentRetrieveInstitutionFormsError(error),
        ),
      );
    }
  }

  Future<void> _onMakePayment(
    MakePayment event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(MakingPayment(event.routeName));
      final stored = await _repo.makePayment(
        payment: event.payment,
        payload: event.payload,
      );
      emit(
        PaymentMade(
          result: stored,
          routeName: event.routeName,
        ),
      );
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          MakePaymentError(
            result: error,
            routeName: event.routeName,
          ),
        ),
      );
    }
  }

  Future<void> _onSaveBeneficiary(
    SaveBeneficiary event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(SavingBeneficiary(routeName: event.routeName));

      final stored = await _repo.saveBeneficiary(
        event.payload,
      );

      emit(
        BeneficiarySaved(
          result: stored,
          routeName: event.routeName,
        ),
      );
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SaveBeneficiaryError(
            result: error,
            routeName: event.routeName,
          ),
        ),
      );
    }
  }

  Future<void> _onRetrieveCollectionForm(
    RetrieveCollectionForm event,
    Emitter<PaymentsState> emit,
  ) async {
    Response<InstitutionFormData>? stored;
    activityId = event.activityId;
    try {
      emit(RetrievingCollectionForm(event.routeName));
      stored = await _repo.getStoredCollectionForm(
        activityId: event.activityId,
        formId: event.formId,
        payeeId: event.payeeId,
      );

      if (stored != null &&
          (stored
                  .data
                  ?.institutionData
                  ?.formsData
                  ?.isNotEmpty ??
              false)) {
        institutionFormsMap[event.formId] = stored;
        institutionForms = stored;
        final formData = institutionForms
            .data!
            .institutionData!
            .formsData!
            .firstWhere(
              (element) =>
                  element.form?.formId == event.formId,
            );
        emit(
          CollectionFormRetrieved(
            result: formData,
            routeName: event.routeName,
          ),
        );

        emit(SilentRetrievingCollectionForm());
      }

      final result = await _repo.retrieveFormData(
        activityId: event.activityId,
        formId: event.formId,
        payeeId: event.payeeId,
      );

      if (result
              .data
              ?.institutionData
              ?.formsData
              ?.isNotEmpty ??
          false) {
        institutionFormsMap[event.formId] = result;
        institutionForms = result;
      } else {
        institutionForms = result;
      }

      final formData = institutionForms
          .data!
          .institutionData!
          .formsData!
          .firstWhere(
            (element) =>
                element.form?.formId == event.formId,
          );
      if (stored == null ||
          (stored
                  .data
                  ?.institutionData
                  ?.formsData
                  ?.isEmpty ??
              false)) {
        emit(
          CollectionFormRetrieved(
            result: formData,
            routeName: event.routeName,
          ),
        );
      } else {
        emit(CollectionFormRetrievedSilently(formData));
      }
    } catch (ex) {
      if (stored == null ||
          (stored
                  .data
                  ?.institutionData
                  ?.formsData
                  ?.isEmpty ??
              false)) {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            RetrieveCollectionFormError(
              result: error,
              routeName: event.routeName,
            ),
          ),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            SilentRetrieveCollectionFormError(error),
          ),
        );
      }
    }
  }

  Future<void> _onSilentRetrieveCollectionForm(
    SilentlyRetrieveCollectionForm event,
    Emitter<PaymentsState> emit,
  ) async {
    try {
      emit(SilentRetrievingCollectionForm());
      final result = await _repo.retrieveFormData(
        activityId: event.activityId,
        formId: event.formId,
        payeeId: event.payeeId,
      );
      institutionForms = result;
      institutionFormsMap[institutionForms
              .data!
              .institutionData!
              .institution!
              .insId!] =
          result;
      final formData = institutionForms
          .data!
          .institutionData!
          .formsData!
          .firstWhere(
            (element) =>
                element.form?.formId == event.formId,
          );

      emit(CollectionFormRetrievedSilently(formData));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) =>
            emit(SilentRetrieveCollectionFormError(error)),
      );
    }
  }
}
