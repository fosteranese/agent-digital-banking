import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'otp_data.dart';

class VerifyGhanaCardResponse extends Equatable {
  final OtpData? otpData;
  final String? ghCardUrl;
  final String? registrationId;

  const VerifyGhanaCardResponse({this.otpData, this.ghCardUrl, this.registrationId});

  factory VerifyGhanaCardResponse.fromMap(Map<String, dynamic> data) {
    return VerifyGhanaCardResponse(
      otpData: data['otpData'] == null
          ? null
          : OtpData.fromMap(data['otpData'] as Map<String, dynamic>),
      ghCardUrl: data['ghCardUrl'] as String?,
      registrationId: data['registrationId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'otpData': otpData?.toMap(),
    'ghCardUrl': ghCardUrl,
    'registrationId': registrationId,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VerifyGhanaCardResponse].
  factory VerifyGhanaCardResponse.fromJson(String data) {
    return VerifyGhanaCardResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VerifyGhanaCardResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  VerifyGhanaCardResponse copyWith({OtpData? otpData, String? ghCardUrl, String? registrationId}) {
    return VerifyGhanaCardResponse(
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
