class InitializationResponse {
  List<WalkThrough>? walkThrough;
  String? termsAndConditions;
  String? privacyPolicy;
  List<SecretQuestions>? secretQuestions;
  Help? help;
  dynamic locatorsList;
  List<LocatorTypes>? locatorTypes;
  Social1? social;
  List<Advert>? adverts;
  String? imageBaseUrl;
  String? imageDirectory;

  InitializationResponse({
    this.walkThrough,
    this.termsAndConditions,
    this.privacyPolicy,
    this.secretQuestions,
    this.help,
    this.locatorsList,
    this.locatorTypes,
    this.social,
    this.adverts,
    this.imageBaseUrl,
    this.imageDirectory,
  });

  InitializationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json["walkThrough"] is List) {
      walkThrough = json["walkThrough"] == null
          ? null
          : (json["walkThrough"] as List)
                .map((e) => WalkThrough.fromJson(e))
                .toList();
    }
    if (json["termsAndConditions"] is String) {
      termsAndConditions = json["termsAndConditions"];
    }
    if (json["privacyPolicy"] is String) {
      privacyPolicy = json["privacyPolicy"];
    }
    if (json["secretQuestions"] is List) {
      secretQuestions = json["secretQuestions"] == null
          ? null
          : (json["secretQuestions"] as List)
                .map((e) => SecretQuestions.fromJson(e))
                .toList();
    }
    if (json["help"] is Map) {
      help = json["help"] == null
          ? null
          : Help.fromJson(json["help"]);
    }
    locatorsList = json["locatorsList"];
    if (json["locatorTypes"] is List) {
      locatorTypes = json["locatorTypes"] == null
          ? null
          : (json["locatorTypes"] as List)
                .map((e) => LocatorTypes.fromJson(e))
                .toList();
    }
    if (json["social"] is Map) {
      social = json["social"] == null
          ? null
          : Social1.fromJson(json["social"]);
    }
    if (json["advert"] is List) {
      adverts = json["advert"] == null
          ? null
          : (json["advert"] as List)
                .map((e) => Advert.fromJson(e))
                .toList();
    }
    if (json["imageBaseUrl"] is String) {
      imageBaseUrl = json["imageBaseUrl"];
    }
    if (json["imageDirectory"] is String) {
      imageDirectory = json["imageDirectory"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (walkThrough != null) {
      data["walkThrough"] = walkThrough
          ?.map((e) => e.toJson())
          .toList();
    }
    data["termsAndConditions"] = termsAndConditions;
    data["privacyPolicy"] = privacyPolicy;
    if (secretQuestions != null) {
      data["secretQuestions"] = secretQuestions
          ?.map((e) => e.toJson())
          .toList();
    }
    if (help != null) {
      data["help"] = help?.toJson();
    }
    data["locatorsList"] = locatorsList;
    if (locatorTypes != null) {
      data["locatorTypes"] = locatorTypes
          ?.map((e) => e.toJson())
          .toList();
    }
    if (social != null) {
      data["social"] = social?.toJson();
    }
    if (adverts != null) {
      data["advert"] = adverts
          ?.map((e) => e.toJson())
          .toList();
    }
    data["imageBaseUrl"] = imageBaseUrl;
    data["imageDirectory"] = imageDirectory;
    return data;
  }

  InitializationResponse copyWith({
    List<WalkThrough>? walkThrough,
    String? termsAndConditions,
    String? privacyPolicy,
    List<SecretQuestions>? secretQuestions,
    Help? help,
    dynamic locatorsList,
    List<LocatorTypes>? locatorTypes,
    Social1? social,
    List<Advert>? adverts,
    String? imageBaseUrl,
    String? imageDirectory,
  }) {
    return InitializationResponse(
      walkThrough: walkThrough ?? this.walkThrough,
      termsAndConditions:
          termsAndConditions ?? this.termsAndConditions,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      secretQuestions:
          secretQuestions ?? this.secretQuestions,
      help: help ?? this.help,
      locatorsList: locatorsList ?? this.locatorsList,
      locatorTypes: locatorTypes ?? this.locatorTypes,
      social: social ?? this.social,
      adverts: adverts ?? this.adverts,
      imageBaseUrl: imageBaseUrl ?? this.imageBaseUrl,
      imageDirectory: imageDirectory ?? this.imageDirectory,
    );
  }
}

class Social1 {
  String? twitter;
  String? instagram;
  String? tikTok;
  String? facebook;
  String? linkedIn;
  String? youTube;

  Social1({
    this.twitter,
    this.instagram,
    this.tikTok,
    this.facebook,
    this.linkedIn,
    this.youTube,
  });

