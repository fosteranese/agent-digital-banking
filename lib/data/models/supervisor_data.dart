import 'dart:convert';

import 'package:equatable/equatable.dart';

class SupervisorData extends Equatable {
  final double? cashCollected;
  final double? cashAtHand;
  final double? momoCollected;
  final double? cashDeposited;

  const SupervisorData({
    this.cashCollected,
    this.cashAtHand,
    this.momoCollected,
    this.cashDeposited,
  });

  factory SupervisorData.fromMap(Map<String, dynamic> data) => SupervisorData(
    cashCollected: (data['cashCollected'] as num?)?.toDouble(),
    cashAtHand: (data['cashAtHand'] as num?)?.toDouble(),
    momoCollected: (data['moMoCollected'] as num?)?.toDouble(),
    cashDeposited: (data['cashDeposited'] as num?)?.toDouble(),
  );

  Map<String, double?> toMap() => {
    'cashCollected': cashCollected,
    'cashAtHand': cashAtHand,
    'moMoCollected': momoCollected,
    'cashDeposited': cashDeposited,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SupervisorData].
  factory SupervisorData.fromJson(String data) {
    return SupervisorData.fromMap(json.decode(data) as Map<String, double>);
  }

  /// `dart:convert`
  ///
  /// Converts [SupervisorData] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [cashCollected, cashAtHand, momoCollected, cashDeposited];
  }
}
