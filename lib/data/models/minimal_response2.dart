class MinimalResponse {
  String? requestType;
  String? minifiedSessionId;
  String? header;
  List<Menu>? menu;
  String? footer;
  int? fieldType;
  int? fieldDataType;
  dynamic authMode;

  MinimalResponse({this.requestType, this.minifiedSessionId, this.header, this.menu, this.footer, this.fieldType, this.fieldDataType, this.authMode});

  MinimalResponse.fromMap(Map<String, dynamic> json) {
    if (json["requestType"] is String) {
      requestType = json["requestType"];
    }
    if (json["minifiedSessionId"] is String) {
      minifiedSessionId = json["minifiedSessionId"];
    }
    if (json["header"] is String) {
      header = json["header"];
    }
    if (json["menu"] is List) {
      menu = json["menu"] == null ? null : (json["menu"] as List).map((e) => Menu.fromMap(e)).toList();
    }
    if (json["footer"] is String) {
      footer = json["footer"];
    }
    if (json["fieldType"] is int) {
      fieldType = json["fieldType"];
    }
    if (json["fieldDataType"] is int) {
      fieldDataType = json["fieldDataType"];
    }
    authMode = json["authMode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["requestType"] = requestType;
    data["minifiedSessionId"] = minifiedSessionId;
    data["header"] = header;
    if (menu != null) {
      data["menu"] = menu?.map((e) => e.toJson()).toList();
    }
    data["footer"] = footer;
    data["fieldType"] = fieldType;
    data["fieldDataType"] = fieldDataType;
    data["authMode"] = authMode;
    return data;
  }
}

class Menu {
  String? key;
  String? value;
  int? dataType;
  bool? payeeTitle;
  bool? payeeValue;
  String? minifiedContent;

  Menu({this.key, this.value, this.dataType, this.payeeTitle, this.payeeValue, this.minifiedContent});

  Menu.fromMap(Map<String, dynamic> json) {
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
    if (json["minifiedContent"] is String) {
      minifiedContent = json["minifiedContent"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["key"] = key;
    data["value"] = value;
    data["dataType"] = dataType;
    data["payeeTitle"] = payeeTitle;
    data["payeeValue"] = payeeValue;
    data["minifiedContent"] = minifiedContent;
    return data;
  }
}