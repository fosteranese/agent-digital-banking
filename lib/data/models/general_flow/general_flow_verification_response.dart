class GeneralFlowVerificationResponse {
  String? formId;
  Map<String, dynamic>? formData;
  List<PreviewData>? previewData;
  bool? requireSecondFactor;
  dynamic secondFactor;
  List<Map<String, dynamic>>? authMode;

  GeneralFlowVerificationResponse({
    this.formId,
    this.formData,
    this.previewData,
    this.requireSecondFactor,
    this.secondFactor,
    this.authMode,
  });

  GeneralFlowVerificationResponse.fromMap(Map<String, dynamic> json) {
    if (json["formId"] is String) {
      formId = json["formId"];
    }

    formData = json["formData"] as Map<String, dynamic>;

    if (json["previewData"] is List) {
      previewData = json["previewData"] == null
          ? null
          : (json["previewData"] as List).map((e) => PreviewData.fromMap(e)).toList();
    }
    if (json["requireSecondFactor"] is bool) {
      requireSecondFactor = json["requireSecondFactor"];
    }
    secondFactor = json["secondFactor"];
    if (json["authMode"] is List) {
      authMode = json["authMode"] == null
          ? null
          : List<Map<String, dynamic>>.from(json["authMode"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["formId"] = formId;
    if (formData != null) {
      data["formData"] = formData;
    }
    if (previewData != null) {
      data["previewData"] = previewData?.map((e) => e.toMap()).toList();
    }
    data["requireSecondFactor"] = requireSecondFactor;
    data["secondFactor"] = secondFactor;
    if (authMode != null) {
      data["authMode"] = authMode;
    }
    return data;
  }
}

class PreviewData {
  String? key;
  String? value;
  int? dataType;

  PreviewData({this.key, this.value, this.dataType});

  PreviewData.fromMap(Map<String, dynamic> json) {
    if (json["key"] is String) {
      key = json["key"];
    }
    if (json["value"] is String) {
      value = json["value"];
    }
    if (json["dataType"] is int) {
      dataType = json["dataType"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["key"] = key;
    data["value"] = value;
    data["dataType"] = dataType;
    return data;
  }
}
