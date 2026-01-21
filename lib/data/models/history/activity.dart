import 'dart:convert';

import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String? activityId;
  final String? activityName;
  final String? caption;

  const Activity({this.activityId, this.activityName, this.caption});

  factory Activity.fromMap(Map<String, dynamic> data) => Activity(
    activityId: data['activityId'] as String?,
    activityName: data['activityName'] as String?,
    caption: data['caption'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'activityId': activityId,
    'activityName': activityName,
    'caption': caption,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Activity].
  factory Activity.fromJson(String data) {
    return Activity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Activity] to a JSON string.
  String toJson() => json.encode(toMap());

  Activity copyWith({String? activityId, String? activityName, String? caption}) {
    return Activity(
      activityId: activityId ?? this.activityId,
      activityName: activityName ?? this.activityName,
      caption: caption ?? this.caption,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [activityId, activityName, caption];
}
