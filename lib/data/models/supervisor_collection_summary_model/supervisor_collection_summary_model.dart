import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'collection_summary.dart';
import 'supervisor.dart';

class SupervisorCollectionSummaryModel extends Equatable {
  final Supervisor? supervisor;
  final List<CollectionSummary>? collectionSummary;
  final List<CollectionSummary>? cashAtHand;
  final List<CollectionSummary>? summaryDeposited;
  final List<CollectionSummary>? summaryCash;
  final List<CollectionSummary>? summaryMomo;

  const SupervisorCollectionSummaryModel({
    this.supervisor,
    this.collectionSummary,
    this.cashAtHand,
    this.summaryDeposited,
    this.summaryCash,
    this.summaryMomo,
  });

  factory SupervisorCollectionSummaryModel.fromMap(Map<String, dynamic> data) {
    return SupervisorCollectionSummaryModel(
      supervisor: data['supervisor'] == null
          ? null
          : Supervisor.fromMap(data['supervisor'] as Map<String, dynamic>),
      collectionSummary: (data['collectionSummary'] as List<dynamic>?)
          ?.map((e) => CollectionSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
      cashAtHand: (data['cashAtHand'] as List<dynamic>?)
          ?.map((e) => CollectionSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
      summaryDeposited: (data['summaryDeposited'] as List<dynamic>?)
          ?.map((e) => CollectionSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
      summaryCash: (data['summaryCASH'] as List<dynamic>?)
          ?.map((e) => CollectionSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
      summaryMomo: (data['summaryMOMO'] as List<dynamic>?)
          ?.map((e) => CollectionSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'supervisor': supervisor?.toMap(),
    'collectionSummary': collectionSummary?.map((e) => e.toMap()).toList(),
    'cashAtHand': cashAtHand?.map((e) => e.toMap()).toList(),
    'summaryDeposited': summaryDeposited?.map((e) => e.toMap()).toList(),
    'summaryCASH': summaryCash?.map((e) => e.toMap()).toList(),
    'summaryMOMO': summaryMomo,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SupervisorCollectionSummaryModel].
  factory SupervisorCollectionSummaryModel.fromJson(String data) {
    return SupervisorCollectionSummaryModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SupervisorCollectionSummaryModel] to a JSON string.
  String toJson() => json.encode(toMap());

  SupervisorCollectionSummaryModel copyWith({
    Supervisor? supervisor,
    List<CollectionSummary>? collectionSummary,
    List<CollectionSummary>? cashAtHand,
    List<CollectionSummary>? summaryDeposited,
    List<CollectionSummary>? summaryCash,
    List<CollectionSummary>? summaryMomo,
  }) {
    return SupervisorCollectionSummaryModel(
      supervisor: supervisor ?? this.supervisor,
      collectionSummary: collectionSummary ?? this.collectionSummary,
      cashAtHand: cashAtHand ?? this.cashAtHand,
      summaryDeposited: summaryDeposited ?? this.summaryDeposited,
      summaryCash: summaryCash ?? this.summaryCash,
      summaryMomo: summaryMomo ?? this.summaryMomo,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [supervisor, collectionSummary, cashAtHand, summaryDeposited, summaryCash, summaryMomo];
  }
}
