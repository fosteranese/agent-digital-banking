import 'dart:convert';

import 'package:equatable/equatable.dart';

class CommissionModel extends Equatable {
  final String? commissionId;
  final String? agentId;
  final String? agentName;
  final String? serviceId;
  final String? serviceName;
  final String? transactionId;
  final String? narration;
  final double? amount;
  final DateTime? dateCreated;
  final String? transDate;
  final String? createdBy;
  final int? status;
  final String? statusLabel;

  const CommissionModel({
    this.commissionId,
    this.agentId,
    this.agentName,
    this.serviceId,
    this.serviceName,
    this.transactionId,
    this.narration,
    this.amount,
    this.dateCreated,
    this.transDate,
    this.createdBy,
    this.status,
    this.statusLabel,
  });

  factory CommissionModel.fromMap(Map<String, dynamic> data) {
    return CommissionModel(
      commissionId: data['commissionId'] as String?,
      agentId: data['agentId'] as String?,
      agentName: data['agentName'] as String?,
      serviceId: data['serviceId'] as String?,
      serviceName: data['serviceName'] as String?,
      transactionId: data['transactionId'] as String?,
      narration: data['narration'] as String?,
      amount: (data['amount'] as num?)?.toDouble(),
      dateCreated: data['dateCreated'] == null
          ? null
          : DateTime.parse(data['dateCreated'] as String),
      transDate: data['transDate'] as String?,
      createdBy: data['createdBy'] as String?,
      status: data['status'] as int?,
      statusLabel: data['statusLabel'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'commissionId': commissionId,
    'agentId': agentId,
    'agentName': agentName,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'transactionId': transactionId,
    'narration': narration,
    'amount': amount,
    'dateCreated': dateCreated?.toIso8601String(),
    'transDate': transDate,
    'createdBy': createdBy,
    'status': status,
    'statusLabel': statusLabel,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CommissionModel].
  factory CommissionModel.fromJson(String data) {
    return CommissionModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CommissionModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CommissionModel copyWith({
    String? commissionId,
    String? agentId,
    String? agentName,
    String? serviceId,
    String? serviceName,
    String? transactionId,
    String? narration,
    double? amount,
    DateTime? dateCreated,
    String? transDate,
    String? createdBy,
    int? status,
    String? statusLabel,
  }) {
    return CommissionModel(
      commissionId: commissionId ?? this.commissionId,
      agentId: agentId ?? this.agentId,
      agentName: agentName ?? this.agentName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      transactionId: transactionId ?? this.transactionId,
      narration: narration ?? this.narration,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
      transDate: transDate ?? this.transDate,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      commissionId,
      agentId,
      agentName,
      serviceId,
      serviceName,
      transactionId,
      narration,
      amount,
      dateCreated,
      transDate,
      createdBy,
      status,
      statusLabel,
    ];
  }
}
