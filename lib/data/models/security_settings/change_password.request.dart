import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChangePasswordRequest extends Equatable {
  final String? pin;
  final String? password;

  const ChangePasswordRequest({
    this.pin,
    this.password,
  });

  factory ChangePasswordRequest.fromMap(Map<String, dynamic> data) {
    return ChangePasswordRequest(
      pin: data['pin'] as String?,
      password: data['password'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'pin': pin,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChangePasswordRequest].
  factory ChangePasswordRequest.fromJson(String data) {
    return ChangePasswordRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChangePasswordRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ChangePasswordRequest copyWith({
    String? pin,
    String? password,
  }) {
    return ChangePasswordRequest(
      pin: pin ?? this.pin,
      password: password ?? this.password,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      pin,
      password,
    ];
  }
}