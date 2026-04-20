import 'dart:convert';

import 'package:equatable/equatable.dart';

class Supervisor extends Equatable {
  final String? agentId;
  final int? agentCode;
  final String? branchCode;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? nationalId;
  final int? status;
  final String? floatAccount;
  final String? createdBy;
  final String? approvedBy;
  final DateTime? dateCreated;
  final DateTime? updatedAt;
  final String? statusLabel;
  final String? workStartTime;
  final String? workEndTime;
  final String? primaryAccount;
  final String? deviceId;
  final String? deviceInfo;
  final String? role;

  const Supervisor({
    this.agentId,
    this.agentCode,
    this.branchCode,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.nationalId,
    this.status,
    this.floatAccount,
    this.createdBy,
    this.approvedBy,
    this.dateCreated,
    this.updatedAt,
    this.statusLabel,
    this.workStartTime,
    this.workEndTime,
    this.primaryAccount,
    this.deviceId,
    this.deviceInfo,
    this.role,
  });

  factory Supervisor.fromMap(Map<String, dynamic> data) => Supervisor(
    agentId: data['agentId'] as String?,
    agentCode: data['agentCode'] as int?,
    branchCode: data['branchCode'] as String?,
    fullName: data['fullName'] as String?,
    phoneNumber: data['phoneNumber'] as String?,
    email: data['email'] as String?,
    nationalId: data['nationalId'] as String?,
    status: data['status'] as int?,
    floatAccount: data['floatAccount'] as String?,
    createdBy: data['createdBy'] as String?,
    approvedBy: data['approvedBy'] as String?,
    dateCreated: data['dateCreated'] == null ? null : DateTime.parse(data['dateCreated'] as String),
    updatedAt: data['updatedAt'] == null ? null : DateTime.parse(data['updatedAt'] as String),
    statusLabel: data['statusLabel'] as String?,
    workStartTime: data['workStartTime'] as String?,
    workEndTime: data['workEndTime'] as String?,
    primaryAccount: data['primaryAccount'] as String?,
    deviceId: data['deviceId'] as String?,
    deviceInfo: data['deviceInfo'] as String?,
    role: data['role'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'agentId': agentId,
    'agentCode': agentCode,
    'branchCode': branchCode,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'email': email,
    'nationalId': nationalId,
    'status': status,
    'floatAccount': floatAccount,
    'createdBy': createdBy,
    'approvedBy': approvedBy,
    'dateCreated': dateCreated?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'statusLabel': statusLabel,
    'workStartTime': workStartTime,
    'workEndTime': workEndTime,
    'primaryAccount': primaryAccount,
    'deviceId': deviceId,
    'deviceInfo': deviceInfo,
    'role': role,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Supervisor].
  factory Supervisor.fromJson(String data) {
    return Supervisor.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Supervisor] to a JSON string.
  String toJson() => json.encode(toMap());

  Supervisor copyWith({
    String? agentId,
    int? agentCode,
    String? branchCode,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? nationalId,
    int? status,
    String? floatAccount,
    String? createdBy,
    String? approvedBy,
    DateTime? dateCreated,
    DateTime? updatedAt,
    String? statusLabel,
    String? workStartTime,
    String? workEndTime,
    String? primaryAccount,
    String? deviceId,
    String? deviceInfo,
    String? role,
  }) {
    return Supervisor(
      agentId: agentId ?? this.agentId,
      agentCode: agentCode ?? this.agentCode,
      branchCode: branchCode ?? this.branchCode,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      status: status ?? this.status,
      floatAccount: floatAccount ?? this.floatAccount,
      createdBy: createdBy ?? this.createdBy,
      approvedBy: approvedBy ?? this.approvedBy,
      dateCreated: dateCreated ?? this.dateCreated,
      updatedAt: updatedAt ?? this.updatedAt,
      statusLabel: statusLabel ?? this.statusLabel,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      primaryAccount: primaryAccount ?? this.primaryAccount,
      deviceId: deviceId ?? this.deviceId,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      role: role ?? this.role,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      agentId,
      agentCode,
      branchCode,
      fullName,
      phoneNumber,
      email,
      nationalId,
      status,
      floatAccount,
      createdBy,
      approvedBy,
      dateCreated,
      updatedAt,
      statusLabel,
      workStartTime,
      workEndTime,
      primaryAccount,
      deviceId,
      deviceInfo,
      role,
    ];
  }
}
