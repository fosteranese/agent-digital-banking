import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'otp_data.dart';

class VerificationResponse extends Equatable {
  final OtpData? otpData;
  final String? ghCardUrl;
  final String? registrationId;
  final String? imageBaseUrl;
  final dynamic imageDirectory;
  final String? accessType;

  const VerificationResponse({
    this.otpData,
    this.ghCardUrl,
    this.registrationId,
    this.imageBaseUrl,
    this.imageDirectory,
    this.accessType,
  });

  factory VerificationResponse.fromMap(Map<String, dynamic> data) {
    return VerificationResponse(
      otpData: data['otpData'] == null
          ? null
          : OtpData.fromMap(data['otpData'] as Map<String, dynamic>),
      ghCardUrl: data['ghCardUrl'] as String?,
      registrationId: data['registrationId'] as String?,
      imageBaseUrl: data['imageBaseUrl'] as String?,
      imageDirectory: data['imageDirectory'] as dynamic,
      accessType: data['accessType'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'otpData': otpData?.toMap(),
    'ghCardUrl': ghCardUrl,
    'registrationId': registrationId,
    'imageBaseUrl': imageBaseUrl,
    'imageDirectory': imageDirectory,
    'accessType': accessType,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VerificationResponse].
  factory VerificationResponse.fromJson(String data) {
    return VerificationResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VerificationResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  VerificationResponse copyWith({
    OtpData? otpData,
    String? ghCardUrl,
    String? registrationId,
    String? imageBaseUrl,
    dynamic imageDirectory,
    String? accessType,
  }) {
    return VerificationResponse(
      otpData: otpData ?? this.otpData,
      ghCardUrl: ghCardUrl ?? this.ghCardUrl,
      registrationId: registrationId ?? this.registrationId,
      imageBaseUrl: imageBaseUrl ?? this.imageBaseUrl,
      imageDirectory: imageDirectory ?? this.imageDirectory,
      accessType: accessType ?? this.accessType,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [otpData, ghCardUrl, registrationId, imageBaseUrl, imageDirectory, accessType];
  }
}
