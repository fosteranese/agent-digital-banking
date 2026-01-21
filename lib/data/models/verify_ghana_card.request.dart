import 'dart:convert';

import 'package:equatable/equatable.dart';

class VerifyGhanaCardRequest extends Equatable {
  final String? registrationId;
  final String? code;
  final String? state;
  final String? pin;
  final String? error;

  const VerifyGhanaCardRequest({this.registrationId, this.code, this.state, this.pin, this.error});

  factory VerifyGhanaCardRequest.fromMap(Map<String, dynamic> data) {
    return VerifyGhanaCardRequest(
      registrationId: data['registrationId'] as String?,
      code: data['code'] as String?,
      state: data['state'] as String?,
      pin: data['pin'] as String?,
      error: data['error'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'registrationId': registrationId,
    'code': code,
    'state': state,
    'pin': pin,
    'error': error,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VerifyGhanaCardRequest].
  factory VerifyGhanaCardRequest.fromJson(String data) {
    return VerifyGhanaCardRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VerifyGhanaCardRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  VerifyGhanaCardRequest copyWith({
    String? registrationId,
    String? code,
    String? state,
    String? pin,
    String? error,
  }) {
    return VerifyGhanaCardRequest(
      registrationId: registrationId ?? this.registrationId,
      code: code ?? this.code,
      state: state ?? this.state,
      pin: pin ?? this.pin,
      error: error ?? this.error,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [registrationId, code, state, pin, error];
}
