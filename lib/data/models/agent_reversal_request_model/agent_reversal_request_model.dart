import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:my_sage_agent/data/models/agent_collection_model.dart';

class AgentReversalRequestModel extends Equatable {
  final String? id;
  final String? collectionId;
  final String? agentId;
  final int? status;
  final String? statusLabel;
  final int? agentCode;
  final String? requestDate;
  final String? reason;
  final String? comment;
  final AgentCollectionModel? collection;

  const AgentReversalRequestModel({
    this.id,
    this.collectionId,
    this.agentId,
    this.status,
    this.statusLabel,
    this.agentCode,
    this.requestDate,
    this.reason,
    this.comment,
    this.collection,
  });

  factory AgentReversalRequestModel.fromMap(Map<String, dynamic> data) {
    return AgentReversalRequestModel(
      id: data['id'] as String?,
      collectionId: data['collectionId'] as String?,
      agentId: data['agentId'] as String?,
      status: data['status'] as int?,
      statusLabel: data['statusLabel'] as String?,
      agentCode: data['agentCode'] as int?,
      requestDate: data['requestDate'] as String?,
      reason: data['reason'] as String?,
      comment: data['comment'] as String?,
      collection: data['collection'] == null
          ? null
          : AgentCollectionModel.fromMap(data['collection'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'collectionId': collectionId,
    'agentId': agentId,
    'status': status,
    'statusLabel': statusLabel,
    'agentCode': agentCode,
    'requestDate': requestDate,
    'reason': reason,
    'comment': comment,
    'collection': collection?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AgentReversalRequestModel].
  factory AgentReversalRequestModel.fromJson(String data) {
    return AgentReversalRequestModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AgentReversalRequestModel] to a JSON string.
  String toJson() => json.encode(toMap());

  AgentReversalRequestModel copyWith({
    String? id,
    String? collectionId,
    String? agentId,
    int? status,
    String? statusLabel,
    int? agentCode,
    String? requestDate,
    String? reason,
    String? comment,
    AgentCollectionModel? collection,
  }) {
    return AgentReversalRequestModel(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      agentId: agentId ?? this.agentId,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      agentCode: agentCode ?? this.agentCode,
      requestDate: requestDate ?? this.requestDate,
      reason: reason ?? this.reason,
      comment: comment ?? this.comment,
      collection: collection ?? this.collection,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      collectionId,
      agentId,
      status,
      statusLabel,
      agentCode,
      requestDate,
      reason,
      comment,
      collection,
    ];
  }
}
