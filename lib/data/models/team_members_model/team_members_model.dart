import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'agent.dart';
import 'supervisor.dart';

class TeamMembersModel extends Equatable {
  final Supervisor? supervisor;
  final List<Agent>? agents;

  const TeamMembersModel({this.supervisor, this.agents});

  factory TeamMembersModel.fromMap(Map<String, dynamic> data) {
    return TeamMembersModel(
      supervisor: data['supervisor'] == null
          ? null
          : Supervisor.fromMap(data['supervisor'] as Map<String, dynamic>),
      agents: (data['agents'] as List<dynamic>?)
          ?.map((e) => Agent.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisor': supervisor?.toMap(),
    'agents': agents?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TeamMembersModel].
  factory TeamMembersModel.fromJson(String data) {
    return TeamMembersModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TeamMembersModel] to a JSON string.
  String toJson() => json.encode(toMap());

  TeamMembersModel copyWith({Supervisor? supervisor, List<Agent>? agents}) {
    return TeamMembersModel(
      supervisor: supervisor ?? this.supervisor,
      agents: agents ?? this.agents,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [supervisor, agents];
}
