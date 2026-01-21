class BulkPaymentGroups {
  String? formName;
  String? formId;
  String? activityId;
  List<Groups>? groups;

  BulkPaymentGroups({this.formName, this.formId, this.activityId, this.groups});

  BulkPaymentGroups.fromMap(Map<String, dynamic> json) {
    if (json["formName"] is String) {
      formName = json["formName"];
    }
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["activityId"] is String) {
      activityId = json["activityId"];
    }
    if (json["groups"] is List) {
      groups = json["groups"] == null
          ? null
          : (json["groups"] as List).map((e) => Groups.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["formName"] = formName;
    data["formId"] = formId;
    data["activityId"] = activityId;
    if (groups != null) {
      data["groups"] = groups?.map((e) => e.toMap()).toList();
    }
    return data;
  }

  BulkPaymentGroups copyWith({
    String? formName,
    String? formId,
    String? activityId,
    List<Groups>? groups,
  }) {
    return BulkPaymentGroups(
      formName: formName ?? this.formName,
      formId: formId ?? this.formId,
      activityId: activityId ?? this.activityId,
      groups: groups ?? this.groups,
    );
  }
}

class Groups {
  String? groupId;
  String? userId;
  String? title;
  String? formattedAmount;
  String? description;
  int? numberOfPayee;
  double? totalAmount;
  String? currency;
  String? icon;
  String? dateCreated;
  int? status;
  String? statusLabel;
  String? sessionId;
  dynamic dateModified;

  Groups({
    this.groupId,
    this.userId,
    this.title,
    this.formattedAmount,
    this.description,
    this.numberOfPayee,
    this.totalAmount,
    this.currency,
    this.icon,
    this.dateCreated,
    this.status,
    this.statusLabel,
    this.sessionId,
    this.dateModified,
  });

  Groups.fromMap(Map<String, dynamic> json) {
    if (json["groupId"] is String) {
      groupId = json["groupId"];
    }
    if (json["userId"] is String) {
      userId = json["userId"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["formattedAmount"] is String) {
      title = json["formattedAmount"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["numberOfPayee"] is int) {
      numberOfPayee = json["numberOfPayee"];
    }
    if (json["totalAmount"] is double) {
      totalAmount = json["totalAmount"];
    }
    if (json["currency"] is String) {
      currency = json["currency"];
    }
    if (json["icon"] is String) {
      icon = json["icon"];
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
    if (json["sessionId"] is String) {
      sessionId = json["sessionId"];
    }
    dateModified = json["dateModified"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["groupId"] = groupId;
    data["userId"] = userId;
    data["title"] = title;
    data["formattedAmount"] = formattedAmount;
    data["description"] = description;
    data["numberOfPayee"] = numberOfPayee;
    data["totalAmount"] = totalAmount;
    data["currency"] = currency;
    data["icon"] = icon;
    data["dateCreated"] = dateCreated;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["sessionId"] = sessionId;
    data["dateModified"] = dateModified;
    return data;
  }

  Groups copyWith({
    String? groupId,
    String? userId,
    String? title,
    String? formattedAmount,
    String? description,
    int? numberOfPayee,
    double? totalAmount,
    String? currency,
    String? icon,
    String? dateCreated,
    int? status,
    String? statusLabel,
    String? sessionId,
    dynamic dateModified,
  }) {
    return Groups(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      formattedAmount: formattedAmount ?? this.formattedAmount,
      description: description ?? this.description,
      numberOfPayee: numberOfPayee ?? this.numberOfPayee,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      icon: icon ?? this.icon,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      sessionId: sessionId ?? this.sessionId,
      dateModified: dateModified ?? this.dateModified,
    );
  }
}
