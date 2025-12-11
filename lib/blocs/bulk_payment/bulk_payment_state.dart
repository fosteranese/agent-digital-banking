part of 'bulk_payment_bloc.dart';

abstract class BulkPaymentState extends Equatable {
  const BulkPaymentState();

  @override
  List<Object?> get props => [];
}

class BulkPaymentInitial extends BulkPaymentState {}

// retrieve groups

class RetrievingBulkPaymentGroups extends BulkPaymentState {
  const RetrievingBulkPaymentGroups(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievingBulkPaymentGroups extends BulkPaymentState {
  const SilentRetrievingBulkPaymentGroups(this.routeName);

  final String? routeName;

  @override
  List<Object?> get props => [
        routeName,
      ];
}

class BulkPaymentGroupsRetrieved extends BulkPaymentState {
  const BulkPaymentGroupsRetrieved({
    required this.result,
    required this.routeName,
  });

  final Response<BulkPaymentGroups> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class BulkPaymentGroupsRetrievedSilently extends BulkPaymentState {
  const BulkPaymentGroupsRetrievedSilently({
    required this.result,
    this.routeName,
  });
  final Response<BulkPaymentGroups> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

class RetrieveBulkPaymentGroupsError extends BulkPaymentState {
  const RetrieveBulkPaymentGroupsError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SilentRetrieveBulkPaymentGroupsError extends BulkPaymentState {
  const SilentRetrieveBulkPaymentGroupsError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// retrieve group members

class RetrievingBulkPaymentGroupMembers extends BulkPaymentState {
  const RetrievingBulkPaymentGroupMembers(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class SilentRetrievingBulkPaymentGroupMembers extends BulkPaymentState {
  const SilentRetrievingBulkPaymentGroupMembers(this.routeName);

  final String? routeName;

  @override
  List<Object?> get props => [
        routeName,
      ];
}

class BulkPaymentGroupMembersRetrieved extends BulkPaymentState {
  const BulkPaymentGroupMembersRetrieved({
    required this.result,
    required this.routeName,
  });

  final Response<BulkPaymentGroupPayees> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class BulkPaymentGroupMembersRetrievedSilently extends BulkPaymentState {
  const BulkPaymentGroupMembersRetrievedSilently({
    required this.result,
    this.routeName,
  });
  final Response<BulkPaymentGroupPayees> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

class RetrieveBulkPaymentGroupMembersError extends BulkPaymentState {
  const RetrieveBulkPaymentGroupMembersError({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class SilentRetrieveBulkPaymentGroupMembersError extends BulkPaymentState {
  const SilentRetrieveBulkPaymentGroupMembersError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// Add payees to group

class AddingPayeesToBulkPaymentGroup extends BulkPaymentState {
  const AddingPayeesToBulkPaymentGroup(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class PayeesAddedToBulkPaymentGroup extends BulkPaymentState {
  const PayeesAddedToBulkPaymentGroup({
    required this.result,
    required this.routeName,
  });

  final Response<BulkPaymentGroupPayees> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class AddPayeesToBulkPaymentGroupError extends BulkPaymentState {
  const AddPayeesToBulkPaymentGroupError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// delete bulk payment group

class DeletingBulkPaymentGroup extends BulkPaymentState {
  const DeletingBulkPaymentGroup(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class BulkPaymentGroupDeleted extends BulkPaymentState {
  const BulkPaymentGroupDeleted({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class DeleteBulkPaymentGroupError extends BulkPaymentState {
  const DeleteBulkPaymentGroupError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// remove payee from bulk payment group

class RemovingPayeeFromBulkPaymentGroup extends BulkPaymentState {
  const RemovingPayeeFromBulkPaymentGroup(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class PayeeRemovedFromBulkPaymentGroup extends BulkPaymentState {
  const PayeeRemovedFromBulkPaymentGroup({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class RemovePayeeFromBulkPaymentGroupError extends BulkPaymentState {
  const RemovePayeeFromBulkPaymentGroupError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// make bulk payment

class MakingBulkPayment extends BulkPaymentState {
  const MakingBulkPayment(this.routeName);
  final String routeName;

  @override
  List<Object> get props => [
        routeName,
      ];
}

class BulkPaymentMade extends BulkPaymentState {
  const BulkPaymentMade({
    required this.result,
    required this.routeName,
  });

  final Response<dynamic> result;
  final String routeName;

  @override
  List<Object> get props => [
        result,
        routeName,
      ];
}

class MakeBulkPaymentError extends BulkPaymentState {
  const MakeBulkPaymentError({
    required this.result,
    this.routeName,
  });

  final Response<dynamic> result;
  final String? routeName;

  @override
  List<Object?> get props => [
        result,
        routeName,
      ];
}

// Go to new Group

class MovingToNewGroup extends BulkPaymentState {
  const MovingToNewGroup();

  @override
  List<Object> get props => [];
}

class MovedToNewGroup extends BulkPaymentState {
  const MovedToNewGroup(this.group);

  final Groups group;

  @override
  List<Object> get props => [
        group,
      ];
}

class MoveToNewGroupError extends BulkPaymentState {
  const MoveToNewGroupError(this.result);

  final Response<dynamic> result;

  @override
  List<Object> get props => [
        result,
      ];
}