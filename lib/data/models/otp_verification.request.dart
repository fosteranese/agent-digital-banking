import 'dart:convert';

import 'package:equatable/equatable.dart';

class OtpVerificationRequest extends Equatable {
  final String? otpId;
  final String? otpValue;

  const OtpVerificationRequest({this.otpId, this.otpValue});

  factory OtpVerificationRequest.fromMap(Map<String, dynamic> data) {
    return OtpVerificationRequest(
      otpId: data['otpId'] as String?,
      otpValue: data['otpValue'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'otpId': otpId, 'otpValue': otpValue};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OtpVerificationRequest].
  factory OtpVerificationRequest.fromJson(String data) {
    return OtpVerificationRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OtpVerificationRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  OtpVerificationRequest copyWith({String? otpId, String? otpValue}) {
    return OtpVerificationRequest(otpId: otpId ?? this.otpId, otpValue: otpValue ?? this.otpValue);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [otpId, otpValue];
}
