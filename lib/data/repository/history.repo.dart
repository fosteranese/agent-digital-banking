import 'package:string_validator/string_validator.dart';

import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/activity_history_model.dart';
import 'package:my_sage_agent/data/models/activity_service_request_model/activity_service_request_model.dart';
import 'package:my_sage_agent/data/models/activity_service_request_model/record.dart';
import 'package:my_sage_agent/data/models/agent_collection_model.dart';
import 'package:my_sage_agent/data/models/collection_model.dart';
import 'package:my_sage_agent/data/models/commission_model.dart';
import 'package:my_sage_agent/data/models/history/activity.dart';
import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/models/supervisor_activity_model/supervisor_activity_model.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_data/supervisor_collection.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_data/supervisor_collection_data.dart';
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

  void storeSupervisorCollections(List<CollectionModel> list) {
    _db.add(key: 'supervisor_collections', payload: {'list': list});
  }

  Future<List<CollectionModel>?> getStoredCollections({Activity? activity}) async {
    final result = await _db.read('collections');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = (result['list'] as List<dynamic>).map((item) {
      return CollectionModel(agent: AgentCollectionModel.fromMap(item as Map<String, dynamic>));
    }).toList();

    return list;
  }

  Future<List<CollectionModel>?> getStoredSupervisorCollections({Activity? activity}) async {
    final result = await _db.read('supervisor_collections');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = (result['list'] as List<dynamic>).map((item) {
      return CollectionModel(
        supervisor: SupervisorCollectionModel.fromMap(item as Map<String, dynamic>),
      );
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
      return CollectionModel(agent: AgentCollectionModel.fromMap(item as Map<String, dynamic>));
    }).toList();

    storeCollections(list);

    return list;
  }

  Future<List<CollectionModel>> loadSupervisorCollections() async {
    final response = await _fbl.post(
      path: 'FieldExecutive/AllSupervisorAgentsCollections',
      body: {},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final result = SupervisorCollectionData.fromMap(response.data as Map<String, dynamic>);
    final list =
        result.agentCollections?.map((item) => CollectionModel(supervisor: item)).toList() ?? [];

    storeSupervisorCollections(list);

    return list;
  }

  Future<List<AgentCollectionModel>> loadSupervisorAgentCollections({
    required String agentCode,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sDate = startDate?.toIso8601String();
    final eDate = endDate?.toIso8601String();
    final response = await _fbl.post(
      path: 'FieldExecutive/getAgentCollectionsByAgentCode',
      body: {"agentcode": agentCode.toInt(), "startDate": sDate, "endDate": eDate},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = (response.data['list'] as List<dynamic>).map((item) {
      return AgentCollectionModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<List<ActivityRecordModel>> loadSupervisorAgentActivities({
    required String agentCode,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sDate = startDate?.toIso8601String();
    final eDate = endDate?.toIso8601String();
    final response = await _fbl.post(
      path: 'FieldExecutive/getAgentServiceRequestsByAgentCode',
      body: {"agentcode": agentCode.toInt(), "startDate": sDate, "endDate": eDate},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final result = ActivityServiceRequestModel.fromMap(response.data as Map<String, dynamic>);
    return result.records ?? [];
  }

  Future<List<CommissionModel>> loadSupervisorAgentCommissions({
    required String agentCode,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sDate = startDate?.toIso8601String();
    final eDate = endDate?.toIso8601String();
    final response = await _fbl.post(
      path: 'FieldExecutive/getAgentCommissionsByAgentCode',
      body: {"agentcode": agentCode.toInt(), "startDate": sDate, "endDate": eDate},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = (response.data['list'] as List<dynamic>).map((item) {
      return CommissionModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<ActivityHistoryModel?> getStoredHistory({Activity? activity}) async {
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

    return ActivityHistoryModel(agent: filtered);
  }

  Future<ActivityHistoryModel?> getStoredSupervisorHistory({Activity? activity}) async {
    final result = await _db.read('supervisor-history');

    if (result == null || result['data'] == null) {
      return null;
    }

    final data = SupervisorActivityModel.fromMap(result['data'] as Map<String, dynamic>);
    final filtered = (activity == null)
        ? data
        : data.copyWith(
            serviceRequests: data.serviceRequests?.where((item) {
              return item.request?.serviceName == activity.activityName;
            }).toList(),
          );

    return ActivityHistoryModel(supervisor: filtered);
  }

  Future<ActivityHistoryModel> loadHistory({
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

    return ActivityHistoryModel(agent: data);
  }

  Future<ActivityHistoryModel> loadSupervisorHistory({
    Activity? activity,
    String? dateFrom,
    String? dateTo,
  }) async {
    dateFrom = (dateFrom?.isNotEmpty ?? false) ? dateFrom : null;
    dateTo = (dateTo?.isNotEmpty ?? false) ? dateTo : null;

    final response = await _fbl.post(
      path: 'FieldExecutive/AllSupervisorAgentsServiceRequests',
      body: {'activityId': activity?.activityId, 'dateFrom': dateFrom, 'dateTo': dateTo},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }
    final data = SupervisorActivityModel.fromMap(response.data as Map<String, dynamic>);
    storeSupervisorHistory(data);

    return ActivityHistoryModel(supervisor: data);
  }

  void storeHistory(HistoryResponse response) {
    _db.add(key: 'history', payload: response);
  }

  void storeSupervisorHistory(SupervisorActivityModel response) {
    _db.add(key: 'supervisor-history', payload: response);
  }
}