  Social1.fromJson(Map<String, dynamic> json) {
    if (json["twitter"] is String) {
      twitter = json["twitter"];
    }
    if (json["instagram"] is String) {
      instagram = json["instagram"];
    }
    if (json["tikTok"] is String) {
      tikTok = json["tikTok"];
    }
    if (json["facebook"] is String) {
      facebook = json["facebook"];
    }
    if (json["linkedIn"] is String) {
      linkedIn = json["linkedIn"];
    }
    if (json["youTube"] is String) {
      youTube = json["youTube"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["twitter"] = twitter;
    data["instagram"] = instagram;
    data["tikTok"] = tikTok;
    data["facebook"] = facebook;
    data["linkedIn"] = linkedIn;
    data["youTube"] = youTube;
    return data;
  }
}

class LocatorTypes {
  String? typeId;
  dynamic picture;
  String? title;
  dynamic description;
  int? status;
  String? dateCreated;
  int? rank;

  LocatorTypes({
    this.typeId,
    this.picture,
    this.title,
    this.description,
    this.status,
    this.dateCreated,
    this.rank,
  });

  LocatorTypes.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
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

class Help {
  String? privacyUrl;
  String? termsUrl;
  String? websiteUrl;
  String? faqUrl;
  String? email;
  String? phoneNumber;
  String? whatsApp;
  String? linkGhCard;
  String? formId;
  String? descrption;
  Social? social;
  String? activityType;

  Help({
    this.privacyUrl,
    this.termsUrl,
    this.websiteUrl,
    this.faqUrl,
    this.email,
    this.phoneNumber,
    this.whatsApp,
    this.linkGhCard,
    this.formId,
    this.descrption,
    this.social,
    this.activityType,
  });

  Help.fromJson(Map<String, dynamic> json) {
    if (json["privacyUrl"] is String) {
      privacyUrl = json["privacyUrl"];
    }
    if (json["termsUrl"] is String) {
      termsUrl = json["termsUrl"];
    }
    if (json["websiteUrl"] is String) {
      websiteUrl = json["websiteUrl"];
    }
    if (json["faqUrl"] is String) {
      faqUrl = json["faqUrl"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["phoneNumber"] is String) {
      phoneNumber = json["phoneNumber"];
    }
    if (json["whatsApp"] is String) {
      whatsApp = json["whatsApp"];
    }
    if (json["linkGHCard"] is String) {
      linkGhCard = json["linkGHCard"];
    }
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["descrption"] is String) {
      descrption = json["descrption"];
    }
    if (json["social"] is Map) {
      social = json["social"] == null
          ? null
          : Social.fromJson(json["social"]);
    }
    if (json["activityType"] is String) {
      activityType = json["activityType"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["privacyUrl"] = privacyUrl;
    data["termsUrl"] = termsUrl;
    data["websiteUrl"] = websiteUrl;
    data["faqUrl"] = faqUrl;
    data["email"] = email;
    data["phoneNumber"] = phoneNumber;
    data["whatsApp"] = whatsApp;
    data["linkGHCard"] = linkGhCard;
    data["formId"] = formId;
    data["descrption"] = descrption;
    if (social != null) {
      data["social"] = social?.toJson();
    }
    data["activityType"] = activityType;
    return data;
  }
}

class Social {
  String? twitter;
  String? instagram;
  String? tikTok;
  String? facebook;
  String? linkedIn;
  String? youTube;

  Social({
    this.twitter,
    this.instagram,
    this.tikTok,
    this.facebook,
    this.linkedIn,
    this.youTube,
  });

  Social.fromJson(Map<String, dynamic> json) {
    if (json["twitter"] is String) {
      twitter = json["twitter"];
    }
    if (json["instagram"] is String) {
      instagram = json["instagram"];
    }
    if (json["tikTok"] is String) {
      tikTok = json["tikTok"];
    }
    if (json["facebook"] is String) {
      facebook = json["facebook"];
    }
    if (json["linkedIn"] is String) {
      linkedIn = json["linkedIn"];
    }
    if (json["youTube"] is String) {
      youTube = json["youTube"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["twitter"] = twitter;
    data["instagram"] = instagram;
    data["tikTok"] = tikTok;
    data["facebook"] = facebook;
    data["linkedIn"] = linkedIn;
    data["youTube"] = youTube;
    return data;
  }
}

class SecretQuestions {
  String? questionId;
  String? title;
  int? status;
  String? statusLabel;
  dynamic dateCreated;
  String? createdBy;

  SecretQuestions({
    this.questionId,
    this.title,
    this.status,
    this.statusLabel,
    this.dateCreated,
    this.createdBy,
  });

  SecretQuestions.fromJson(Map<String, dynamic> json) {
    if (json["questionId"] is String) {
      questionId = json["questionId"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["statusLabel"] is String) {
      statusLabel = json["statusLabel"];
    }
    dateCreated = json["dateCreated"];
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["questionId"] = questionId;
    data["title"] = title;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["dateCreated"] = dateCreated;
    data["createdBy"] = createdBy;
    return data;
  }
}

class WalkThrough {
  String? walkId;
  String? title;
  String? description;
  String? picture;
  String? pictureWeb;
  int? walktype;
  String? walkTarget;
  String? walkUrl;
  String? dateCreated;
  int? status;
  String? statusLabel;
  String? createdBy;
  String? lastModified;
  String? pictureBase64;

  WalkThrough({
    this.walkId,
    this.title,
    this.description,
    this.picture,
    this.pictureWeb,
    this.walktype,
    this.walkTarget,
    this.walkUrl,
    this.dateCreated,
    this.status,
    this.statusLabel,
    this.createdBy,
    this.lastModified,
    this.pictureBase64,
  });

  WalkThrough.fromJson(Map<String, dynamic> json) {
    if (json["walkId"] is String) {
      walkId = json["walkId"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["picture"] is String) {
      picture = json["picture"];
    }
    if (json["pictureWeb"] is String) {
      pictureWeb = json["pictureWeb"];
    }
    if (json["walktype"] is int) {
      walktype = json["walktype"];
    }
    if (json["walkTarget"] is String) {
      walkTarget = json["walkTarget"];
    }
    if (json["walkUrl"] is String) {
      walkUrl = json["walkUrl"];
    }
    if (json["dateCreated"] is String) {
      dateCreated = json["dateCreated"];
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["statusLabel"] is String) {
      statusLabel = json["statusLabel"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["lastModified"] is String) {
      lastModified = json["lastModified"];
    }
    if (json["pictureBase64"] is String) {
      pictureBase64 = json["pictureBase64"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["walkId"] = walkId;
    data["title"] = title;
    data["description"] = description;
    data["picture"] = picture;
    data["pictureWeb"] = pictureWeb;
    data["walktype"] = walktype;
    data["walkTarget"] = walkTarget;
    data["walkUrl"] = walkUrl;
    data["dateCreated"] = dateCreated;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["createdBy"] = createdBy;
    data["lastModified"] = lastModified;
    data["pictureBase64"] = pictureBase64;
    return data;
  }

  WalkThrough copyWith({
    String? walkId,
    String? title,
    String? description,
    String? picture,
    String? pictureWeb,
    int? walktype,
    String? walkTarget,
    String? walkUrl,
    String? dateCreated,
    int? status,
    String? statusLabel,
    String? createdBy,
    String? lastModified,
    String? pictureBase64,
  }) {
    return WalkThrough(
      walkId: walkId ?? this.walkId,
      title: title ?? this.title,
      description: description ?? this.description,
      picture: picture ?? this.picture,
      pictureWeb: pictureWeb ?? this.pictureWeb,
      walktype: walktype ?? this.walktype,
      walkTarget: walkTarget ?? this.walkTarget,
      walkUrl: walkUrl ?? this.walkUrl,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      createdBy: createdBy ?? this.createdBy,
      lastModified: lastModified ?? this.lastModified,
      pictureBase64: pictureBase64 ?? this.pictureBase64,
    );
  }
}

class Advert {
  String? walkId;
  String? title;
  String? description;
  String? picture;
  String? pictureWeb;
  int? walktype;
  String? walkTarget;
  String? walkUrl;
  String? dateCreated;
  int? status;
  String? statusLabel;
  String? createdBy;
  String? lastModified;

  Advert({
    this.walkId,
    this.title,
    this.description,
    this.picture,
    this.pictureWeb,
    this.walktype,
    this.walkTarget,
    this.walkUrl,
    this.dateCreated,
    this.status,
    this.statusLabel,
    this.createdBy,
    this.lastModified,
  });

  Advert.fromJson(Map<String, dynamic> json) {
    if (json["walkId"] is String) {
      walkId = json["walkId"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["picture"] is String) {
      picture = json["picture"];
    }
    if (json["pictureWeb"] is String) {
      pictureWeb = json["pictureWeb"];
    }
    if (json["walktype"] is int) {
      walktype = json["walktype"];
    }
    if (json["walkTarget"] is String) {
      walkTarget = json["walkTarget"];
    }
    if (json["walkUrl"] is String) {
      walkUrl = json["walkUrl"];
    }
    if (json["dateCreated"] is String) {
      dateCreated = json["dateCreated"];
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["statusLabel"] is String) {
      statusLabel = json["statusLabel"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["lastModified"] is String) {
      lastModified = json["lastModified"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["walkId"] = walkId;
    data["title"] = title;
    data["description"] = description;
    data["picture"] = picture;
    data["pictureWeb"] = pictureWeb;
    data["walktype"] = walktype;
    data["walkTarget"] = walkTarget;
    data["walkUrl"] = walkUrl;
    data["dateCreated"] = dateCreated;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["createdBy"] = createdBy;
    data["lastModified"] = lastModified;
    return data;
  }
}