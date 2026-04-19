import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'collection.dart';

class SupervisorCollectionModel extends Equatable {
  final String? supervisorId;
  final String? agentId;
  final int? agentCode;
  final String? agentName;
  final Collection? collection;

  const SupervisorCollectionModel({
    this.supervisorId,
    this.agentId,
    this.agentCode,
    this.agentName,
    this.collection,
  });

  factory SupervisorCollectionModel.fromMap(Map<String, dynamic> data) {
    return SupervisorCollectionModel(
      supervisorId: data['supervisorId'] as String?,
      agentId: data['agentId'] as String?,
      agentCode: data['agentCode'] as int?,
      agentName: data['agentName'] as String?,
      collection: data['collection'] == null
          ? null
          : Collection.fromMap(data['collection'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisorId': supervisorId,
    'agentId': agentId,
    'agentCode': agentCode,
    'agentName': agentName,
    'collection': collection?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SupervisorCollectionModel].
  factory SupervisorCollectionModel.fromJson(String data) {
    return SupervisorCollectionModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SupervisorCollectionModel] to a JSON string.
  String toJson() => json.encode(toMap());

  SupervisorCollectionModel copyWith({
    String? supervisorId,
    String? agentId,
    int? agentCode,
    String? agentName,
    Collection? collection,
  }) {
    return SupervisorCollectionModel(
      supervisorId: supervisorId ?? this.supervisorId,
      agentId: agentId ?? this.agentId,
      agentCode: agentCode ?? this.agentCode,
      agentName: agentName ?? this.agentName,
      collection: collection ?? this.collection,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [supervisorId, agentId, agentCode, agentName, collection];
  }
}
