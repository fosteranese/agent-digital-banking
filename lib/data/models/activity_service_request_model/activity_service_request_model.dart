import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'record.dart';

class ActivityServiceRequestModel extends Equatable {
  final List<ActivityRecordModel>? records;
  final int? total;

  const ActivityServiceRequestModel({this.records, this.total});

  factory ActivityServiceRequestModel.fromMap(Map<String, dynamic> data) {
    return ActivityServiceRequestModel(
      records: (data['records'] as List<dynamic>?)
          ?.map((e) => ActivityRecordModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
    'records': records?.map((e) => e.toMap()).toList(),
    'total': total,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ActivityServiceRequestModel].
  factory ActivityServiceRequestModel.fromJson(String data) {
    return ActivityServiceRequestModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ActivityServiceRequestModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ActivityServiceRequestModel copyWith({List<ActivityRecordModel>? records, int? total}) {
    return ActivityServiceRequestModel(
      records: records ?? this.records,
      total: total ?? this.total,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [records, total];
}
