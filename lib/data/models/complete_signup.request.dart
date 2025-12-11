import 'dart:convert';

import 'package:equatable/equatable.dart';

class CompleteSignUpRequest extends Equatable {
  final String? registrationId;
  final String? password;
  final String? question;
  final String? answer;
  final String? pin;
  final bool? isLoginBioEnabled;
  final bool? isTransactBioEnabled;

  const CompleteSignUpRequest({
    this.registrationId,
    this.password,
    this.question,
    this.answer,
    this.pin,
    this.isLoginBioEnabled,
    this.isTransactBioEnabled,
  });

  factory CompleteSignUpRequest.fromMap(
    Map<String, dynamic> data,
  ) {
    return CompleteSignUpRequest(
      registrationId: data['registrationId'] as String?,
      password: data['password'] as String?,
      question: data['question'] as String?,
      answer: data['answer'] as String?,
      pin: data['pin'] as String?,
      isLoginBioEnabled: data['isLoginBioEnabled'],
      isTransactBioEnabled: data['isTransactBioEnabled'],
    );
  }

  Map<String, dynamic> toMap() => {
    'registrationId': registrationId,
    'password': password,
    'question': question,
    'answer': answer,
    'pin': pin,
    'isLoginBioEnabled': isLoginBioEnabled,
    'isTransactBioEnabled': isTransactBioEnabled,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CompleteSignUpRequest].
  factory CompleteSignUpRequest.fromJson(String data) {
    return CompleteSignUpRequest.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [CompleteSignUpRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  CompleteSignUpRequest copyWith({
    String? registrationId,
    String? password,
    String? question,
    String? answer,
    String? pin,
    bool? isLoginBioEnabled,
    bool? isTransactBioEnabled,
  }) {
    return CompleteSignUpRequest(
      registrationId: registrationId ?? this.registrationId,
      password: password ?? this.password,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      pin: pin ?? this.pin,
      isLoginBioEnabled:
          isLoginBioEnabled ?? this.isLoginBioEnabled,
      isTransactBioEnabled:
          isTransactBioEnabled ?? this.isTransactBioEnabled,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    registrationId,
    password,
    question,
    answer,
    pin,
    isLoginBioEnabled,
    isTransactBioEnabled,
  ];
}
