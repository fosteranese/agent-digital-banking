import 'dart:convert';

import 'package:equatable/equatable.dart';

class CustomerSignUpRequest extends Equatable {
  final String? accountNumber;
  final String? ghanaCardNumber;

  const CustomerSignUpRequest({this.accountNumber, this.ghanaCardNumber});

  factory CustomerSignUpRequest.fromMap(Map<String, dynamic> data) {
    return CustomerSignUpRequest(
      accountNumber: data['accountNumber'] as String?,
      ghanaCardNumber: data['ghanaCardNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'accountNumber': accountNumber,
    'ghanaCardNumber': ghanaCardNumber,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CustomerSignUpRequest].
  factory CustomerSignUpRequest.fromJson(String data) {
    return CustomerSignUpRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CustomerSignUpRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  CustomerSignUpRequest copyWith({String? accountNumber, String? ghanaCardNumber}) {
    return CustomerSignUpRequest(
      accountNumber: accountNumber ?? this.accountNumber,
      ghanaCardNumber: ghanaCardNumber ?? this.ghanaCardNumber,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [accountNumber, ghanaCardNumber];
  }
}
