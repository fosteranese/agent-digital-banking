import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/history/activity.dart';
import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/models/team_members_model/agent.dart';
import 'package:my_sage_agent/data/models/team_members_model/team_members_model.dart';
import 'package:my_sage_agent/data/remote/main.remote.dart';

class TeamRepo {
  final _db = Database();
  final _fbl = MainRemote();

  void storeTeamMembers(List<Agent> list) {
    _db.add(key: 'team-members', payload: {'list': list});
  }

  Future<List<Agent>?> getStoredTeamMembers({Activity? activity}) async {
    final result = await _db.read('team-members');

    if (result == null || result['list'] == null) {
      return null;
    }

    final list = (result['list'] as List<dynamic>).map((item) {
      if (item is String) {
        return Agent.fromJson(item);
      }

      return Agent.fromMap(item as Map<String, dynamic>);
    }).toList();

    return list;
  }

  Future<List<Agent>> loadTeamMembers({String? name, String? code}) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/allSupervisorAgents',
      body: {'name': name, 'code': code},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final result = TeamMembersModel.fromMap(response.data as Map<String, dynamic>);
    final list = result.agents ?? [];
    storeTeamMembers(list);

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
