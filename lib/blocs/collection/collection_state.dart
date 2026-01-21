part of 'collection_bloc.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object> get props => [];
}

class PaymentsInitial extends PaymentsState {}

// retrieve payments

class RetrievingPayments extends PaymentsState {
  const RetrievingPayments(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingPayments extends PaymentsState {}

class PaymentsRetrieved extends PaymentsState {
  const PaymentsRetrieved({required this.payments, required this.routeName});
  final Response<List<Payment>> payments;
  final String routeName;

  @override
  List<Object> get props => [payments, routeName];
}

class PaymentsRetrievedSilently extends PaymentsState {
  const PaymentsRetrievedSilently(this.payments);
  final Response<List<Payment>> payments;

  @override
  List<Object> get props => [payments];
}

class RetrievePaymentsError extends PaymentsState {
  const RetrievePaymentsError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrievePaymentsError extends PaymentsState {
  const SilentRetrievePaymentsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// retrieve payment categories

class RetrievingPaymentCategories extends PaymentsState {
  const RetrievingPaymentCategories(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingPaymentCategories extends PaymentsState {}

class PaymentCategoriesRetrieved extends PaymentsState {
  const PaymentCategoriesRetrieved({required this.paymentCategories, required this.routeName});
  final Response<PaymentCategories> paymentCategories;
  final String routeName;

  @override
  List<Object> get props => [paymentCategories, routeName];
}

class PaymentCategoriesRetrievedSilently extends PaymentsState {
  const PaymentCategoriesRetrievedSilently(this.paymentCategories);
  final Response<PaymentCategories> paymentCategories;

  @override
  List<Object> get props => [paymentCategories];
}

class RetrievePaymentCategoriesError extends PaymentsState {
  const RetrievePaymentCategoriesError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrievePaymentCategoriesError extends PaymentsState {
  const SilentRetrievePaymentCategoriesError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// retrieve payment institution forms

class RetrievingInstitutionForms extends PaymentsState {
  const RetrievingInstitutionForms(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingInstitutionForms extends PaymentsState {}

class InstitutionFormsRetrieved extends PaymentsState {
  const InstitutionFormsRetrieved({required this.result, required this.routeName});
  final Response<InstitutionFormData> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class InstitutionFormsRetrievedSilently extends PaymentsState {
  const InstitutionFormsRetrievedSilently(this.result);
  final Response<InstitutionFormData> result;

  @override
  List<Object> get props => [result];
}

class RetrieveInstitutionFormsError extends PaymentsState {
  const RetrieveInstitutionFormsError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrieveInstitutionFormsError extends PaymentsState {
  const SilentRetrieveInstitutionFormsError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// verify form

class VerifyingForm extends PaymentsState {
  const VerifyingForm(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class FormVerified extends PaymentsState {
  const FormVerified({required this.result, required this.routeName, required this.formData});
  final Response<FormVerificationResponse> result;
  final String routeName;
  final Map<String, dynamic> formData;

  @override
  List<Object> get props => [result, routeName, formData];
}

class VerifyFormError extends PaymentsState {
  const VerifyFormError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

// make payment

class MakingPayment extends PaymentsState {
  const MakingPayment(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class PaymentMade extends PaymentsState {
  const PaymentMade({required this.result, required this.routeName});
  final Response<RequestResponse> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class MakePaymentError extends PaymentsState {
  const MakePaymentError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

// just stop loading

class StopLoadingPayments extends PaymentsState {
  const StopLoadingPayments(this.routeName);

  final String routeName;

  @override
  List<Object> get props => [routeName];
}

// retrieve collection form data

class RetrievingCollectionForm extends PaymentsState {
  const RetrievingCollectionForm(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingCollectionForm extends PaymentsState {}

class CollectionFormRetrieved extends PaymentsState {
  const CollectionFormRetrieved({required this.result, required this.routeName});
  final FormsDatum result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class CollectionFormRetrievedSilently extends PaymentsState {
  const CollectionFormRetrievedSilently(this.result);
  final FormsDatum result;

  @override
  List<Object> get props => [result];
}

class RetrieveCollectionFormError extends PaymentsState {
  const RetrieveCollectionFormError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrieveCollectionFormError extends PaymentsState {
  const SilentRetrieveCollectionFormError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// save Beneficiaries

class SavingBeneficiary extends PaymentsState {
  const SavingBeneficiary({required this.routeName});
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class BeneficiarySaved extends PaymentsState {
  const BeneficiarySaved({required this.result, required this.routeName});
  final Response result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SaveBeneficiaryError extends PaymentsState {
  const SaveBeneficiaryError({required this.routeName, required this.result});

  final String routeName;
  final Response<dynamic> result;

  @override
  List<Object> get props => [routeName, result];
}
