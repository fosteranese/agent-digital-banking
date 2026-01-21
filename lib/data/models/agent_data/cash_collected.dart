import 'dart:convert';

import 'package:equatable/equatable.dart';

class CashCollected extends Equatable {
  final int? count;
  final int? value;
  final String? formatedValue;

  const CashCollected({this.count, this.value, this.formatedValue});

  factory CashCollected.fromMap(Map<String, dynamic> data) => CashCollected(
    count: data['count'] as int?,
    value: data['value'] as int?,
    formatedValue: data['formatedValue'] as String?,
  );

  Map<String, dynamic> toMap() => {'count': count, 'value': value, 'formatedValue': formatedValue};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CashCollected].
  factory CashCollected.fromJson(String data) {
    return CashCollected.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CashCollected] to a JSON string.
  String toJson() => json.encode(toMap());

  CashCollected copyWith({int? count, int? value, String? formatedValue}) {
    return CashCollected(
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
