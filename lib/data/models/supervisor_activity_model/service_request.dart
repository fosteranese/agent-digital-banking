import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'request.dart';

class ServiceRequest extends Equatable {
  final String? supervisorId;
  final String? agentId;
  final int? agentCode;
  final String? agentName;
  final Request? request;

  const ServiceRequest({
    this.supervisorId,
    this.agentId,
    this.agentCode,
    this.agentName,
    this.request,
  });

  factory ServiceRequest.fromMap(Map<String, dynamic> data) {
    return ServiceRequest(
      supervisorId: data['supervisorId'] as String?,
      agentId: data['agentId'] as String?,
      agentCode: data['agentCode'] as int?,
      agentName: data['agentName'] as String?,
      request: data['request'] == null
          ? null
          : Request.fromMap(data['request'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisorId': supervisorId,
    'agentId': agentId,
    'agentCode': agentCode,
    'agentName': agentName,
    'request': request?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ServiceRequest].
  factory ServiceRequest.fromJson(String data) {
    return ServiceRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ServiceRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ServiceRequest copyWith({
    String? supervisorId,
    String? agentId,
    int? agentCode,
    String? agentName,
    Request? request,
  }) {
    return ServiceRequest(
      supervisorId: supervisorId ?? this.supervisorId,
      agentId: agentId ?? this.agentId,
      agentCode: agentCode ?? this.agentCode,
      agentName: agentName ?? this.agentName,
      request: request ?? this.request,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [supervisorId, agentId, agentCode, agentName, request];
  }
}
