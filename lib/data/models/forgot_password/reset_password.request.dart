import 'dart:convert';

import 'package:equatable/equatable.dart';

class ResetPasswordRequest extends Equatable {
  final String? requestId;
  final String? password;

  const ResetPasswordRequest({
    this.requestId,
    this.password,
  });

  factory ResetPasswordRequest.fromMap(Map<String, dynamic> data) {
    return ResetPasswordRequest(
      requestId: data['requestId'] as String?,
      password: data['password'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'requestId': requestId,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResetPasswordRequest].
  factory ResetPasswordRequest.fromJson(String data) {
    return ResetPasswordRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResetPasswordRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ResetPasswordRequest copyWith({
    String? requestId,
    String? password,
  }) {
    return ResetPasswordRequest(
      requestId: requestId ?? this.requestId,
      password: password ?? this.password,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      requestId,
      password,
    ];
  }
}