import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/bulk_payment/bulk_payment_group_payees.dart';
import '../models/bulk_payment/bulk_payment_groups.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class BulkPaymentRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<BulkPaymentGroups>?> getStoredGroups() async {
    final result = await _db.read('bulk-payment-groups');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = BulkPaymentGroups.fromMap(result['data'] as Map<String, dynamic>);
    return Response(
      code: result['code'].toString(),
      status: result['status'].toString(),
      message: result['message'].toString(),
      data: data,
      imageBaseUrl: result['imageBaseUrl']?.toString(),
      imageDirectory: result['imageDirectory']?.toString(),
      timeStamp: result['timeStamp']?.toString(),
    );
  }

  Future<Response<BulkPaymentGroups>> retrieveGroups() async {
    final response = await _fbl.post(
      path: 'BulkPayment/getUserGroups',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = BulkPaymentGroups.fromMap(response.data as Map<String, dynamic>);
    _db.add(key: 'bulk-payment-groups', payload: {
      'data': response.data,
      'imageBaseUrl': response.imageBaseUrl,
      'imageDirectory': response.imageDirectory,
      'timeStamp': response.timeStamp,
      'code': response.code,
      'status': response.status,
      'message': response.message,
    });

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: data,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<BulkPaymentGroupPayees>?> getStoredGroupMembers(String groupId) async {
    final result = await _db.read('bulk-payment-group-members/$groupId');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = BulkPaymentGroupPayees.fromMap(result['data'] as Map<String, dynamic>);
    return Response(
      code: result['code'].toString(),
      status: result['status'].toString(),
      message: result['message'].toString(),
      data: data,
      imageBaseUrl: result['imageBaseUrl']?.toString(),
      imageDirectory: result['imageDirectory']?.toString(),
      timeStamp: result['timeStamp']?.toString(),
    );
  }

  Future<Response<BulkPaymentGroupPayees>> retrieveGroupMembers(String groupId) async {
    final response = await _fbl.post(
      path: 'BulkPayment/getGroupPayees',
      body: {
        "groupId": groupId,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = BulkPaymentGroupPayees.fromMap(response.data as Map<String, dynamic>);
    _db.add(key: 'bulk-payment-group-members/$groupId', payload: {
      'data': response.data,
      'imageBaseUrl': response.imageBaseUrl,
      'imageDirectory': response.imageDirectory,
      'timeStamp': response.timeStamp,
      'code': response.code,
      'status': response.status,
      'message': response.message,
    });

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: data,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<BulkPaymentGroupPayees>> addPayeesToGroup({
    required String groupId,
    required List<String> payees,
  }) async {
    final response = await _fbl.post(
      path: 'BulkPayment/addGroupPayee',
      body: {
        "groupId": groupId,
        "payees": payees,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = BulkPaymentGroupPayees.fromMap(response.data as Map<String, dynamic>);
    _db.add(key: 'bulk-payment-group-members/$groupId', payload: {
      'data': response.data,
      'imageBaseUrl': response.imageBaseUrl,
      'imageDirectory': response.imageDirectory,
      'timeStamp': response.timeStamp,
      'code': response.code,
      'status': response.status,
      'message': response.message,
    });

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: data,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<List<Groups>>> deleteGroup(String groupId) async {
    final response = await _fbl.post(
      path: 'BulkPayment/deleteGroup',
      body: {
        "groupId": groupId,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final store = await getStoredGroups();
    final data = store?.data?.groups?.where((element) => element.groupId != groupId).toList() ?? [];

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: data,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<Response<BulkPaymentGroupPayees>>> removePayeeFromGroup({
    required String groupId,
    required String payeeId,
  }) async {
    final response = await _fbl.post(
      path: 'BulkPayment/deleteGroupPayee',
      body: {
        "groupId": groupId,
        "payeeId": payeeId,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final store = await getStoredGroupMembers(groupId);
    final data = store?.data?.payees?.where((element) => element.payeeId != payeeId).toList() ?? [];

    final storedResult = store?.copyWith(
      data: store.data!.copyWith(
        group: store.data!.group!.copyWith(
          numberOfPayee: (store.data!.group!.numberOfPayee ?? 0) - 1,
        ),
        payees: data,
      ),
    );

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: storedResult,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<dynamic>> makeGroupPayment({
    required String groupId,
    required String pin,
  }) async {
    final response = await _fbl.post(
      path: 'BulkPayment/payGroup',
      body: {
        "groupId": groupId,
        "auth": {
          'pin': pin,
        },
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response;
  }
}