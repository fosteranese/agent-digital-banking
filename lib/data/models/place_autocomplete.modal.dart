import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceAutocomplete extends Equatable {
  final String main;
  final String secondary;
  final String description;
  final String placeId;
  final LatLng? location;

  const PlaceAutocomplete({
    required this.main,
    required this.secondary,
    required this.description,
    required this.placeId,
    this.location,
  });

  PlaceAutocomplete copyWith({
    String? main,
    String? secondary,
    String? description,
    String? placeId,
    LatLng? location,
  }) {
    return PlaceAutocomplete(
      main: main ?? this.main,
      secondary: secondary ?? this.secondary,
      description: description ?? this.description,
      placeId: placeId ?? this.placeId,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        main,
        secondary,
        description,
        placeId,
        location,
      ];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'main': main});
    result.addAll({'secondary': secondary});
    result.addAll({'description': description});
    result.addAll({'placeId': placeId});
    result.addAll({'location': location});

    return result;
  }

  factory PlaceAutocomplete.fromMap(Map<String, dynamic> map) {
    return PlaceAutocomplete(
      main: map['main'] ?? '',
      secondary: map['secondary'] ?? '',
      description: map['description'] ?? '',
      placeId: map['placeId'] ?? '',
      location: map['location'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceAutocomplete.fromJson(String source) =>
      PlaceAutocomplete.fromMap(json.decode(source));
}
