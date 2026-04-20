import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'service_request.dart';
import 'supervisor.dart';

class SupervisorActivityModel extends Equatable {
  final Supervisor? supervisor;
  final List<ServiceRequest>? serviceRequests;

  const SupervisorActivityModel({this.supervisor, this.serviceRequests});

  factory SupervisorActivityModel.fromMap(Map<String, dynamic> data) {
    return SupervisorActivityModel(
      supervisor: data['supervisor'] == null
          ? null
          : Supervisor.fromMap(data['supervisor'] as Map<String, dynamic>),
      serviceRequests: (data['serviceRequests'] as List<dynamic>?)
          ?.map((e) => ServiceRequest.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisor': supervisor?.toMap(),
    'serviceRequests': serviceRequests?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SupervisorActivityModel].
  factory SupervisorActivityModel.fromJson(String data) {
    return SupervisorActivityModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SupervisorActivityModel] to a JSON string.
  String toJson() => json.encode(toMap());

  SupervisorActivityModel copyWith({
    Supervisor? supervisor,
    List<ServiceRequest>? serviceRequests,
  }) {
    return SupervisorActivityModel(
      supervisor: supervisor ?? this.supervisor,
      serviceRequests: serviceRequests ?? this.serviceRequests,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [supervisor, serviceRequests];
}
