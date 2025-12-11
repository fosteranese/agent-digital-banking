part of 'collection_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

// retrieve payments

class RetrievePayments extends PaymentsEvent {
  const RetrievePayments({
    required this.activityId,
    required this.routeName,
  });
  final String activityId;
  final String routeName;

  @override
  List<Object> get props => [activityId, routeName];
}

class SilentRetrievePayments extends PaymentsEvent {
  const SilentRetrievePayments();

  @override
  List<Object> get props => [];
}

// retrieve payment categories

class RetrievePaymentCategories extends PaymentsEvent {
  const RetrievePaymentCategories({
    required this.routeName,
    required this.categoryId,
  });
  final String routeName;
  final String categoryId;

  @override
  List<Object> get props => [routeName, categoryId];
}

class SilentRetrievePaymentCategories
    extends PaymentsEvent {
  const SilentRetrievePaymentCategories(this.categoryId);
  final String categoryId;

  @override
  List<Object> get props => [categoryId];
}

class RetrievePaymentCategoriesWithEndpoint
    extends PaymentsEvent {
  const RetrievePaymentCategoriesWithEndpoint({
    required this.routeName,
    required this.endpoint,
    required this.activityId,
  });
  final String routeName;
  final String endpoint;
  final String activityId;

  @override
  List<Object> get props => [
    routeName,
    endpoint,
    activityId,
  ];
}

class SilentRetrievePaymentCategoriesWithEndpoint
    extends PaymentsEvent {
  const SilentRetrievePaymentCategoriesWithEndpoint(
    this.endpoint,
  );
  final String endpoint;

  @override
  List<Object> get props => [endpoint];
}

// retrieve institution forms

class RetrieveInstitutionForms extends PaymentsEvent {
  const RetrieveInstitutionForms({
    required this.routeName,
    required this.institutionId,
  });
  final String routeName;
  final String institutionId;

  @override
  List<Object> get props => [routeName, institutionId];
}

class SilentRetrieveInstitutionForms extends PaymentsEvent {
  const SilentRetrieveInstitutionForms(this.institutionId);
  final String institutionId;

  @override
  List<Object> get props => [institutionId];
}

// verify forms

class VerifyForm extends PaymentsEvent {
  const VerifyForm({
    required this.routeName,
    required this.formData,
    required this.payload,
  });
  final String routeName;
  final FormsDatum formData;
  final Map<String, dynamic> payload;

  @override
  List<Object> get props => [routeName, formData, payload];
}

// make payment

class MakePayment extends PaymentsEvent {
  const MakePayment({
    required this.routeName,
    required this.payment,
    required this.payload,
  });

  final String routeName;
  final ProcessRequestModel payment;
  final Map<String, dynamic> payload;

  @override
  List<Object> get props => [routeName, payment, payload];
}

// retrieve form data

class RetrieveCollectionForm extends PaymentsEvent {
  const RetrieveCollectionForm({
    required this.routeName,
    required this.formId,
    required this.activityId,
    this.payeeId,
  });

  final String routeName;
  final String formId;
  final String activityId;
  final String? payeeId;

  @override
  List<Object?> get props => [
    routeName,
    formId,
    activityId,
    payeeId,
  ];
}

class SilentlyRetrieveCollectionForm extends PaymentsEvent {
  const SilentlyRetrieveCollectionForm({
    required this.routeName,
    required this.formId,
    required this.activityId,
    this.payeeId,
  });
  final String routeName;
  final String formId;
  final String activityId;
  final String? payeeId;

  @override
  List<Object?> get props => [
    routeName,
    formId,
    activityId,
    payeeId,
  ];
}

// save Beneficiary

class SaveBeneficiary extends PaymentsEvent {
  const SaveBeneficiary({
    required this.routeName,
    required this.payload,
  });

  final String routeName;
  final RequestResponse payload;

  @override
  List<Object> get props => [routeName, payload];
}
