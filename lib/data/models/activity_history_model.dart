import 'dart:convert';

import 'package:my_sage_agent/data/models/history/history.response.dart';
import 'package:my_sage_agent/data/models/supervisor_activity_model/supervisor_activity_model.dart';

class ActivityHistoryModel {
  final HistoryResponse? agent;
  final SupervisorActivityModel? supervisor;

  ActivityHistoryModel({this.agent, this.supervisor});

  ActivityHistoryModel copyWith({HistoryResponse? agent, SupervisorActivityModel? supervisor}) {
    return ActivityHistoryModel(
      agent: agent ?? this.agent,
      supervisor: supervisor ?? this.supervisor,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (agent != null) {
      result.addAll({'agent': agent!.toMap()});
    }
    if (supervisor != null) {
      result.addAll({'supervisor': supervisor!.toMap()});
    }

    return result;
  }

  factory ActivityHistoryModel.fromMap(Map<String, dynamic> map) {
    return ActivityHistoryModel(
      agent: map['agent'] != null ? HistoryResponse.fromMap(map['agent']) : null,
      supervisor: map['supervisor'] != null
          ? SupervisorActivityModel.fromMap(map['supervisor'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityHistoryModel.fromJson(String source) =>
      ActivityHistoryModel.fromMap(json.decode(source));
}
