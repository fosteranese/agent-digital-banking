class VerifyIdResponse {
  dynamic otpData;
  String? ghCardUrl;
  String? registrationId;
  String? resetSecurityAnswer;
  dynamic externalUrl;
  String? imageBaseUrl;
  String? accessType;

  VerifyIdResponse({
    this.otpData,
    this.ghCardUrl,
    this.registrationId,
    this.resetSecurityAnswer,
    this.externalUrl,
    this.imageBaseUrl,
    this.accessType,
  });

  VerifyIdResponse.fromMap(Map<String, dynamic> json) {
    otpData = json["otpData"];
    if (json["ghCardUrl"] is String) {
      ghCardUrl = json["ghCardUrl"];
    }
    if (json["registrationId"] is String) {
      registrationId = json["registrationId"];
    }
    if (json["resetSecurityAnswer"] is String) {
      resetSecurityAnswer = json["resetSecurityAnswer"];
    }
    imageBaseUrl = json["imageBaseUrl"];
    if (json["imageBaseUrl"] is String) {
      imageBaseUrl = json["imageBaseUrl"];
    }
    accessType = json["accessType"];
    if (json["accessType"] is String) {
      accessType = json["accessType"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["otpData"] = otpData;
    data["ghCardUrl"] = ghCardUrl;
    data["registrationId"] = registrationId;
    data["resetSecurityAnswer"] = resetSecurityAnswer;
    data["externalUrl"] = externalUrl;
    data["imageBaseUrl"] = imageBaseUrl;
    data["accessType"] = accessType;
    return data;
  }
}