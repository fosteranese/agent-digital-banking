import 'dart:convert';

import 'package:equatable/equatable.dart';

class Reversal extends Equatable {
  final String? id;
  final String? collectionId;
  final String? agentId;
  final int? agentCode;
  final int? status;
  final String? statusLabel;
  final DateTime? dateCreated;
  final String? createdBy;
  final dynamic dateModified;
  final dynamic approvedBy;
  final dynamic approvedDate;
  final String? requestDate;
  final String? reason;
  final String? comment;
  final int? cbsstatus;
  final String? cbslabel;
  final dynamic cbsreference;

  const Reversal({
    this.id,
    this.collectionId,
    this.agentId,
    this.agentCode,
    this.status,
    this.statusLabel,
    this.dateCreated,
    this.createdBy,
    this.dateModified,
    this.approvedBy,
    this.approvedDate,
    this.requestDate,
    this.reason,
    this.comment,
    this.cbsstatus,
    this.cbslabel,
    this.cbsreference,
  });

  factory Reversal.fromMap(Map<String, dynamic> data) => Reversal(
    id: data['id'] as String?,
    collectionId: data['collectionId'] as String?,
    agentId: data['agentId'] as String?,
    agentCode: data['agentCode'] as int?,
    status: data['status'] as int?,
    statusLabel: data['statusLabel'] as String?,
    dateCreated: data['dateCreated'] == null ? null : DateTime.parse(data['dateCreated'] as String),
    createdBy: data['createdBy'] as String?,
    dateModified: data['dateModified'] as dynamic,
    approvedBy: data['approvedBy'] as dynamic,
    approvedDate: data['approvedDate'] as dynamic,
    requestDate: data['requestDate'] as String?,
    reason: data['reason'] as String?,
    comment: data['comment'] as String?,
    cbsstatus: data['cbsstatus'] as int?,
    cbslabel: data['cbslabel'] as String?,
    cbsreference: data['cbsreference'] as dynamic,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'collectionId': collectionId,
    'agentId': agentId,
    'agentCode': agentCode,
    'status': status,
    'statusLabel': statusLabel,
    'dateCreated': dateCreated?.toIso8601String(),
    'createdBy': createdBy,
    'dateModified': dateModified,
    'approvedBy': approvedBy,
    'approvedDate': approvedDate,
    'requestDate': requestDate,
    'reason': reason,
    'comment': comment,
    'cbsstatus': cbsstatus,
    'cbslabel': cbslabel,
    'cbsreference': cbsreference,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Reversal].
  factory Reversal.fromJson(String data) {
    return Reversal.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Reversal] to a JSON string.
  String toJson() => json.encode(toMap());

  Reversal copyWith({
    String? id,
    String? collectionId,
    String? agentId,
    int? agentCode,
    int? status,
    String? statusLabel,
    DateTime? dateCreated,
    String? createdBy,
    dynamic dateModified,
    dynamic approvedBy,
    dynamic approvedDate,
    String? requestDate,
    String? reason,
    String? comment,
    int? cbsstatus,
    String? cbslabel,
    dynamic cbsreference,
  }) {
    return Reversal(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      agentId: agentId ?? this.agentId,
      agentCode: agentCode ?? this.agentCode,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      dateCreated: dateCreated ?? this.dateCreated,
      createdBy: createdBy ?? this.createdBy,
      dateModified: dateModified ?? this.dateModified,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      requestDate: requestDate ?? this.requestDate,
      reason: reason ?? this.reason,
      comment: comment ?? this.comment,
      cbsstatus: cbsstatus ?? this.cbsstatus,
      cbslabel: cbslabel ?? this.cbslabel,
      cbsreference: cbsreference ?? this.cbsreference,
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
      agentCode,
      status,
      statusLabel,
      dateCreated,
      createdBy,
      dateModified,
      approvedBy,
      approvedDate,
      requestDate,
      reason,
      comment,
      cbsstatus,
      cbslabel,
      cbsreference,
    ];
  }
}
