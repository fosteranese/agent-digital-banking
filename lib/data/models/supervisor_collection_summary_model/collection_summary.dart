import 'dart:convert';

import 'package:equatable/equatable.dart';

class CollectionSummary extends Equatable {
  final String? supId;
  final int? agentCode;
  final String? agentName;
  final double? totalCollections;
  final String? endDate;
  final String? startDate;

  const CollectionSummary({
    this.supId,
    this.agentCode,
    this.agentName,
    this.totalCollections,
    this.endDate,
    this.startDate,
  });

  factory CollectionSummary.fromMap(Map<String, dynamic> data) {
    return CollectionSummary(
      supId: data['supId'] as String?,
      agentCode: data['agentCode'] as int?,
      agentName: data['agentName'] as String?,
      totalCollections: (data['totalCollections'] as num?)?.toDouble(),
      endDate: data['endDate'] as String?,
      startDate: data['startDate'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'supId': supId,
    'agentCode': agentCode,
    'agentName': agentName,
    'totalCollections': totalCollections,
    'endDate': endDate,
    'startDate': startDate,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CollectionSummary].
  factory CollectionSummary.fromJson(String data) {
    return CollectionSummary.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CollectionSummary] to a JSON string.
  String toJson() => json.encode(toMap());

  CollectionSummary copyWith({
    String? supId,
    int? agentCode,
    String? agentName,
    double? totalCollections,
    String? endDate,
    String? startDate,
  }) {
    return CollectionSummary(
      supId: supId ?? this.supId,
      agentCode: agentCode ?? this.agentCode,
      agentName: agentName ?? this.agentName,
      totalCollections: totalCollections ?? this.totalCollections,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [supId, agentCode, agentName, totalCollections, endDate, startDate];
  }
}
