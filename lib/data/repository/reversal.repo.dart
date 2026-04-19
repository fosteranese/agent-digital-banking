import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/agent_reversal_request_model/agent_reversal_request_model.dart';
import 'package:my_sage_agent/data/models/history/activity.dart';
import 'package:my_sage_agent/data/models/reversal_model/reversal_model.dart';
import 'package:my_sage_agent/data/remote/main.remote.dart';
import 'package:string_validator/string_validator.dart';

class ReversalRepo {
  final _db = Database();
  final _fbl = MainRemote();

  void storeReversals(List<ReversalModel> list, int? status) {
    _db.add(key: 'reversals-$status', payload: {'list': list});
  }

  Future<List<ReversalModel>?> getStoredReversals({Activity? activity}) async {
    final result = await _db.read('reversals');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = (result['list'] as List<dynamic>).map((item) {
      if (item is String) {
        return ReversalModel.fromJson(item);
      }

      return ReversalModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<List<ReversalModel>> loadReversals({
    int? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sDate = startDate?.toIso8601String();
    final eDate = endDate?.toIso8601String();

    final response = await _fbl.post(
      path: 'FieldExecutive/getSupervisorAgentCollectionsReversal',
      body: {
        "draw": 0,
        "index": 0,
        "search": "string",
        "filter": {"status": status, "createdStartDate": sDate, "createdEndDate": eDate},
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = (response.data['list'] as List<dynamic>).map((item) {
      return ReversalModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    storeReversals(list, status);

    return list;
  }

  Future<List<AgentReversalRequestModel>> loadSupervisorAgentReversals({
    required String agentCode,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final sDate = startDate?.toIso8601String();
    final eDate = endDate?.toIso8601String();
    final response = await _fbl.post(
      path: 'FieldExecutive/getAgentReversalsByAgentCode',
      body: {"agentcode": agentCode.toInt(), "startDate": sDate, "endDate": eDate},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final list = (response.data['list'] as List<dynamic>).map((item) {
      return AgentReversalRequestModel.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }
}
