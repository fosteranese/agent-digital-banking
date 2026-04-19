import 'dart:convert';

import 'package:equatable/equatable.dart';

class ActivityRecordModel extends Equatable {
  final String? requestId;
  final String? agentId;
  final String? customerId;
  final String? serviceId;
  final String? requestStatus;
  final String? createdBy;
  final int? status;
  final String? statusLabel;
  final DateTime? dateCreated;
  final String? transDate;
  final String? longitude;
  final String? latitude;
  final String? sessionId;
  final String? agentName;
  final String? customerName;
  final String? serviceName;
  final double? amount;

  const ActivityRecordModel({
    this.requestId,
    this.agentId,
    this.customerId,
    this.serviceId,
    this.requestStatus,
    this.createdBy,
    this.status,
    this.statusLabel,
    this.dateCreated,
    this.transDate,
    this.longitude,
    this.latitude,
    this.sessionId,
    this.agentName,
    this.customerName,
    this.serviceName,
    this.amount,
  });

  factory ActivityRecordModel.fromMap(Map<String, dynamic> data) => ActivityRecordModel(
    requestId: data['requestId'] as String?,
    agentId: data['agentId'] as String?,
    customerId: data['customerId'] as String?,
    serviceId: data['serviceId'] as String?,
    requestStatus: data['requestStatus'] as String?,
    createdBy: data['createdBy'] as String?,
    status: data['status'] as int?,
    statusLabel: data['statusLabel'] as String?,
    dateCreated: data['dateCreated'] == null ? null : DateTime.parse(data['dateCreated'] as String),
    transDate: data['transDate'] as String?,
    longitude: data['longitude'] as String?,
    latitude: data['latitude'] as String?,
    sessionId: data['sessionId'] as String?,
    agentName: data['agentName'] as String?,
    customerName: data['customerName'] as String?,
    serviceName: data['serviceName'] as String?,
    amount: (data['amount'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'requestId': requestId,
    'agentId': agentId,
    'customerId': customerId,
    'serviceId': serviceId,
    'requestStatus': requestStatus,
    'createdBy': createdBy,
    'status': status,
    'statusLabel': statusLabel,
    'dateCreated': dateCreated?.toIso8601String(),
    'transDate': transDate,
    'longitude': longitude,
    'latitude': latitude,
    'sessionId': sessionId,
    'agentName': agentName,
    'customerName': customerName,
    'serviceName': serviceName,
    'amount': amount,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ActivityRecordModel].
  factory ActivityRecordModel.fromJson(String data) {
    return ActivityRecordModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ActivityRecordModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ActivityRecordModel copyWith({
    String? requestId,
    String? agentId,
    String? customerId,
    String? serviceId,
    String? requestStatus,
    String? createdBy,
    int? status,
    String? statusLabel,
    DateTime? dateCreated,
    String? transDate,
    String? longitude,
    String? latitude,
    String? sessionId,
    String? agentName,
    String? customerName,
    String? serviceName,
    double? amount,
  }) {
    return ActivityRecordModel(
      requestId: requestId ?? this.requestId,
      agentId: agentId ?? this.agentId,
      customerId: customerId ?? this.customerId,
      serviceId: serviceId ?? this.serviceId,
      requestStatus: requestStatus ?? this.requestStatus,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      dateCreated: dateCreated ?? this.dateCreated,
      transDate: transDate ?? this.transDate,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      sessionId: sessionId ?? this.sessionId,
      agentName: agentName ?? this.agentName,
      customerName: customerName ?? this.customerName,
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      requestId,
      agentId,
      customerId,
      serviceId,
      requestStatus,
      createdBy,
      status,
      statusLabel,
      dateCreated,
      transDate,
      longitude,
      latitude,
      sessionId,
      agentName,
      customerName,
      serviceName,
      amount,
    ];
  }
}
