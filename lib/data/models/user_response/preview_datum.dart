import 'dart:convert';

import 'package:equatable/equatable.dart';

class PreviewDatum extends Equatable {
  final String? key;
  final String? value;
  final int? dataType;
  final String? icon;

  const PreviewDatum({this.key, this.icon, this.value, this.dataType});

  factory PreviewDatum.fromMap(Map<String, dynamic> data) => PreviewDatum(
    key: data['key'] as String?,
    icon: data['icon'] as String?,
    value: data['value'] as String?,
    dataType: data['dataType'] as int?,
  );

  Map<String, dynamic> toMap() => {'key': key, 'icon': icon, 'value': value, 'dataType': dataType};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PreviewDatum].
  factory PreviewDatum.fromJson(String data) {
    return PreviewDatum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PreviewDatum] to a JSON string.
  String toJson() => json.encode(toMap());

  PreviewDatum copyWith({String? key, String? value, int? dataType, String? icon}) {
    return PreviewDatum(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      value: value ?? this.value,
      dataType: dataType ?? this.dataType,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [key, icon, value, dataType];
}
