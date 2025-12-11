import 'dart:convert';

import 'package:equatable/equatable.dart';

class UnLockScreenRequest extends Equatable {
  final bool? isPassword;
  final String? password;

  const UnLockScreenRequest({this.isPassword, this.password});

  factory UnLockScreenRequest.fromMap(Map<String, dynamic> data) {
    return UnLockScreenRequest(
      isPassword: data['isPassword'] as bool?,
      password: data['password'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'isPassword': isPassword,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UnLockScreenRequest].
  factory UnLockScreenRequest.fromJson(String data) {
    return UnLockScreenRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UnLockScreenRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  UnLockScreenRequest copyWith({
    bool? isPassword,
    String? password,
  }) {
    return UnLockScreenRequest(
      isPassword: isPassword ?? this.isPassword,
      password: password ?? this.password,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        isPassword,
        password,
      ];
}