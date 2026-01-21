import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/collection_model.dart';
import 'package:my_sage_agent/data/models/commission_model.dart';
import 'package:my_sage_agent/data/models/history/activity.dart';
import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/remote/main.remote.dart';

class HistoryRepo {
  final _db = Database();
  final _fbl = MainRemote();

  void storeCommissions(List<CommissionModel> list) {
    _db.add(key: 'commissions', payload: {'list': list});
  }

  Future<List<CommissionModel>?> getStoredCommissions({Activity? activity}) async {
    final result = await _db.read('commissions');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = (result['list'] as List<dynamic>).map((item) {
      return CommissionModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<List<CommissionModel>> loadCommissions({String? dateFrom, String? dateTo}) async {
    dateFrom = (dateFrom?.isNotEmpty ?? false) ? dateFrom : null;
    dateTo = (dateTo?.isNotEmpty ?? false) ? dateTo : null;

    final response = await _fbl.post(
      path: 'FieldExecutive/getAgentCommissions',
      body: {'dateFrom': dateFrom, 'dateTo': dateTo},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = (response.data['list'] as List<dynamic>).map((item) {
      return CommissionModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    storeCommissions(list);

    return list;
  }

  void storeCollections(List<CollectionModel> list) {
    _db.add(key: 'collections', payload: {'list': list});
  }

  Future<List<CollectionModel>?> getStoredCollections({Activity? activity}) async {
    final result = await _db.read('collections');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = (result['list'] as List<dynamic>).map((item) {
      return CollectionModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<List<CollectionModel>> loadCollections() async {
    final response = await _fbl.post(
      path: 'FieldExecutive/getAgentCollections',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = (response.data['list'] as List<dynamic>).map((item) {
      return CollectionModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    storeCollections(list);

    return list;
  }

  Future<HistoryResponse?> getStoredHistory({Activity? activity}) async {
    final result = await _db.read('history');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = HistoryResponse.fromMap(result['data'] as Map<String, dynamic>);
    final filtered = (activity == null)
        ? data
        : data.copyWith(
            request: data.request?.where((item) {
              return item.activityName == activity.activityName;
            }).toList(),
          );

    return filtered;
  }

  Future<HistoryResponse> loadHistory({
    Activity? activity,
    String? dateFrom,
    String? dateTo,
  }) async {
    dateFrom = (dateFrom?.isNotEmpty ?? false) ? dateFrom : null;
    dateTo = (dateTo?.isNotEmpty ?? false) ? dateTo : null;

    final response = await _fbl.post(
      path: 'MyAccount/history',
      body: {'activityId': activity?.activityId, 'dateFrom': dateFrom, 'dateTo': dateTo},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = HistoryResponse.fromMap(response.data as Map<String, dynamic>);
    storeHistory(data);

    return data;
  }

  void storeHistory(HistoryResponse response) {
    _db.add(key: 'history', payload: response);
  }
}
