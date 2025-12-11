part of 'payee_bloc.dart';

abstract class PayeeEvent extends Equatable {
  const PayeeEvent();

  @override
  List<Object> get props => [];
}

// retrieve payee categories

class RetrievePayeeCategories extends PayeeEvent {
  const RetrievePayeeCategories({
    required this.routeName,
    required this.showSilentLoading,
  });

  final String routeName;
  final bool showSilentLoading;

  @override
  List<Object> get props => [
        routeName,
        showSilentLoading,
      ];
}

class RefreshRetrievePayeeCategories extends PayeeEvent {
  const RefreshRetrievePayeeCategories(this.routeName);

  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievePayeeCategories extends PayeeEvent {
  const SilentRetrievePayeeCategories();

  @override
  List<Object> get props => [];
}

// get payees

class LoadPayees extends PayeeEvent {
  const LoadPayees(this.showSilentLoading);
  final bool showSilentLoading;

  @override
  List<Object> get props => [
        showSilentLoading,
      ];
}

class FilterPayees extends PayeeEvent {
  const FilterPayees(this.form);
  final PayeeForm form;

  @override
  List<Object> get props => [
        form,
      ];
}

class LoadAllPayees extends PayeeEvent {
  const LoadAllPayees();

  @override
  List<Object> get props => [];
}

// add payee

class AddPayee extends PayeeEvent {
  const AddPayee({
    required this.routeName,
    required this.payment,
    required this.payload,
  });

  final String routeName;
  final ProcessRequestModel payment;
  final Map<String, dynamic> payload;

  @override
  List<Object> get props => [
        routeName,
        payment,
        payload,
      ];
}

// delete payee

class DeletePayee extends PayeeEvent {
  const DeletePayee({
    required this.routeName,
    required this.payee,
  });

  final String routeName;
  final Payees payee;

  @override
  List<Object> get props => [
        routeName,
        payee,
      ];
}

// send payee now

class SendPayeeNow extends PayeeEvent {
  const SendPayeeNow({
    required this.routeName,
    required this.payee,
    required this.pin,
  });

  final String routeName;
  final Payees payee;
  final String pin;

  @override
  List<Object> get props => [
        routeName,
        payee,
      ];
}

// retrieve form payees

class RetrieveFormPayees extends PayeeEvent {
  const RetrieveFormPayees(this.formId);

  final String formId;

  @override
  List<Object> get props => [
        formId,
      ];
}