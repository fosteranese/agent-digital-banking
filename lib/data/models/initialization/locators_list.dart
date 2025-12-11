import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'locator.dart';
import 'locator_type.dart';

class LocatorsList extends Equatable {
  final List<Locator>? locators;
  final LocatorType? locatorType;

  const LocatorsList({this.locators, this.locatorType});

  factory LocatorsList.fromMap(Map<String, dynamic> data) => LocatorsList(
        locators: (data['locators'] as List<dynamic>?)
            ?.map((e) => Locator.fromMap(e as Map<String, dynamic>))
            .toList(),
        locatorType: data['locatorType'] == null
            ? null
            : LocatorType.fromMap(data['locatorType'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'locators': locators?.map((e) => e.toMap()).toList(),
        'locatorType': locatorType?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LocatorsList].
  factory LocatorsList.fromJson(String data) {
    return LocatorsList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LocatorsList] to a JSON string.
  String toJson() => json.encode(toMap());

  LocatorsList copyWith({
    List<Locator>? locators,
    LocatorType? locatorType,
  }) {
    return LocatorsList(
      locators: locators ?? this.locators,
      locatorType: locatorType ?? this.locatorType,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [locators, locatorType];
}