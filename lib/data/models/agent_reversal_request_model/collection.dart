import 'dart:convert';

import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final String? collectionId;
  final String? agentId;
  final String? agentAccountNumber;
  final String? agentPhoneNumber;
  final String? sessionId;
  final String? agentName;
  final dynamic customerPhoneNumber;
  final String? customerId;
  final String? customerName;
  final String? customerAccountNumber;
  final String? serviceId;
  final String? serviceName;
  final int? amount;
  final int? status;
  final String? statusLabel;
  final String? createdBy;
  final DateTime? dateCreated;
  final String? transDate;
  final String? longitude;
  final String? latitude;
  final int? externalStatus;
  final String? externalStatusLabel;
  final String? externalReference;
  final DateTime? dateProcessed;
  final String? collectionMode;

  const Collection({
    this.collectionId,
    this.agentId,
    this.agentAccountNumber,
    this.agentPhoneNumber,
    this.sessionId,
    this.agentName,
    this.customerPhoneNumber,
    this.customerId,
    this.customerName,
    this.customerAccountNumber,
    this.serviceId,
    this.serviceName,
    this.amount,
    this.status,
    this.statusLabel,
    this.createdBy,
    this.dateCreated,
    this.transDate,
    this.longitude,
    this.latitude,
    this.externalStatus,
    this.externalStatusLabel,
    this.externalReference,
    this.dateProcessed,
    this.collectionMode,
  });

  factory Collection.fromMap(Map<String, dynamic> data) => Collection(
    collectionId: data['collectionId'] as String?,
    agentId: data['agentId'] as String?,
    agentAccountNumber: data['agentAccountNumber'] as String?,
    agentPhoneNumber: data['agentPhoneNumber'] as String?,
    sessionId: data['sessionId'] as String?,
    agentName: data['agentName'] as String?,
    customerPhoneNumber: data['customerPhoneNumber'] as dynamic,
    customerId: data['customerId'] as String?,
    customerName: data['customerName'] as String?,
    customerAccountNumber: data['customerAccountNumber'] as String?,
    serviceId: data['serviceId'] as String?,
    serviceName: data['serviceName'] as String?,
    amount: data['amount'] as int?,
    status: data['status'] as int?,
    statusLabel: data['statusLabel'] as String?,
    createdBy: data['createdBy'] as String?,
    dateCreated: data['dateCreated'] == null ? null : DateTime.parse(data['dateCreated'] as String),
    transDate: data['transDate'] as String?,
    longitude: data['longitude'] as String?,
    latitude: data['latitude'] as String?,
    externalStatus: data['externalStatus'] as int?,
    externalStatusLabel: data['externalStatusLabel'] as String?,
    externalReference: data['externalReference'] as String?,
    dateProcessed: data['dateProcessed'] == null
        ? null
        : DateTime.parse(data['dateProcessed'] as String),
    collectionMode: data['collectionMode'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'collectionId': collectionId,
    'agentId': agentId,
    'agentAccountNumber': agentAccountNumber,
    'agentPhoneNumber': agentPhoneNumber,
    'sessionId': sessionId,
    'agentName': agentName,
    'customerPhoneNumber': customerPhoneNumber,
    'customerId': customerId,
    'customerName': customerName,
    'customerAccountNumber': customerAccountNumber,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'amount': amount,
    'status': status,
    'statusLabel': statusLabel,
    'createdBy': createdBy,
    'dateCreated': dateCreated?.toIso8601String(),
    'transDate': transDate,
    'longitude': longitude,
    'latitude': latitude,
    'externalStatus': externalStatus,
    'externalStatusLabel': externalStatusLabel,
    'externalReference': externalReference,
    'dateProcessed': dateProcessed?.toIso8601String(),
    'collectionMode': collectionMode,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Collection].
  factory Collection.fromJson(String data) {
    return Collection.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Collection] to a JSON string.
  String toJson() => json.encode(toMap());

  Collection copyWith({
    String? collectionId,
    String? agentId,
    String? agentAccountNumber,
    String? agentPhoneNumber,
    String? sessionId,
    String? agentName,
    dynamic customerPhoneNumber,
    String? customerId,
    String? customerName,
    String? customerAccountNumber,
    String? serviceId,
    String? serviceName,
    int? amount,
    int? status,
    String? statusLabel,
    String? createdBy,
    DateTime? dateCreated,
    String? transDate,
    String? longitude,
    String? latitude,
    int? externalStatus,
    String? externalStatusLabel,
    String? externalReference,
    DateTime? dateProcessed,
    String? collectionMode,
  }) {
    return Collection(
      collectionId: collectionId ?? this.collectionId,
      agentId: agentId ?? this.agentId,
      agentAccountNumber: agentAccountNumber ?? this.agentAccountNumber,
      agentPhoneNumber: agentPhoneNumber ?? this.agentPhoneNumber,
      sessionId: sessionId ?? this.sessionId,
      agentName: agentName ?? this.agentName,
      customerPhoneNumber: customerPhoneNumber ?? this.customerPhoneNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerAccountNumber: customerAccountNumber ?? this.customerAccountNumber,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      createdBy: createdBy ?? this.createdBy,
      dateCreated: dateCreated ?? this.dateCreated,
      transDate: transDate ?? this.transDate,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      externalStatus: externalStatus ?? this.externalStatus,
      externalStatusLabel: externalStatusLabel ?? this.externalStatusLabel,
      externalReference: externalReference ?? this.externalReference,
      dateProcessed: dateProcessed ?? this.dateProcessed,
      collectionMode: collectionMode ?? this.collectionMode,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      collectionId,
      agentId,
      agentAccountNumber,
      agentPhoneNumber,
      sessionId,
      agentName,
      customerPhoneNumber,
      customerId,
      customerName,
      customerAccountNumber,
      serviceId,
      serviceName,
      amount,
      status,
      statusLabel,
      createdBy,
      dateCreated,
      transDate,
      longitude,
      latitude,
      externalStatus,
      externalStatusLabel,
      externalReference,
      dateProcessed,
      collectionMode,
    ];
  }
}
