import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'reversal.dart';

class ReversalModel extends Equatable {
  final String? supervisorId;
  final String? agentId;
  final int? agentCode;
  final String? agentName;
  final Reversal? reversal;

  const ReversalModel({
    this.supervisorId,
    this.agentId,
    this.agentCode,
    this.agentName,
    this.reversal,
  });

  factory ReversalModel.fromMap(Map<String, dynamic> data) => ReversalModel(
    supervisorId: data['supervisorId'] as String?,
    agentId: data['agentId'] as String?,
    agentCode: data['agentCode'] as int?,
    agentName: data['agentName'] as String?,
    reversal: data['reversal'] == null
        ? null
        : Reversal.fromMap(data['reversal'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'supervisorId': supervisorId,
    'agentId': agentId,
    'agentCode': agentCode,
    'agentName': agentName,
    'reversal': reversal?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ReversalModel].
  factory ReversalModel.fromJson(String data) {
    return ReversalModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ReversalModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ReversalModel copyWith({
    String? supervisorId,
    String? agentId,
    int? agentCode,
    String? agentName,
    Reversal? reversal,
  }) {
    return ReversalModel(
      supervisorId: supervisorId ?? this.supervisorId,
      agentId: agentId ?? this.agentId,
      agentCode: agentCode ?? this.agentCode,
      agentName: agentName ?? this.agentName,
      reversal: reversal ?? this.reversal,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [supervisorId, agentId, agentCode, agentName, reversal];
  }
}
