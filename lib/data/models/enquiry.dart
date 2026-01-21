class Enquiry {
  String? title;
  String? endPoint;
  String? formId;
  dynamic activityId;
  bool? hasEnquiry;
  String? activityType;
  dynamic header;
  List<Sources>? sources;

  Enquiry({
    this.title,
    this.endPoint,
    this.formId,
    this.activityId,
    this.hasEnquiry,
    this.activityType,
    this.header,
    this.sources,
  });

  Enquiry.fromMap(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["endPoint"] is String) {
      endPoint = json["endPoint"];
    }
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    activityId = json["activityId"];
    if (json["hasEnquiry"] is bool) {
      hasEnquiry = json["hasEnquiry"];
    }
    if (json["activityType"] is String) {
      activityType = json["activityType"];
    }
    header = json["header"];
    if (json["sources"] is List) {
      sources = json["sources"] == null
          ? null
          : (json["sources"] as List).map((e) => Sources.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["endPoint"] = endPoint;
    data["formId"] = formId;
    data["activityId"] = activityId;
    data["hasEnquiry"] = hasEnquiry;
    data["activityType"] = activityType;
    data["header"] = header;
    if (sources != null) {
      data["sources"] = sources?.map((e) => e.toMap()).toList();
    }
    return data;
  }
}

class Sources {
  String? formId;
  String? hashValue;
  List<Source>? source;

  Sources({this.formId, this.hashValue, this.source});

  Sources.fromMap(Map<String, dynamic> json) {
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["hashValue"] is String) {
      hashValue = json["hashValue"];
    }
    if (json["source"] is List) {
      source = json["source"] == null
          ? null
          : (json["source"] as List).map((e) => Source.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["formId"] = formId;
    data["hashValue"] = hashValue;
    if (source != null) {
      data["source"] = source?.map((e) => e.toMap()).toList();
    }
    return data;
  }
}

class Source {
  String? key;
  String? value;
  int? dataType;
  bool? payeeTitle;
  bool? payeeValue;

  Source({this.key, this.value, this.dataType, this.payeeTitle, this.payeeValue});

  Source.fromMap(Map<String, dynamic> json) {
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
