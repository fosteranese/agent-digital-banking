class GoogleMapAutoCompleteResponse {
  List<Predictions>? predictions;
  String? status;

  GoogleMapAutoCompleteResponse({
    this.predictions,
    this.status,
  });

  GoogleMapAutoCompleteResponse.fromMap(Map<String, dynamic> json) {
    if (json["predictions"] is List) {
      predictions = json["predictions"] == null ? null : (json["predictions"] as List).map((e) => Predictions.fromMap(e)).toList();
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data["predictions"] = predictions?.map((e) => e.toMap()).toList();
    }
    data["status"] = status;
    return data;
  }
}

class Predictions {
  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;

  Predictions({this.description, this.matchedSubstrings, this.placeId, this.reference, this.structuredFormatting, this.terms, this.types});

  Predictions.fromMap(Map<String, dynamic> json) {
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["matched_substrings"] is List) {
      matchedSubstrings = json["matched_substrings"] == null ? null : (json["matched_substrings"] as List).map((e) => MatchedSubstrings.fromMap(e)).toList();
    }
    if (json["place_id"] is String) {
      placeId = json["place_id"];
    }
    if (json["reference"] is String) {
      reference = json["reference"];
    }
    if (json["structured_formatting"] is Map) {
      structuredFormatting = json["structured_formatting"] == null ? null : StructuredFormatting.fromMap(json["structured_formatting"]);
    }
    if (json["terms"] is List) {
      terms = json["terms"] == null ? null : (json["terms"] as List).map((e) => Terms.fromMap(e)).toList();
    }
    if (json["types"] is List) {
      types = json["types"] == null ? null : List<String>.from(json["types"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["description"] = description;
    if (matchedSubstrings != null) {
      data["matched_substrings"] = matchedSubstrings?.map((e) => e.toMap()).toList();
    }
    data["place_id"] = placeId;
    data["reference"] = reference;
    if (structuredFormatting != null) {
      data["structured_formatting"] = structuredFormatting?.toMap();
    }
    if (terms != null) {
      data["terms"] = terms?.map((e) => e.toMap()).toList();
    }
    if (types != null) {
      data["types"] = types;
    }
    return data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromMap(Map<String, dynamic> json) {
    if (json["offset"] is int) {
      offset = json["offset"];
    }
    if (json["value"] is String) {
      value = json["value"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["offset"] = offset;
    data["value"] = value;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  StructuredFormatting.fromMap(Map<String, dynamic> json) {
    if (json["main_text"] is String) {
      mainText = json["main_text"];
    }
    if (json["main_text_matched_substrings"] is List) {
      mainTextMatchedSubstrings = json["main_text_matched_substrings"] == null ? null : (json["main_text_matched_substrings"] as List).map((e) => MainTextMatchedSubstrings.fromMap(e)).toList();
    }
    if (json["secondary_text"] is String) {
      secondaryText = json["secondary_text"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["main_text"] = mainText;
    if (mainTextMatchedSubstrings != null) {
      data["main_text_matched_substrings"] = mainTextMatchedSubstrings?.map((e) => e.toMap()).toList();
    }
    data["secondary_text"] = secondaryText;
    return data;
  }
}

class MainTextMatchedSubstrings {
  int? length;
  int? offset;

  MainTextMatchedSubstrings({this.length, this.offset});

  MainTextMatchedSubstrings.fromMap(Map<String, dynamic> json) {
    if (json["length"] is int) {
      length = json["length"];
    }
    if (json["offset"] is int) {
      offset = json["offset"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["offset"] = offset;
    return data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromMap(Map<String, dynamic> json) {
    if (json["length"] is int) {
      length = json["length"];
    }
    if (json["offset"] is int) {
      offset = json["offset"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["offset"] = offset;
    return data;
  }
}