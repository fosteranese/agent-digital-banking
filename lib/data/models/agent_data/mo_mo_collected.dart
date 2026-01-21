import 'dart:convert';

import 'package:equatable/equatable.dart';

class MoMoCollected extends Equatable {
  final int? count;
  final int? value;
  final String? formatedValue;

  const MoMoCollected({this.count, this.value, this.formatedValue});

  factory MoMoCollected.fromMap(Map<String, dynamic> data) => MoMoCollected(
    count: data['count'] as int?,
    value: data['value'] as int?,
    formatedValue: data['formatedValue'] as String?,
  );

  Map<String, dynamic> toMap() => {'count': count, 'value': value, 'formatedValue': formatedValue};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MoMoCollected].
  factory MoMoCollected.fromJson(String data) {
    return MoMoCollected.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MoMoCollected] to a JSON string.
  String toJson() => json.encode(toMap());

  MoMoCollected copyWith({int? count, int? value, String? formatedValue}) {
    return MoMoCollected(
      count: count ?? this.count,
      value: value ?? this.value,
      formatedValue: formatedValue ?? this.formatedValue,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [count, value, formatedValue];
}
