import 'dart:convert';

import 'package:equatable/equatable.dart';

class VerifyLoginRequest extends Equatable {
  final String? requestId;
  final String? securityAnswer;

  const VerifyLoginRequest({this.requestId, this.securityAnswer});

  factory VerifyLoginRequest.fromMap(Map<String, dynamic> data) {
    return VerifyLoginRequest(
      requestId: data['requestId'] as String?,
      securityAnswer: data['securityAnswer'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'requestId': requestId, 'securityAnswer': securityAnswer};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VerifyLoginRequest].
  factory VerifyLoginRequest.fromJson(String data) {
    return VerifyLoginRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VerifyLoginRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  VerifyLoginRequest copyWith({String? requestId, String? securityAnswer}) {
    return VerifyLoginRequest(
      requestId: requestId ?? this.requestId,
      securityAnswer: securityAnswer ?? this.securityAnswer,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [requestId, securityAnswer];
}
