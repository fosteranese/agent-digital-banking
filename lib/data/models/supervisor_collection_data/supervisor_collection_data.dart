import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'supervisor_collection.dart';
import 'supervisor.dart';

class SupervisorCollectionData extends Equatable {
  final Supervisor? supervisor;
  final List<SupervisorCollectionModel>? agentCollections;

  const SupervisorCollectionData({this.supervisor, this.agentCollections});

  factory SupervisorCollectionData.fromMap(Map<String, dynamic> data) {
    return SupervisorCollectionData(
      supervisor: data['supervisor'] == null
          ? null
          : Supervisor.fromMap(data['supervisor'] as Map<String, dynamic>),
      agentCollections: (data['agentCollections'] as List<dynamic>?)
          ?.map((e) => SupervisorCollectionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisor': supervisor?.toMap(),
    'agentCollections': agentCollections?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SupervisorCollectionData].
  factory SupervisorCollectionData.fromJson(String data) {
    return SupervisorCollectionData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SupervisorCollectionData] to a JSON string.
  String toJson() => json.encode(toMap());

  SupervisorCollectionData copyWith({
    Supervisor? supervisor,
    List<SupervisorCollectionModel>? agentCollections,
  }) {
    return SupervisorCollectionData(
      supervisor: supervisor ?? this.supervisor,
      agentCollections: agentCollections ?? this.agentCollections,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [supervisor, agentCollections];
}
