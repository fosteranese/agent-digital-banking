import 'dart:convert';

import 'package:equatable/equatable.dart';

class CashAtHand extends Equatable {
  final int? count;
  final int? value;
  final String? formatedValue;

  const CashAtHand({this.count, this.value, this.formatedValue});

  factory CashAtHand.fromMap(Map<String, dynamic> data) => CashAtHand(
    count: data['count'] as int?,
    value: data['value'] as int?,
    formatedValue: data['formatedValue'] as String?,
  );

  Map<String, dynamic> toMap() => {'count': count, 'value': value, 'formatedValue': formatedValue};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CashAtHand].
  factory CashAtHand.fromJson(String data) {
    return CashAtHand.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CashAtHand] to a JSON string.
  String toJson() => json.encode(toMap());

  CashAtHand copyWith({int? count, int? value, String? formatedValue}) {
    return CashAtHand(
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
