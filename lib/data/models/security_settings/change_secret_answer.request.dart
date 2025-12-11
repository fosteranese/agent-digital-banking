import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChangeSecretAnswerRequest extends Equatable {
  final String? secretAnswer;
  final String? newSecretAnswer;

  const ChangeSecretAnswerRequest({
    this.secretAnswer,
    this.newSecretAnswer,
  });

  factory ChangeSecretAnswerRequest.fromMap(Map<String, dynamic> data) {
    return ChangeSecretAnswerRequest(
      secretAnswer: data['secretAnswer'] as String?,
      newSecretAnswer: data['newSecretAnswer'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'secretAnswer': secretAnswer,
        'newSecretAnswer': newSecretAnswer,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChangeSecretAnswerRequest].
  factory ChangeSecretAnswerRequest.fromJson(String data) {
    return ChangeSecretAnswerRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChangeSecretAnswerRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ChangeSecretAnswerRequest copyWith({
    String? secretAnswer,
    String? newSecretAnswer,
  }) {
    return ChangeSecretAnswerRequest(
      secretAnswer: secretAnswer ?? this.secretAnswer,
      newSecretAnswer: newSecretAnswer ?? this.newSecretAnswer,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      secretAnswer,
      newSecretAnswer,
    ];
  }
}