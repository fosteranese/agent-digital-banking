import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'activity.dart';
import '../request_response.dart';

class HistoryResponse extends Equatable {
  final List<Activity>? activity;
  final List<RequestResponse>? request;
  final String? fblLogo;

  const HistoryResponse({
    this.activity,
    this.request,
    this.fblLogo,
  });

  factory HistoryResponse.fromMap(Map<String, dynamic> data) {
    return HistoryResponse(
      activity: (data['activity'] as List<dynamic>?)?.map((e) => Activity.fromMap(e as Map<String, dynamic>)).toList(),
      request: (data['request'] as List<dynamic>?)?.map((e) => RequestResponse.fromMap(e as Map<String, dynamic>)).toList(),
      fblLogo: data['fblLogo'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'activity': activity?.map((e) => e.toMap()).toList(),
        'request': request?.map((e) => e.toMap()).toList(),
        'fblLogo': fblLogo,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HistoryResponse].
  factory HistoryResponse.fromJson(String data) {
    return HistoryResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HistoryResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  HistoryResponse copyWith({
    List<Activity>? activity,
    List<RequestResponse>? request,
    String? fblLogo,
  }) {
    return HistoryResponse(
      activity: activity ?? this.activity,
      request: request ?? this.request,
      fblLogo: fblLogo ?? this.fblLogo,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        activity,
        request,
        fblLogo,
      ];
}