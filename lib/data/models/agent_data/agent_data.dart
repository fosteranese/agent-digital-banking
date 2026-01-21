import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'cash_at_hand.dart';
import 'cash_collected.dart';
import 'cash_deposited.dart';
import 'mo_mo_collected.dart';

class AgentData extends Equatable {
  final CashCollected? cashCollected;
  final MoMoCollected? moMoCollected;
  final CashDeposited? cashDeposited;
  final dynamic pendingReversal;
  final List<dynamic>? recentCollection;
  final CashAtHand? cashAtHand;
  final bool? hasReachedLimit;
  final dynamic hasReachedLimitMessage;

  const AgentData({
    this.cashCollected,
    this.moMoCollected,
    this.cashDeposited,
    this.pendingReversal,
    this.recentCollection,
    this.cashAtHand,
    this.hasReachedLimit,
    this.hasReachedLimitMessage,
  });

  factory AgentData.fromMap(Map<String, dynamic> data) => AgentData(
    cashCollected: data['cashCollected'] == null
        ? null
        : CashCollected.fromMap(data['cashCollected'] as Map<String, dynamic>),
    moMoCollected: data['moMoCollected'] == null
        ? null
        : MoMoCollected.fromMap(data['moMoCollected'] as Map<String, dynamic>),
    cashDeposited: data['cashDeposited'] == null
        ? null
        : CashDeposited.fromMap(data['cashDeposited'] as Map<String, dynamic>),
    pendingReversal: data['pendingReversal'] as dynamic,
    recentCollection: data['recentCollection'] as List<dynamic>?,
    cashAtHand: data['cashAtHand'] == null
        ? null
        : CashAtHand.fromMap(data['cashAtHand'] as Map<String, dynamic>),
    hasReachedLimit: data['hasReachedLimit'] as bool?,
    hasReachedLimitMessage: data['hasReachedLimitMessage'] as dynamic,
  );

  Map<String, dynamic> toMap() => {
    'cashCollected': cashCollected?.toMap(),
    'moMoCollected': moMoCollected?.toMap(),
    'cashDeposited': cashDeposited?.toMap(),
    'pendingReversal': pendingReversal,
    'recentCollection': recentCollection,
    'cashAtHand': cashAtHand?.toMap(),
    'hasReachedLimit': hasReachedLimit,
    'hasReachedLimitMessage': hasReachedLimitMessage,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AgentData].
  factory AgentData.fromJson(String data) {
    return AgentData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AgentData] to a JSON string.
  String toJson() => json.encode(toMap());

  AgentData copyWith({
    CashCollected? cashCollected,
    MoMoCollected? moMoCollected,
    CashDeposited? cashDeposited,
    dynamic pendingReversal,
    List<dynamic>? recentCollection,
    CashAtHand? cashAtHand,
    bool? hasReachedLimit,
    dynamic hasReachedLimitMessage,
  }) {
    return AgentData(
      cashCollected: cashCollected ?? this.cashCollected,
      moMoCollected: moMoCollected ?? this.moMoCollected,
      cashDeposited: cashDeposited ?? this.cashDeposited,
      pendingReversal: pendingReversal ?? this.pendingReversal,
      recentCollection: recentCollection ?? this.recentCollection,
      cashAtHand: cashAtHand ?? this.cashAtHand,
      hasReachedLimit: hasReachedLimit ?? this.hasReachedLimit,
      hasReachedLimitMessage: hasReachedLimitMessage ?? this.hasReachedLimitMessage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      cashCollected,
      moMoCollected,
      cashDeposited,
      pendingReversal,
      recentCollection,
      cashAtHand,
      hasReachedLimit,
      hasReachedLimitMessage,
    ];
  }
}
