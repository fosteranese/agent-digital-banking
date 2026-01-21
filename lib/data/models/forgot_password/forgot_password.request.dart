import 'dart:convert';

import 'package:equatable/equatable.dart';

class ForgotPasswordRequest extends Equatable {
  final String? phoneNumber;
  final String? answer;

  const ForgotPasswordRequest({this.phoneNumber, this.answer});

  factory ForgotPasswordRequest.fromMap(Map<String, dynamic> data) {
    return ForgotPasswordRequest(
      phoneNumber: data['phoneNumber'] as String?,
      answer: data['answer'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'phoneNumber': phoneNumber, 'answer': answer};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ForgotPasswordRequest].
  factory ForgotPasswordRequest.fromJson(String data) {
    return ForgotPasswordRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ForgotPasswordRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ForgotPasswordRequest copyWith({String? phoneNumber, String? answer}) {
    return ForgotPasswordRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      answer: answer ?? this.answer,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [phoneNumber, answer];
  }
}
