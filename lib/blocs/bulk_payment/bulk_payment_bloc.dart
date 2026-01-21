import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/bulk_payment/bulk_payment_group_payees.dart';
import '../../data/models/bulk_payment/bulk_payment_groups.dart';
import '../../data/models/response.modal.dart';
import '../../data/repository/bulk_payment.repo.dart';
import '../../utils/response.util.dart';

part 'bulk_payment_event.dart';
part 'bulk_payment_state.dart';

class BulkPaymentBloc extends Bloc<BulkPaymentEvent, BulkPaymentState> {
  BulkPaymentBloc() : super(BulkPaymentInitial()) {
    on(_onRetrieveBulkPaymentGroups);
    on(_onSilentRetrieveBulkPaymentGroups);

    on(_onDeleteBulkPaymentGroup);

    on(_onRetrieveBulkPaymentGroupMembers);
    on(_onSilentRetrieveBulkPaymentGroupMember);

    on(_onAddPayeesToBulkPaymentGroup);
    on(_onRemovePayeeFromBulkPaymentGroup);

    on(_onMakeBulkPayment);

    on(_onGotoNewGroup);
  }

  final _repo = BulkPaymentRepo();
  Response<BulkPaymentGroups> groups = const Response(
    code: '',
    status: '',
    message: '',
    data: null,
  );
  Map<String, Response<BulkPaymentGroupPayees>> groupMembers = {};

