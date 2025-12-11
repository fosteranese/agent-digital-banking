import 'dart:convert';

import 'package:equatable/equatable.dart';

class NonCustomerSignUpRequest extends Equatable {
  final String? phoneNumber;
  final String? email;
  final String? cardNumber;
  final String? accountType;
  final String? branch;
  final String? residentialAddress;
  final String? city;

  const NonCustomerSignUpRequest({
    this.phoneNumber,
    this.email,
    this.cardNumber,
    this.accountType,
    this.branch,
    this.residentialAddress,
    this.city,
  });

  factory NonCustomerSignUpRequest.fromMap(Map<String, dynamic> data) {
    return NonCustomerSignUpRequest(
      phoneNumber: data['phoneNumber'] as String?,
      email: data['email'] as String?,
      cardNumber: data['cardNumber'] as String?,
      accountType: data['accountType'] as String?,
      branch: data['branch'] as String?,
      residentialAddress: data['residentialAddress'] as String?,
      city: data['city'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'phoneNumber': phoneNumber,
        'email': email,
        'cardNumber': cardNumber,
        'accountType': accountType,
        'branch': branch,
        'residentialAddress': residentialAddress,
        'city': city,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NonCustomerSignUpRequest].
  factory NonCustomerSignUpRequest.fromJson(String data) {
    return NonCustomerSignUpRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NonCustomerSignUpRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  NonCustomerSignUpRequest copyWith({
    String? phoneNumber,
    String? email,
    String? cardNumber,
    String? accountType,
    String? branch,
    String? residentialAddress,
    String? city,
    String? channel,
    String? deviceId,
  }) {
    return NonCustomerSignUpRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      cardNumber: cardNumber ?? this.cardNumber,
      accountType: accountType ?? this.accountType,
      branch: branch ?? this.branch,
      residentialAddress: residentialAddress ?? this.residentialAddress,
      city: city ?? this.city,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      phoneNumber,
      email,
      cardNumber,
      accountType,
      branch,
      residentialAddress,
      city,
    ];
  }
}