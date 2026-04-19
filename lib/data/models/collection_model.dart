import 'dart:convert';

import 'package:my_sage_agent/data/models/agent_collection_model.dart';
import 'package:my_sage_agent/data/models/supervisor_collection_data/supervisor_collection.dart';

class CollectionModel {
  final AgentCollectionModel? agent;
  final SupervisorCollectionModel? supervisor;

  const CollectionModel({this.agent, this.supervisor});

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

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      agent: map['agent'] != null ? AgentCollectionModel.fromMap(map['agent']) : null,
      supervisor: map['supervisor'] != null
          ? SupervisorCollectionModel.fromMap(map['supervisor'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionModel.fromJson(String source) => CollectionModel.fromMap(json.decode(source));
}
