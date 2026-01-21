import 'bulk_payment_groups.dart';

class BulkPaymentGroupPayees {
  Groups? group;
  List<Payees>? payees;

  BulkPaymentGroupPayees({this.group, this.payees});

  BulkPaymentGroupPayees.fromMap(Map<String, dynamic> json) {
    if (json["group"] is Map) {
      group = json["group"] == null ? null : Groups.fromMap(json["group"]);
    }
    if (json["payees"] is List) {
      payees = json["payees"] == null
          ? null
          : (json["payees"] as List).map((e) => Payees.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (group != null) {
      data["group"] = group?.toMap();
    }
    if (payees != null) {
      data["payees"] = payees?.map((e) => e.toMap()).toList();
    }
    return data;
  }

  BulkPaymentGroupPayees copyWith({Groups? group, List<Payees>? payees}) {
    return BulkPaymentGroupPayees(group: group ?? this.group, payees: payees ?? this.payees);
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
  FormData? formData;
  List<PreviewData>? previewData;
  double? amount;
  String? currency;

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
    this.amount,
    this.currency,
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
      formData = json["formData"] == null ? null : FormData.fromMap(json["formData"]);
    }
    if (json["previewData"] is List) {
      previewData = json["previewData"] == null
          ? null
          : (json["previewData"] as List).map((e) => PreviewData.fromMap(e)).toList();
    }
    if (json["amount"] is double || json["amount"] is int) {
      amount = json["amount"];
    }
    if (json["currency"] is String) {
      currency = json["currency"];
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
      data["formData"] = formData?.toMap();
    }
    if (previewData != null) {
      data["previewData"] = previewData?.map((e) => e.toMap()).toList();
    }
    data["amount"] = amount;
    data["currency"] = currency;
    return data;
  }
}

class PreviewData {
  String? key;
  String? value;
  int? dataType;
  bool? payeeTitle;
  bool? payeeValue;
  dynamic minifiedContent;

  PreviewData({
    this.key,
    this.value,
    this.dataType,
    this.payeeTitle,
    this.payeeValue,
    this.minifiedContent,
  });

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

class FormData {
  String? userName;
  String? sourceAccount;
  String? userPhoneNumber;
  String? amount;
  String? narration;

  FormData({this.userName, this.sourceAccount, this.userPhoneNumber, this.amount, this.narration});

  FormData.fromMap(Map<String, dynamic> json) {
    if (json["userName"] is String) {
      userName = json["userName"];
    }
    if (json["sourceAccount"] is String) {
      sourceAccount = json["sourceAccount"];
    }
    if (json["userPhoneNumber"] is String) {
      userPhoneNumber = json["userPhoneNumber"];
    }
    if (json["amount"] is String) {
      amount = json["amount"];
    }
    if (json["narration"] is String) {
      narration = json["narration"];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userName"] = userName;
    data["sourceAccount"] = sourceAccount;
    data["userPhoneNumber"] = userPhoneNumber;
    data["amount"] = amount;
    data["narration"] = narration;
    return data;
  }
}
