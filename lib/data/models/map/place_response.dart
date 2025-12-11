class PlaceResponse {
  List<dynamic>? htmlAttributions;
  Result? result;
  String? status;

  PlaceResponse({this.htmlAttributions, this.result, this.status});

  PlaceResponse.fromMap(Map<String, dynamic> json) {
    if (json["html_attributions"] is List) {
      htmlAttributions = json["html_attributions"] ?? [];
    }
    if (json["result"] is Map) {
      result = json["result"] == null ? null : Result.fromMap(json["result"]);
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (htmlAttributions != null) {
      data["html_attributions"] = htmlAttributions;
    }
    if (result != null) {
      data["result"] = result?.toMap();
    }
    data["status"] = status;
    return data;
  }
}

class Result {
  List<AddressComponents>? addressComponents;
  String? adrAddress;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  String? placeId;
  String? reference;
  List<String>? types;
  String? url;
  int? utcOffset;
  String? vicinity;

  Result({this.addressComponents, this.adrAddress, this.formattedAddress, this.geometry, this.icon, this.iconBackgroundColor, this.iconMaskBaseUri, this.name, this.placeId, this.reference, this.types, this.url, this.utcOffset, this.vicinity});

  Result.fromMap(Map<String, dynamic> json) {
    if (json["address_components"] is List) {
      addressComponents = json["address_components"] == null ? null : (json["address_components"] as List).map((e) => AddressComponents.fromMap(e)).toList();
    }
    if (json["adr_address"] is String) {
      adrAddress = json["adr_address"];
    }
    if (json["formatted_address"] is String) {
      formattedAddress = json["formatted_address"];
    }
    if (json["geometry"] is Map) {
      geometry = json["geometry"] == null ? null : Geometry.fromMap(json["geometry"]);
    }
    if (json["icon"] is String) {
      icon = json["icon"];
    }
    if (json["icon_background_color"] is String) {
      iconBackgroundColor = json["icon_background_color"];
    }
    if (json["icon_mask_base_uri"] is String) {
      iconMaskBaseUri = json["icon_mask_base_uri"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["place_id"] is String) {
      placeId = json["place_id"];
    }
    if (json["reference"] is String) {
      reference = json["reference"];
    }
    if (json["types"] is List) {
      types = json["types"] == null ? null : List<String>.from(json["types"]);
    }
    if (json["url"] is String) {
      url = json["url"];
    }
    if (json["utc_offset"] is int) {
      utcOffset = json["utc_offset"];
    }
    if (json["vicinity"] is String) {
      vicinity = json["vicinity"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addressComponents != null) {
      data["address_components"] = addressComponents?.map((e) => e.toMap()).toList();
    }
    data["adr_address"] = adrAddress;
    data["formatted_address"] = formattedAddress;
    if (geometry != null) {
      data["geometry"] = geometry?.toMap();
    }
    data["icon"] = icon;
    data["icon_background_color"] = iconBackgroundColor;
    data["icon_mask_base_uri"] = iconMaskBaseUri;
    data["name"] = name;
    data["place_id"] = placeId;
    data["reference"] = reference;
    if (types != null) {
      data["types"] = types;
    }
    data["url"] = url;
    data["utc_offset"] = utcOffset;
    data["vicinity"] = vicinity;
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromMap(Map<String, dynamic> json) {
    if (json["location"] is Map) {
      location = json["location"] == null ? null : Location.fromMap(json["location"]);
    }
    if (json["viewport"] is Map) {
      viewport = json["viewport"] == null ? null : Viewport.fromMap(json["viewport"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data["location"] = location?.toMap();
    }
    if (viewport != null) {
      data["viewport"] = viewport?.toMap();
    }
    return data;
  }
}

class Viewport {
  Northeast? northeast;
  Southwest? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromMap(Map<String, dynamic> json) {
    if (json["northeast"] is Map) {
      northeast = json["northeast"] == null ? null : Northeast.fromMap(json["northeast"]);
    }
    if (json["southwest"] is Map) {
      southwest = json["southwest"] == null ? null : Southwest.fromMap(json["southwest"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (northeast != null) {
      data["northeast"] = northeast?.toMap();
    }
    if (southwest != null) {
      data["southwest"] = southwest?.toMap();
    }
    return data;
  }
}

class Southwest {
  double? lat;
  double? lng;

  Southwest({this.lat, this.lng});

  Southwest.fromMap(Map<String, dynamic> json) {
    if (json["lat"] is double) {
      lat = json["lat"];
    }
    if (json["lng"] is double) {
      lng = json["lng"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["lat"] = lat;
    data["lng"] = lng;
    return data;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  Northeast.fromMap(Map<String, dynamic> json) {
    if (json["lat"] is double) {
      lat = json["lat"];
    }
    if (json["lng"] is double) {
      lng = json["lng"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["lat"] = lat;
    data["lng"] = lng;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromMap(Map<String, dynamic> json) {
    if (json["lat"] is double) {
      lat = json["lat"];
    }
    if (json["lng"] is double) {
      lng = json["lng"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["lat"] = lat;
    data["lng"] = lng;
    return data;
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromMap(Map<String, dynamic> json) {
    if (json["long_name"] is String) {
      longName = json["long_name"];
    }
    if (json["short_name"] is String) {
      shortName = json["short_name"];
    }
    if (json["types"] is List) {
      types = json["types"] == null ? null : List<String>.from(json["types"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["long_name"] = longName;
    data["short_name"] = shortName;
    if (types != null) {
      data["types"] = types;
    }
    return data;
  }
}