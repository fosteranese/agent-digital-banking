part of 'bulk_payment_bloc.dart';

abstract class BulkPaymentEvent extends Equatable {
  const BulkPaymentEvent();

  @override
  List<Object?> get props => [];
}

// retrieve groups

class RetrieveBulkPaymentGroups extends BulkPaymentEvent {
  const RetrieveBulkPaymentGroups(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [routeName];
}

class SilentRetrieveBulkPaymentGroups extends BulkPaymentEvent {
  const SilentRetrieveBulkPaymentGroups(this.routeName);

  final String? routeName;

  @override
  List<Object?> get props => [routeName];
}

// retrieve groups

class RetrieveBulkPaymentGroupMembers extends BulkPaymentEvent {
  const RetrieveBulkPaymentGroupMembers({required this.group, required this.routeName});
  final Groups group;
  final String routeName;

  @override
  List<Object> get props => [group, routeName];
}

class SilentRetrieveBulkPaymentGroupMembers extends BulkPaymentEvent {
  const SilentRetrieveBulkPaymentGroupMembers({required this.group, required this.routeName});
  final Groups group;
  final String routeName;

  @override
  List<Object> get props => [group, routeName];
}

// create groups

class AddPayeesToBulkPaymentGroup extends BulkPaymentEvent {
  const AddPayeesToBulkPaymentGroup({
    required this.group,
    required this.payees,
    required this.routeName,
  });
  final Groups group;
  final List<String> payees;
  final String routeName;

  @override
  List<Object> get props => [group, payees, routeName];
}

// Go to new group

class GotoNewGroup extends BulkPaymentEvent {
  const GotoNewGroup();

  @override
  List<Object> get props => [];
}

// Delete Bulk Payment Group

class DeleteBulkPaymentGroup extends BulkPaymentEvent {
  const DeleteBulkPaymentGroup({required this.group, required this.routeName});
  final Groups group;
  final String routeName;

  @override
  List<Object> get props => [group, routeName];
}

// Delete Bulk Payment Group

class RemovePayeeFromBulkPaymentGroup extends BulkPaymentEvent {
  const RemovePayeeFromBulkPaymentGroup({
    required this.group,
    required this.payee,
    required this.routeName,
  });
  final Groups group;
  final Payees payee;
  final String routeName;

  @override
  List<Object> get props => [group, payee, routeName];
}

// make group Payment

class MakeBulkPayment extends BulkPaymentEvent {
  const MakeBulkPayment({required this.group, required this.pin, required this.routeName});
  final Groups group;
  final String pin;
  final String routeName;

  @override
  List<Object> get props => [group, pin, routeName];
}
