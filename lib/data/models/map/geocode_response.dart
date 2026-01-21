class GeocodeResponse {
  PlusCode? plusCode;
  List<Results>? results;
  String? status;

  GeocodeResponse({this.plusCode, this.results, this.status});

  GeocodeResponse.fromMap(Map<String, dynamic> json) {
    if (json["plus_code"] is Map) {
      plusCode = json["plus_code"] == null ? null : PlusCode.fromMap(json["plus_code"]);
    }
    if (json["results"] is List) {
      results = json["results"] == null
          ? null
          : (json["results"] as List).map((e) => Results.fromMap(e)).toList();
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plusCode != null) {
      data["plus_code"] = plusCode?.toMap();
    }
    if (results != null) {
      data["results"] = results?.map((e) => e.toMap()).toList();
    }
    data["status"] = status;
    return data;
  }
}

class Results {
  List<AddressComponents>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  List<String>? types;

  Results({this.addressComponents, this.formattedAddress, this.geometry, this.placeId, this.types});

  Results.fromMap(Map<String, dynamic> json) {
    if (json["address_components"] is List) {
      addressComponents = json["address_components"] == null
          ? null
          : (json["address_components"] as List).map((e) => AddressComponents.fromMap(e)).toList();
    }
    if (json["formatted_address"] is String) {
      formattedAddress = json["formatted_address"];
    }
    if (json["geometry"] is Map) {
      geometry = json["geometry"] == null ? null : Geometry.fromMap(json["geometry"]);
    }
    if (json["place_id"] is String) {
      placeId = json["place_id"];
    }
    if (json["types"] is List) {
      types = json["types"] == null ? null : List<String>.from(json["types"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addressComponents != null) {
      data["address_components"] = addressComponents?.map((e) => e.toMap()).toList();
    }
    data["formatted_address"] = formattedAddress;
    if (geometry != null) {
      data["geometry"] = geometry?.toMap();
    }
    data["place_id"] = placeId;
    if (types != null) {
      data["types"] = types;
    }
    return data;
  }
}

class Geometry {
  Bounds? bounds;
  Location? location;
  String? locationType;
  Viewport? viewport;

  Geometry({this.bounds, this.location, this.locationType, this.viewport});

  Geometry.fromMap(Map<String, dynamic> json) {
    if (json["bounds"] is Map) {
      bounds = json["bounds"] == null ? null : Bounds.fromMap(json["bounds"]);
    }
    if (json["location"] is Map) {
      location = json["location"] == null ? null : Location.fromMap(json["location"]);
    }
    if (json["location_type"] is String) {
      locationType = json["location_type"];
    }
    if (json["viewport"] is Map) {
      viewport = json["viewport"] == null ? null : Viewport.fromMap(json["viewport"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bounds != null) {
      data["bounds"] = bounds?.toMap();
    }
    if (location != null) {
      data["location"] = location?.toMap();
    }
    data["location_type"] = locationType;
    if (viewport != null) {
      data["viewport"] = viewport?.toMap();
    }
    return data;
  }
}

class Viewport {
  Northeast1? northeast;
  Southwest1? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromMap(Map<String, dynamic> json) {
    if (json["northeast"] is Map) {
      northeast = json["northeast"] == null ? null : Northeast1.fromMap(json["northeast"]);
    }
    if (json["southwest"] is Map) {
      southwest = json["southwest"] == null ? null : Southwest1.fromMap(json["southwest"]);
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

class Southwest1 {
  double? lat;
  double? lng;

  Southwest1({this.lat, this.lng});

  Southwest1.fromMap(Map<String, dynamic> json) {
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

class Northeast1 {
  double? lat;
  double? lng;

  Northeast1({this.lat, this.lng});

  Northeast1.fromMap(Map<String, dynamic> json) {
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

class Bounds {
  Northeast? northeast;
  Southwest? southwest;

  Bounds({this.northeast, this.southwest});

  Bounds.fromMap(Map<String, dynamic> json) {
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

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromMap(Map<String, dynamic> json) {
    if (json["compound_code"] is String) {
      compoundCode = json["compound_code"];
    }
    if (json["global_code"] is String) {
      globalCode = json["global_code"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["compound_code"] = compoundCode;
    data["global_code"] = globalCode;
    return data;
  }
}
