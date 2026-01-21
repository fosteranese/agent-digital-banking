import 'dart:convert';

import 'package:equatable/equatable.dart';

class InitiateLoginRequest extends Equatable {
  final String? phoneNumber;
  final String? password;

  const InitiateLoginRequest({this.phoneNumber, this.password});

  factory InitiateLoginRequest.fromMap(Map<String, dynamic> data) {
    return InitiateLoginRequest(
      phoneNumber: data['phoneNumber'] as String?,
      password: data['password'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'phoneNumber': phoneNumber, 'password': password};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [InitiateLoginRequest].
  factory InitiateLoginRequest.fromJson(String data) {
    return InitiateLoginRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [InitiateLoginRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  InitiateLoginRequest copyWith({String? phoneNumber, String? password}) {
    return InitiateLoginRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [phoneNumber, password];
}
