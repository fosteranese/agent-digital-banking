import 'dart:convert';

import 'package:equatable/equatable.dart';

class KeyValueModel extends Equatable {
  final String? key;
  final String? value;

  const KeyValueModel({this.key, this.value});

  factory KeyValueModel.fromMap(Map<String, dynamic> data) =>
      KeyValueModel(key: data['key'] as String?, value: data['value'] as String?);

  Map<String, dynamic> toMap() => {'key': key, 'value': value};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [KeyValueModel].
  factory KeyValueModel.fromJson(String data) {
    return KeyValueModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [KeyValueModel] to a JSON string.
  String toJson() => json.encode(toMap());

  KeyValueModel copyWith({String? key, String? value}) {
    return KeyValueModel(key: key ?? this.key, value: value ?? this.value);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [key, value];
}
