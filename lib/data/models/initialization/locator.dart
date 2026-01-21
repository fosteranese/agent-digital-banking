import 'dart:convert';

import 'package:equatable/equatable.dart';

class Locator extends Equatable {
  final String? locatorId;
  final String? typeId;
  final String? title;
  final String? location;
  final String? ghanaPostCode;
  final String? email;
  final String? phoneNumber;
  final dynamic serviceHours;
  final int? status;
  final String? statusLabel;
  final dynamic dateCreated;
  final dynamic createdBy;
  final dynamic lastModified;
  final dynamic modifiedBy;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic otherInformation;
  final dynamic rank;

  const Locator({
    this.locatorId,
    this.typeId,
    this.title,
    this.location,
    this.ghanaPostCode,
    this.email,
    this.phoneNumber,
    this.serviceHours,
    this.status,
    this.statusLabel,
    this.dateCreated,
    this.createdBy,
    this.lastModified,
    this.modifiedBy,
    this.longitude,
    this.latitude,
    this.otherInformation,
    this.rank,
  });

  factory Locator.fromMap(Map<String, dynamic> data) => Locator(
    locatorId: data['locatorId'] as String?,
    typeId: data['typeId'] as String?,
    title: data['title'] as String?,
    location: data['location'] as String?,
    ghanaPostCode: data['ghanaPostCode'] as String?,
    email: data['email'] as String?,
    phoneNumber: data['phoneNumber'] as String?,
    serviceHours: data['serviceHours'] as dynamic,
    status: data['status'] as int?,
    statusLabel: data['statusLabel'] as String?,
    dateCreated: data['dateCreated'] as dynamic,
    createdBy: data['createdBy'] as dynamic,
    lastModified: data['lastModified'] as dynamic,
    modifiedBy: data['modifiedBy'] as dynamic,
    longitude: data['longitude'] as dynamic,
    latitude: data['latitude'] as dynamic,
    otherInformation: data['otherInformation'] as dynamic,
    rank: data['rank'] as dynamic,
  );

  Map<String, dynamic> toMap() => {
    'locatorId': locatorId,
    'typeId': typeId,
    'title': title,
    'location': location,
    'ghanaPostCode': ghanaPostCode,
    'email': email,
    'phoneNumber': phoneNumber,
    'serviceHours': serviceHours,
    'status': status,
    'statusLabel': statusLabel,
    'dateCreated': dateCreated,
    'createdBy': createdBy,
    'lastModified': lastModified,
    'modifiedBy': modifiedBy,
    'longitude': longitude,
    'latitude': latitude,
    'otherInformation': otherInformation,
    'rank': rank,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Locator].
  factory Locator.fromJson(String data) {
    return Locator.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Locator] to a JSON string.
  String toJson() => json.encode(toMap());

  Locator copyWith({
    String? locatorId,
    String? typeId,
    String? title,
    String? location,
    String? ghanaPostCode,
    String? email,
    String? phoneNumber,
    dynamic serviceHours,
    int? status,
    String? statusLabel,
    dynamic dateCreated,
    dynamic createdBy,
    dynamic lastModified,
    dynamic modifiedBy,
    dynamic longitude,
    dynamic latitude,
    dynamic otherInformation,
    dynamic rank,
  }) {
    return Locator(
      locatorId: locatorId ?? this.locatorId,
      typeId: typeId ?? this.typeId,
      title: title ?? this.title,
      location: location ?? this.location,
      ghanaPostCode: ghanaPostCode ?? this.ghanaPostCode,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      serviceHours: serviceHours ?? this.serviceHours,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      dateCreated: dateCreated ?? this.dateCreated,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      otherInformation: otherInformation ?? this.otherInformation,
      rank: rank ?? this.rank,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      locatorId,
      typeId,
      title,
      location,
      ghanaPostCode,
      email,
      phoneNumber,
      serviceHours,
      status,
      statusLabel,
      dateCreated,
      createdBy,
      lastModified,
      modifiedBy,
      longitude,
      latitude,
      otherInformation,
      rank,
    ];
  }
}
