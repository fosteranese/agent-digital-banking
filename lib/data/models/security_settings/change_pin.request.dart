import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChangePinRequest extends Equatable {
  final String? pin;
  final String? newPin;

  const ChangePinRequest({this.pin, this.newPin});

  factory ChangePinRequest.fromMap(Map<String, dynamic> data) {
    return ChangePinRequest(pin: data['pin'] as String?, newPin: data['newPin'] as String?);
  }

  Map<String, dynamic> toMap() => {'pin': pin, 'newPin': newPin};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChangePinRequest].
  factory ChangePinRequest.fromJson(String data) {
    return ChangePinRequest.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChangePinRequest] to a JSON string.
  String toJson() => json.encode(toMap());

  ChangePinRequest copyWith({String? pin, String? newPin}) {
    return ChangePinRequest(pin: pin ?? this.pin, newPin: newPin ?? this.newPin);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [pin, newPin];
  }
}
