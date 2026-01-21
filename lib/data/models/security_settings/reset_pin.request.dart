import 'dart:convert';

import 'package:equatable/equatable.dart';

class ResetPinRequest extends Equatable {
  final String? secretAnswer;
  final String? newPin;

  const ResetPinRequest({this.secretAnswer, this.newPin});

  factory ResetPinRequest.fromMap(Map<String, dynamic> data) {
    return ResetPinRequest(
      secretAnswer: data['secretAnswer'] as String?,
      newPin: data['newPin'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'secretAnswer': secretAnswer, 'newPin': newPin};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResetPinRequest].
  factory ResetPinRequest.fromJson(String data) {
    return ResetPinRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResetPinRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ResetPinRequest copyWith({String? secretAnswer, String? newPin}) {
    return ResetPinRequest(
      secretAnswer: secretAnswer ?? this.secretAnswer,
      newPin: newPin ?? this.newPin,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [secretAnswer, newPin];
  }
}
