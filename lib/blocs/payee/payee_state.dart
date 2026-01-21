part of 'payee_bloc.dart';

abstract class PayeeState extends Equatable {
  const PayeeState();

  @override
  List<Object> get props => [];
}

class PayeeInitial extends PayeeState {}

// retrieve payee categories

class RetrievingPayeeCategories extends PayeeState {
  const RetrievingPayeeCategories(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingPayeeCategories extends PayeeState {
  const SilentRetrievingPayeeCategories();

  @override
  List<Object> get props => [];
}

class RetrievePayeeCategoriesError extends PayeeState {
  const RetrievePayeeCategoriesError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrievePayeeCategoriesError extends PayeeState {
  const SilentRetrievePayeeCategoriesError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// retrieve payee general flow

class RetrievingPayeeGeneralFlowActivity extends PayeeState {
  const RetrievingPayeeGeneralFlowActivity(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingPayeeGeneralFlowActivity extends PayeeState {
  const SilentRetrievingPayeeGeneralFlowActivity();

  @override
  List<Object> get props => [];
}

class RetrievePayeeGeneralFlowActivityError extends PayeeState {
  const RetrievePayeeGeneralFlowActivityError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrievePayeeGeneralFlowActivityError extends PayeeState {
  const SilentRetrievePayeeGeneralFlowActivityError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// retrieve payee fbl collect

class RetrievingPayeeFblCollectActivity extends PayeeState {
  const RetrievingPayeeFblCollectActivity(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrievingPayeeFblCollectActivity extends PayeeState {
  const SilentRetrievingPayeeFblCollectActivity();

  @override
  List<Object> get props => [];
}

class RetrievePayeeFblCollectActivityError extends PayeeState {
  const RetrievePayeeFblCollectActivityError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SilentRetrievePayeeFblCollectActivityError extends PayeeState {
  const SilentRetrievePayeeFblCollectActivityError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// Payees

class LoadingPayees extends PayeeState {
  const LoadingPayees();

  @override
  List<Object> get props => [];
}

class SilentLoadingPayees extends PayeeState {
  const SilentLoadingPayees();

  @override
  List<Object> get props => [];
}

class PayeesLoaded extends PayeeState {
  const PayeesLoaded({required this.result});
  final Response<PayeesResponse> result;

  @override
  List<Object> get props => [result];
}

class PayeesLoadedSilently extends PayeeState {
  const PayeesLoadedSilently({required this.result});
  final Response<PayeesResponse> result;

  @override
  List<Object> get props => [result];
}

class LoadPayeesError extends PayeeState {
  const LoadPayeesError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

class SilentLoadPayeesError extends PayeeState {
  const SilentLoadPayeesError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [result];
}

// add payee

class AddingPayee extends PayeeState {
  const AddingPayee(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class PayeeAdded extends PayeeState {
  const PayeeAdded({required this.result, required this.routeName});
  final Response result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class AddPayeeError extends PayeeState {
  const AddPayeeError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

// delete payee

class DeletingPayee extends PayeeState {
  const DeletingPayee(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class PayeeDeleted extends PayeeState {
  const PayeeDeleted({required this.result, required this.routeName});
  final Response result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class DeletePayeeError extends PayeeState {
  const DeletePayeeError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

// payee sending now

class SendingPayeeNow extends PayeeState {
  const SendingPayeeNow(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class PayeeSentNow extends PayeeState {
  const PayeeSentNow({required this.result, required this.routeName});
  final Response result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

class SendPayeeNowError extends PayeeState {
  const SendPayeeNowError({required this.result, required this.routeName});

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [result, routeName];
}

// retrieve form payees

class RetrievingFormPayees extends PayeeState {
  const RetrievingFormPayees(this.formId);
  final String formId;

  @override
  List<Object> get props => [formId];
}

class FormPayeesRetrieved extends PayeeState {
  const FormPayeesRetrieved({required this.result, required this.formId});
  final Response<List<Payees>> result;
  final String formId;

  @override
  List<Object> get props => [result, formId];
}

class RetrieveFormPayeesError extends PayeeState {
  const RetrieveFormPayeesError({required this.result, required this.formId});

  final Response<dynamic> result;
  final String formId;

  @override
  List<Object> get props => [result, formId];
}
