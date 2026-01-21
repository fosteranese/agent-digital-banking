class AccountOpeningLovs {
  List<Branches>? branches;
  List<AccountTypes>? accountTypes;

  AccountOpeningLovs({this.branches, this.accountTypes});

  AccountOpeningLovs.fromMap(Map<String, dynamic> json) {
    if (json["branches"] is List) {
      branches = json["branches"] == null
          ? null
          : (json["branches"] as List).map((e) => Branches.fromMap(e)).toList();
    }
    if (json["accountTypes"] is List) {
      accountTypes = json["accountTypes"] == null
          ? null
          : (json["accountTypes"] as List).map((e) => AccountTypes.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (branches != null) {
      data["branches"] = branches?.map((e) => e.toMap()).toList();
    }
    if (accountTypes != null) {
      data["accountTypes"] = accountTypes?.map((e) => e.toMap()).toList();
    }
    return data;
  }
}

class AccountTypes {
  String? key;
  String? value;
  int? dataType;
  bool? payeeTitle;
  bool? payeeValue;
  dynamic minifiedContent;

  AccountTypes({
    this.key,
    this.value,
    this.dataType,
    this.payeeTitle,
    this.payeeValue,
    this.minifiedContent,
  });

  AccountTypes.fromMap(Map<String, dynamic> json) {
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
    minifiedContent = json["minifiedContent"];
  }

  Map<String, dynamic> toMap() {
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

class Branches {
  String? key;
  String? value;
  int? dataType;
  bool? payeeTitle;
  bool? payeeValue;
  dynamic minifiedContent;

  Branches({
    this.key,
    this.value,
    this.dataType,
    this.payeeTitle,
    this.payeeValue,
    this.minifiedContent,
  });

  Branches.fromMap(Map<String, dynamic> json) {
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
    minifiedContent = json["minifiedContent"];
  }

  Map<String, dynamic> toMap() {
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