  Future<void> _onRetrieveBulkPaymentGroups(
    RetrieveBulkPaymentGroups event,
    Emitter<BulkPaymentState> emit,
  ) async {
    Response<BulkPaymentGroups>? stored;

    try {
      if (groups.data?.groups?.isNotEmpty ?? false) {
        emit(BulkPaymentGroupsRetrieved(result: groups, routeName: event.routeName));

        await Future.delayed(const Duration(milliseconds: 200));
        emit(SilentRetrievingBulkPaymentGroups(event.routeName));
      } else {
        emit(RetrievingBulkPaymentGroups(event.routeName));
      }

      stored = await _repo.getStoredGroups();
      if (stored != null && (stored.data?.groups?.isNotEmpty ?? false)) {
        groups = stored;
        emit(BulkPaymentGroupsRetrieved(result: groups, routeName: event.routeName));

        await Future.delayed(const Duration(milliseconds: 200));
        emit(SilentRetrievingBulkPaymentGroups(event.routeName));
      }

      final result = await _repo.retrieveGroups();

      if (result.data?.groups?.isNotEmpty ?? false) {
        groups = result;
      }

      if (stored == null || (stored.data?.groups?.isEmpty ?? false)) {
        emit(BulkPaymentGroupsRetrieved(result: result, routeName: event.routeName));
      } else {
        emit(BulkPaymentGroupsRetrievedSilently(result: result, routeName: event.routeName));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.groups?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) =>
              emit(RetrieveBulkPaymentGroupsError(result: error, routeName: event.routeName)),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) =>
              emit(SilentRetrieveBulkPaymentGroupsError(result: error, routeName: event.routeName)),
        );
      }
    }
  }

  Future<void> _onSilentRetrieveBulkPaymentGroups(
    SilentRetrieveBulkPaymentGroups event,
    Emitter<BulkPaymentState> emit,
  ) async {
    try {
      emit(SilentRetrievingBulkPaymentGroups(event.routeName));
      final result = await _repo.retrieveGroups();
      groups = result;
      emit(BulkPaymentGroupsRetrievedSilently(result: result, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) =>
            emit(SilentRetrieveBulkPaymentGroupsError(result: error, routeName: event.routeName)),
      );
    }
  }

  Future<void> _onRetrieveBulkPaymentGroupMembers(
    RetrieveBulkPaymentGroupMembers event,
    Emitter<BulkPaymentState> emit,
  ) async {
    Response<BulkPaymentGroupPayees>? stored;
    final groupId = event.group.groupId ?? '';
    try {
      if (groupMembers[groupId]?.data?.payees?.isNotEmpty ?? false) {
        emit(
          BulkPaymentGroupMembersRetrieved(
            result: groupMembers[groupId]!,
            routeName: event.routeName,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 200));
        emit(SilentRetrievingBulkPaymentGroupMembers(event.routeName));
      } else {
        emit(RetrievingBulkPaymentGroupMembers(event.routeName));
      }

      stored = await _repo.getStoredGroupMembers(groupId);
      if (stored != null && (stored.data?.payees?.isNotEmpty ?? false)) {
        groupMembers[groupId] = stored;
        emit(
          BulkPaymentGroupMembersRetrieved(
            result: groupMembers[groupId]!,
            routeName: event.routeName,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 200));
        emit(SilentRetrievingBulkPaymentGroupMembers(event.routeName));
      }

      final result = await _repo.retrieveGroupMembers(groupId);

      if (result.data?.payees?.isNotEmpty ?? false) {
        groupMembers[groupId] = result;
      }

      if (stored == null || (stored.data?.payees?.isEmpty ?? false)) {
        emit(BulkPaymentGroupMembersRetrieved(result: result, routeName: event.routeName));
      } else {
        emit(BulkPaymentGroupMembersRetrievedSilently(result: result, routeName: event.routeName));
      }
    } catch (ex) {
      if (stored == null || (stored.data?.payees?.isEmpty ?? false)) {
        ResponseUtil.handleException(
          ex,
          (error) =>
              emit(RetrieveBulkPaymentGroupMembersError(result: error, routeName: event.routeName)),
        );
      } else {
        ResponseUtil.handleException(
          ex,
          (error) => emit(
            SilentRetrieveBulkPaymentGroupMembersError(result: error, routeName: event.routeName),
          ),
        );
      }
    }
  }

  Future<void> _onSilentRetrieveBulkPaymentGroupMember(
    SilentRetrieveBulkPaymentGroupMembers event,
    Emitter<BulkPaymentState> emit,
  ) async {
    try {
      final groupId = event.group.groupId ?? '';
      emit(SilentRetrievingBulkPaymentGroups(event.routeName));
      final result = await _repo.retrieveGroupMembers(groupId);
      groupMembers[groupId] = result;
      emit(BulkPaymentGroupMembersRetrievedSilently(result: result, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SilentRetrieveBulkPaymentGroupMembersError(result: error, routeName: event.routeName),
        ),
      );
    }
  }

  Future<void> _onAddPayeesToBulkPaymentGroup(
    AddPayeesToBulkPaymentGroup event,
    Emitter<BulkPaymentState> emit,
  ) async {
    try {
      emit(AddingPayeesToBulkPaymentGroup(event.routeName));

      final result = await _repo.addPayeesToGroup(
        groupId: event.group.groupId ?? '',
        payees: event.payees,
      );

      groupMembers[event.group.groupId ?? ''] = result;

      emit(PayeesAddedToBulkPaymentGroup(result: result, routeName: event.routeName));

      emit(BulkPaymentGroupMembersRetrieved(result: result, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(
          SilentRetrieveBulkPaymentGroupMembersError(result: error, routeName: event.routeName),
        ),
      );
    }
  }

  Future<void> _onDeleteBulkPaymentGroup(
    DeleteBulkPaymentGroup event,
    Emitter<BulkPaymentState> emit,
  ) async {
    try {
      emit(DeletingBulkPaymentGroup(event.routeName));

      final result = await _repo.deleteGroup(event.group.groupId ?? '');
      if (groups.data != null) {
        groups = Response(
          code: groups.code,
          status: groups.status,
          message: groups.message,
          data: groups.data!.copyWith(groups: result.data),
        );
      }
      emit(BulkPaymentGroupsRetrieved(result: groups, routeName: event.routeName));

      emit(BulkPaymentGroupDeleted(result: result, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(DeleteBulkPaymentGroupError(result: error, routeName: event.routeName)),
      );
    }
  }

  Future<void> _onRemovePayeeFromBulkPaymentGroup(
    RemovePayeeFromBulkPaymentGroup event,
    Emitter<BulkPaymentState> emit,
  ) async {
    try {
      final groupId = event.group.groupId ?? '';
      emit(RemovingPayeeFromBulkPaymentGroup(event.routeName));

      final result = await _repo.removePayeeFromGroup(
        groupId: groupId,
        payeeId: event.payee.payeeId ?? '',
      );

      emit(PayeeRemovedFromBulkPaymentGroup(result: result, routeName: event.routeName));

      if (result.data != null) {
        groups = groups.copyWith(
          data: groups.data!.copyWith(
            groups: groups.data!.groups!.map((e) {
              if (e.groupId != event.group.groupId) {
                return e;
              }

              return result.data!.data!.group!;
            }).toList(),
          ),
        );
        emit(BulkPaymentGroupsRetrieved(result: groups, routeName: event.routeName));

        groupMembers[groupId] = result.data!;
        emit(BulkPaymentGroupMembersRetrieved(result: result.data!, routeName: event.routeName));
      }
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) =>
            emit(RemovePayeeFromBulkPaymentGroupError(result: error, routeName: event.routeName)),
      );
    }
  }

  Future<void> _onMakeBulkPayment(MakeBulkPayment event, Emitter<BulkPaymentState> emit) async {
    try {
      emit(MakingBulkPayment(event.routeName));

      final result = await _repo.makeGroupPayment(
        groupId: event.group.groupId ?? '',
        pin: event.pin,
      );

      emit(BulkPaymentMade(result: result, routeName: event.routeName));
    } catch (ex) {
      ResponseUtil.handleException(
        ex,
        (error) => emit(MakeBulkPaymentError(result: error, routeName: event.routeName)),
      );
    }
  }

  Future<void> _onGotoNewGroup(GotoNewGroup event, Emitter<BulkPaymentState> emit) async {
    try {
      emit(const MovingToNewGroup());
      final oldGroups = groups.data?.groups?.map((group) => group.groupId) ?? [];

      await _onSilentRetrieveBulkPaymentGroups(const SilentRetrieveBulkPaymentGroups(''), emit);

      final newGroups = groups.data?.groups?.where(
        (group) => !oldGroups.any((groupId) => groupId == group.groupId),
      );
      final newGroup = (newGroups?.isNotEmpty ?? false)
          ? newGroups!.last
          : groups.data?.groups?.last;

      emit(MovedToNewGroup(newGroup!));
    } catch (ex) {
      ResponseUtil.handleException(ex, (error) => emit(MoveToNewGroupError(error)));
    }
  }
}
