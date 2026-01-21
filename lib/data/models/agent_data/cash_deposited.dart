import 'dart:convert';

import 'package:equatable/equatable.dart';

class CashDeposited extends Equatable {
  final int? count;
  final int? value;
  final String? formatedValue;

  const CashDeposited({this.count, this.value, this.formatedValue});

  factory CashDeposited.fromMap(Map<String, dynamic> data) => CashDeposited(
    count: data['count'] as int?,
    value: data['value'] as int?,
    formatedValue: data['formatedValue'] as String?,
  );

  Map<String, dynamic> toMap() => {'count': count, 'value': value, 'formatedValue': formatedValue};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CashDeposited].
  factory CashDeposited.fromJson(String data) {
    return CashDeposited.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CashDeposited] to a JSON string.
  String toJson() => json.encode(toMap());

  CashDeposited copyWith({int? count, int? value, String? formatedValue}) {
    return CashDeposited(
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
