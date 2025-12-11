import 'dart:convert';

import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/account/account.dart';
import '../models/account/mini_statement.dart';
import '../models/account/source.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class AccountRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<Response<List<Account>>?>
  getStoredAccounts() async {
    final result = await _db.read('all-accounts');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = result['list'] != null
        ? (result['list'] as List<dynamic>)
              .map((e) => Account.fromMap(e))
              .toList()
        : <Account>[];
    return Response(
      code: result['code'].toString(),
      status: result['status'].toString(),
      message: result['message'].toString(),
      data: list,
      imageBaseUrl: result['imageBaseUrl']?.toString(),
      imageDirectory: result['imageDirectory']?.toString(),
      timeStamp: result['timeStamp']?.toString(),
    );
  }

  Future<Response<List<Account>>> retrieveAccounts() async {
    final response = await _fbl.post(
      path: 'MyAccount/allAccount',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = response.data['list'] != null
        ? (response.data['list'] as List<dynamic>)
              .map((e) => Account.fromMap(e))
              .toList()
        : <Account>[];
    if (list.isNotEmpty) {
      _db.add(
        key: 'all-accounts',
        payload: {
          'list': response.data['list'],
          'imageBaseUrl': response.imageBaseUrl,
          'imageDirectory': response.imageDirectory,
          'timeStamp': response.timeStamp,
          'code': response.code,
          'status': response.status,
          'message': response.message,
        },
      );
    }

    return Response(
      code: response.code,
      message: response.message,
      status: response.status,
      data: list,
      imageBaseUrl: response.imageBaseUrl,
      imageDirectory: response.imageDirectory,
      timeStamp: response.timeStamp,
    );
  }

  Future<Response<MiniStatement>?> getStoredMiniStatement(
    Source source,
  ) async {
    final sourceValue = base64.encode(
      utf8.encode(source.value ?? ''),
    );
    final result = await _db.read(
      'mini-statement/$sourceValue',
    );

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = MiniStatement.fromMap(result['data']);

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

  Future<Response<MiniStatement>> retrieveMiniStatement({
    required Source source,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // final start;
    // final end;
    final response = await _fbl.post(
      path: 'MyAccount/miniStatement',
      body: {
        'sourceValue': source.value,
        'startDate': startDate != null
            ? '${startDate.year.toString().padLeft(4)}-${startDate.month.toString().padLeft(2)}-${startDate.day.toString().padLeft(2)}'
            : null,
        'endDate': endDate != null
            ? '${endDate.year.toString().padLeft(4)}-${endDate.month.toString().padLeft(2)}-${endDate.day.toString().padLeft(2)}'
            : null,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = MiniStatement.fromMap(response.data);
    if (startDate == null &&
        endDate == null &&
        (data.transactions?.isNotEmpty ?? false)) {
      final sourceValue = base64.encode(
        utf8.encode(source.value ?? ''),
      );
      _db.add(
        key: 'mini-statement/$sourceValue',
        payload: {
          'data': response.data,
          'imageBaseUrl': response.imageBaseUrl,
          'imageDirectory': response.imageDirectory,
          'timeStamp': response.timeStamp,
          'code': response.code,
          'status': response.status,
          'message': response.message,
        },
      );
    }

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
}
