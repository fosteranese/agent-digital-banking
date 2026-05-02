import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'agent.dart';
import 'collection.dart';
import 'reversal.dart';

class ReversalRequestModel extends Equatable {
  final String? supervisorId;
  final Reversal? reversal;
  final Collection? collection;
  final Agent? agent;

  const ReversalRequestModel({this.supervisorId, this.reversal, this.collection, this.agent});

  factory ReversalRequestModel.fromMap(Map<String, dynamic> data) {
    return ReversalRequestModel(
      supervisorId: data['supervisorId'] as String?,
      reversal: data['reversal'] == null
          ? null
          : Reversal.fromMap(data['reversal'] as Map<String, dynamic>),
      collection: data['collection'] == null
          ? null
          : Collection.fromMap(data['collection'] as Map<String, dynamic>),
      agent: data['agent'] == null ? null : Agent.fromMap(data['agent'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisorId': supervisorId,
    'reversal': reversal?.toMap(),
    'collection': collection?.toMap(),
    'agent': agent?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ReversalRequestModel].
  factory ReversalRequestModel.fromJson(String data) {
    return ReversalRequestModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ReversalRequestModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ReversalRequestModel copyWith({
    String? supervisorId,
    Reversal? reversal,
    Collection? collection,
    Agent? agent,
  }) {
    return ReversalRequestModel(
      supervisorId: supervisorId ?? this.supervisorId,
      reversal: reversal ?? this.reversal,
      collection: collection ?? this.collection,
      agent: agent ?? this.agent,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [supervisorId, reversal, collection, agent];
}
