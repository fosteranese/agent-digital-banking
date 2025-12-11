class BankInfra {
  InfraType? type;
  List<Locators>? locators;

  BankInfra({
    this.type,
    this.locators,
  });

  BankInfra.fromMap(Map<String, dynamic> json) {
    if (json["type"] is Map) {
      type = json["type"] == null ? null : InfraType.fromMap(json["type"]);
    }
    if (json["locators"] is List) {
      locators = json["locators"] == null ? null : (json["locators"] as List).map((e) => Locators.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (type != null) {
      data["type"] = type?.toMap();
    }
    if (locators != null) {
      data["locators"] = locators?.map((e) => e.toMap()).toList();
    }
    return data;
  }
}

class Locators {
  String? locatorId;
  String? typeId;
  String? title;
  String? location;
  String? ghanaPostCode;
  String? email;
  String? phoneNumber;
  String? serviceHours;
  int? status;
  String? statusLabel;
  String? dateCreated;
  String? createdBy;
  String? lastModified;
  String? modifiedBy;
  String? longitude;
  String? latitude;
  String? otherInformation;
  int? rank;

  Locators({
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

  Locators.fromMap(Map<String, dynamic> json) {
    if (json["locatorId"] is String) {
      locatorId = json["locatorId"];
    }
    if (json["typeId"] is String) {
      typeId = json["typeId"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["location"] is String) {
      location = json["location"];
    }
    ghanaPostCode = json["ghanaPostCode"];
    email = json["email"];
    phoneNumber = json["phoneNumber"];
    serviceHours = json["serviceHours"];
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["statusLabel"] is String) {
      statusLabel = json["statusLabel"];
    }
    if (json["dateCreated"] is String) {
      dateCreated = json["dateCreated"];
    }
    createdBy = json["createdBy"];
    lastModified = json["lastModified"];
    modifiedBy = json["modifiedBy"];
    if (json["longitude"] is String) {
      longitude = json["longitude"];
    }
    if (json["latitude"] is String) {
      latitude = json["latitude"];
    }
    if (json["otherInformation"] is String) {
      otherInformation = json["otherInformation"];
    }
    if (json["rank"] is int) {
      rank = json["rank"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["locatorId"] = locatorId;
    data["typeId"] = typeId;
    data["title"] = title;
    data["location"] = location;
    data["ghanaPostCode"] = ghanaPostCode;
    data["email"] = email;
    data["phoneNumber"] = phoneNumber;
    data["serviceHours"] = serviceHours;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["dateCreated"] = dateCreated;
    data["createdBy"] = createdBy;
    data["lastModified"] = lastModified;
    data["modifiedBy"] = modifiedBy;
    data["longitude"] = longitude;
    data["latitude"] = latitude;
    data["otherInformation"] = otherInformation;
    data["rank"] = rank;
    return data;
  }
}

class InfraType {
  String? typeId;
  String? picture;
  String? title;
  String? description;
  int? status;
  String? dateCreated;
  int? rank;

  InfraType({
    this.typeId,
    this.picture,
    this.title,
    this.description,
    this.status,
    this.dateCreated,
    this.rank,
  });

  InfraType.fromMap(Map<String, dynamic> json) {
    if (json["typeId"] is String) {
      typeId = json["typeId"];
    }
    picture = json["picture"];
    if (json["title"] is String) {
      title = json["title"];
    }
    description = json["description"];
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["dateCreated"] is String) {
      dateCreated = json["dateCreated"];
    }
    if (json["rank"] is int) {
      rank = json["rank"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["typeId"] = typeId;
    data["picture"] = picture;
    data["title"] = title;
    data["description"] = description;
    data["status"] = status;
    data["dateCreated"] = dateCreated;
    data["rank"] = rank;
    return data;
  }
}