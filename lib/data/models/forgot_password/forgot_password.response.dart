import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../otp_data.dart';

class ForgotPasswordResponse extends Equatable {
  final OtpData? otpData;
  final String? ghCardUrl;
  final dynamic registrationId;

  const ForgotPasswordResponse({
    this.otpData,
    this.ghCardUrl,
    this.registrationId,
  });

  factory ForgotPasswordResponse.fromMap(Map<String, dynamic> data) {
    return ForgotPasswordResponse(
      otpData: data['otpData'] == null ? null : OtpData.fromMap(data['otpData'] as Map<String, dynamic>),
      ghCardUrl: data['ghCardUrl'] as String?,
      registrationId: data['registrationId'] as dynamic,
    );
  }

  Map<String, dynamic> toMap() => {
        'otpData': otpData?.toMap(),
        'ghCardUrl': ghCardUrl,
        'registrationId': registrationId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ForgotPasswordResponse].
  factory ForgotPasswordResponse.fromJson(String data) {
    return ForgotPasswordResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ForgotPasswordResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  ForgotPasswordResponse copyWith({
    OtpData? otpData,
    String? ghCardUrl,
    dynamic registrationId,
  }) {
    return ForgotPasswordResponse(
      otpData: otpData ?? this.otpData,
      ghCardUrl: ghCardUrl ?? this.ghCardUrl,
      registrationId: registrationId ?? this.registrationId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [otpData, ghCardUrl, registrationId];
}