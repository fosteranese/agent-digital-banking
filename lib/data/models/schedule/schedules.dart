class SchedulesData {
  String? formName;
  String? formId;
  String? activityId;
  List<Schedules>? schedules;

  SchedulesData({this.formName, this.formId, this.activityId, this.schedules});

  SchedulesData.fromMap(Map<String, dynamic> json) {
    if (json["formName"] is String) {
      formName = json["formName"];
    }
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["activityId"] is String) {
      activityId = json["activityId"];
    }
    if (json["schedules"] is List) {
      schedules = json["schedules"] == null
          ? null
          : (json["schedules"] as List).map((e) => Schedules.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["formName"] = formName;
    data["formId"] = formId;
    data["activityId"] = activityId;
    if (schedules != null) {
      data["schedules"] = schedules?.map((e) => e.toMap()).toList();
    }
    return data;
  }

  SchedulesData copyWith({
    String? formName,
    String? formId,
    String? activityId,
    List<Schedules>? schedules,
  }) {
    return SchedulesData(
      formName: formName ?? this.formName,
      formId: formId ?? this.formId,
      activityId: activityId ?? this.activityId,
      schedules: schedules ?? this.schedules,
    );
  }
}

class Schedules {
  Schedule? schedule;
  Payee? payee;

  Schedules({this.schedule, this.payee});

  Schedules.fromMap(Map<String, dynamic> json) {
    if (json["schedule"] is Map) {
      schedule = json["schedule"] == null ? null : Schedule.fromMap(json["schedule"]);
    }
    if (json["payee"] is Map) {
      payee = json["payee"] == null ? null : Payee.fromMap(json["payee"]);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (schedule != null) {
      data["schedule"] = schedule?.toMap();
    }
    if (payee != null) {
      data["payee"] = payee?.toMap();
    }
    return data;
  }
}

class Payee {
  String? payeeId;
  String? activityId;
  dynamic categoryId;
  String? formId;
  String? formName;
  String? activityType;
  String? activityName;
  String? userId;
  String? sessionId;
  String? title;
  String? value;
  String? shortTitle;
  String? icon;
  String? formData;
  String? previewData;
  String? dateCreated;
  int? status;
  String? statusLabel;
  String? lastModified;
  dynamic paymentSource;
  int? amount;
  String? currency;

  Payee({
    this.payeeId,
    this.activityId,
    this.categoryId,
    this.formId,
    this.formName,
    this.activityType,
    this.activityName,
    this.userId,
    this.sessionId,
    this.title,
    this.value,
    this.shortTitle,
    this.icon,
    this.formData,
    this.previewData,
    this.dateCreated,
    this.status,
    this.statusLabel,
    this.lastModified,
    this.paymentSource,
    this.amount,
    this.currency,
  });

  Payee.fromMap(Map<String, dynamic> json) {
    if (json["payeeId"] is String) {
      payeeId = json["payeeId"];
    }
    if (json["activityId"] is String) {
      activityId = json["activityId"];
    }
    categoryId = json["categoryId"];
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    if (json["formName"] is String) {
      formName = json["formName"];
    }
    if (json["activityType"] is String) {
      activityType = json["activityType"];
    }
    if (json["activityName"] is String) {
      activityName = json["activityName"];
    }
    if (json["userId"] is String) {
      userId = json["userId"];
    }
    if (json["sessionId"] is String) {
      sessionId = json["sessionId"];
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
    if (json["formData"] is String) {
      formData = json["formData"];
    }
    if (json["previewData"] is String) {
      previewData = json["previewData"];
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
    if (json["lastModified"] is String) {
      lastModified = json["lastModified"];
    }
    paymentSource = json["paymentSource"];
    if (json["amount"] is int) {
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
    data["categoryId"] = categoryId;
    data["formId"] = formId;
    data["formName"] = formName;
    data["activityType"] = activityType;
    data["activityName"] = activityName;
    data["userId"] = userId;
    data["sessionId"] = sessionId;
    data["title"] = title;
    data["value"] = value;
    data["shortTitle"] = shortTitle;
    data["icon"] = icon;
    data["formData"] = formData;
    data["previewData"] = previewData;
    data["dateCreated"] = dateCreated;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["lastModified"] = lastModified;
    data["paymentSource"] = paymentSource;
    data["amount"] = amount;
    data["currency"] = currency;
    return data;
  }
}

class Schedule {
  String? scheduleId;
  String? userId;
  String? payeeId;
  String? receiptId;
  String? formId;
  dynamic sessionId;
  String? scheduleType;
  String? activityType;
  String? executionType;
  int? executionInterval;
  String? nextExecutionDate;
  String? startDate;
  dynamic endDate;
  int? status;
  String? statusLabel;
  String? dateCreated;
  dynamic lastModified;

  Schedule({
    this.scheduleId,
    this.userId,
    this.payeeId,
    this.receiptId,
    this.formId,
    this.sessionId,
    this.scheduleType,
    this.activityType,
    this.executionType,
    this.executionInterval,
    this.nextExecutionDate,
    this.startDate,
    this.endDate,
    this.status,
    this.statusLabel,
    this.dateCreated,
    this.lastModified,
  });

  Schedule.fromMap(Map<String, dynamic> json) {
    if (json["scheduleId"] is String) {
      scheduleId = json["scheduleId"];
    }
    if (json["userId"] is String) {
      userId = json["userId"];
    }
    if (json["payeeId"] is String) {
      payeeId = json["payeeId"];
    }
    if (json["receiptId"] is String) {
      receiptId = json["receiptId"];
    }
    if (json["formId"] is String) {
      formId = json["formId"];
    }
    sessionId = json["sessionId"];
    if (json["scheduleType"] is String) {
      scheduleType = json["scheduleType"];
    }
    if (json["activityType"] is String) {
      activityType = json["activityType"];
    }
    if (json["executionType"] is String) {
      executionType = json["executionType"];
    }
    if (json["executionInterval"] is int) {
      executionInterval = json["executionInterval"];
    }
    if (json["nextExecutionDate"] is String) {
      nextExecutionDate = json["nextExecutionDate"];
    }
    if (json["startDate"] is String) {
      startDate = json["startDate"];
    }
    endDate = json["endDate"];
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["statusLabel"] is String) {
      statusLabel = json["statusLabel"];
    }
    if (json["dateCreated"] is String) {
      dateCreated = json["dateCreated"];
    }
    lastModified = json["lastModified"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["scheduleId"] = scheduleId;
    data["userId"] = userId;
    data["payeeId"] = payeeId;
    data["receiptId"] = receiptId;
    data["formId"] = formId;
    data["sessionId"] = sessionId;
    data["scheduleType"] = scheduleType;
    data["activityType"] = activityType;
    data["executionType"] = executionType;
    data["executionInterval"] = executionInterval;
    data["nextExecutionDate"] = nextExecutionDate;
    data["startDate"] = startDate;
    data["endDate"] = endDate;
    data["status"] = status;
    data["statusLabel"] = statusLabel;
    data["dateCreated"] = dateCreated;
    data["lastModified"] = lastModified;
    return data;
  }
}
