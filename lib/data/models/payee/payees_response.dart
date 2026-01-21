class PayeesResponse {
  List<PayeeForm>? forms;
  List<Payees>? payees;

  PayeesResponse({this.forms, this.payees});

  PayeesResponse.fromMap(Map<String, dynamic> json) {
    if (json["forms"] is List) {
      forms = json["forms"] == null
          ? null
          : (json["forms"] as List).map((e) => PayeeForm.fromMap(e)).toList();
    }
    if (json["payees"] is List) {
      payees = json["payees"] == null
          ? null
          : (json["payees"] as List).map((e) => Payees.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (forms != null) {
      data["forms"] = forms?.map((e) => e.toMap()).toList();
    }
    if (payees != null) {
      data["payees"] = payees?.map((e) => e.toMap()).toList();
    }
    return data;
  }
}

class Payees {
  String? payeeId;
  String? activityId;
  String? formId;
  String? formName;
  String? activityName;
  String? activityType;
  String? title;
  String? value;
  String? shortTitle;
  String? icon;
  Map<String, dynamic>? formData;
  List<PreviewData>? previewData;

  Payees({
    this.payeeId,
    this.activityId,
    this.formId,
    this.formName,
    this.activityName,
    this.activityType,
    this.title,
    this.value,
    this.shortTitle,
    this.icon,
    this.formData,
    this.previewData,
  });

  Payees.fromMap(Map<String, dynamic> json) {
    if (json["payeeId"] is String) {
      payeeId = json["payeeId"];
    }
    if (json["activityId"] is String) {
      activityId = json["activityId"];
    }
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["formName"] is String) {
      formName = json["formName"];
    }
    if (json["activityName"] is String) {
      activityName = json["activityName"];
    }
    if (json["activityType"] is String) {
      activityType = json["activityType"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["value"] is String) {
      value = json["value"];
    }
    if (json["shortTitle"] is String) {
      shortTitle = json["shortTitle"];
    }
    if (json["icon"] is String) {
      icon = json["icon"];
    }
    if (json["formData"] is Map) {
      formData = json["formData"] == null ? null : json["formData"] as Map<String, dynamic>;
    }
    if (json["previewData"] is List) {
      previewData = json["previewData"] == null
          ? null
          : (json["previewData"] as List).map((e) => PreviewData.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["payeeId"] = payeeId;
    data["activityId"] = activityId;
    data["formId"] = formId;
    data["formName"] = formName;
    data["activityName"] = activityName;
    data["activityType"] = activityType;
    data["title"] = title;
    data["value"] = value;
    data["shortTitle"] = shortTitle;
    data["icon"] = icon;
    if (formData != null) {
      data["formData"] = formData;
    }
    if (previewData != null) {
      data["previewData"] = previewData?.map((e) => e.toMap()).toList();
    }
    return data;
  }
}

class PreviewData {
  String? key;
  String? value;
  int? dataType;
  bool? payeeTitle;
  bool? payeeValue;

  PreviewData({this.key, this.value, this.dataType, this.payeeTitle, this.payeeValue});

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
    if (json["payeeTitle"] is bool) {
      payeeTitle = json["payeeTitle"];
    }
    if (json["payeeValue"] is bool) {
      payeeValue = json["payeeValue"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["key"] = key;
    data["value"] = value;
    data["dataType"] = dataType;
    data["payeeTitle"] = payeeTitle;
    data["payeeValue"] = payeeValue;
    return data;
  }
}

class PayeeForm {
  String? formId;
  String? activityId;
  String? activityName;
  String? formName;
  String? caption;

  PayeeForm({this.formId, this.activityId, this.activityName, this.formName, this.caption});

  PayeeForm.fromMap(Map<String, dynamic> json) {
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["activityId"] is String) {
      activityId = json["activityId"];
    }
    if (json["activityName"] is String) {
      activityName = json["activityName"];
    }
    if (json["formName"] is String) {
      formName = json["formName"];
    }
    if (json["caption"] is String) {
      caption = json["caption"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["formId"] = formId;
    data["activityId"] = activityId;
    data["activityName"] = activityName;
    data["formName"] = formName;
    data["caption"] = caption;
    return data;
  }
}
