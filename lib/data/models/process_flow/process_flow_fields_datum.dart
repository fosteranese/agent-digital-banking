import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../collection/lov.dart';
import 'process_flow_field.dart';

class ProcessFlowFieldsDatum extends Equatable {
  final List<Lov>? lov;
  final ProcessFlowField? field;

  const ProcessFlowFieldsDatum({this.lov, this.field});

  factory ProcessFlowFieldsDatum.fromMap(Map<String, dynamic> data) => ProcessFlowFieldsDatum(
    lov: data['lov'] != null
        ? (data['lov'] as List<dynamic>?)
              ?.map((e) => Lov.fromMap(e as Map<String, dynamic>))
              .toList()
        : [],
    field: data['field'] == null
        ? null
        : ProcessFlowField.fromMap(data['field'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'lov': lov?.map((e) => e.toMap()).toList() ?? [],
    'field': field?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProcessFlowFieldsDatum].
  factory ProcessFlowFieldsDatum.fromJson(String data) {
    return ProcessFlowFieldsDatum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProcessFlowFieldsDatum] to a JSON string.
  String toJson() => json.encode(toMap());

  ProcessFlowFieldsDatum copyWith({List<Lov>? lov, ProcessFlowField? field}) {
    return ProcessFlowFieldsDatum(lov: lov ?? this.lov, field: field ?? this.field);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [lov, field];
}
