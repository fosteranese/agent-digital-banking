import 'dart:convert';

class PushNotification {
  String? id;
  String? title;
  String? content;
  String? image;
  bool? read;
  Map<String, dynamic>? customData;
  DateTime? sentTime;

  PushNotification({
    this.id,
    this.title,
    this.content,
    this.image,
    this.customData,
    this.read = false,
    this.sentTime,
  });

  PushNotification.fromMap(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["content"] is String) {
      content = json["content"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["customData"] is Map<String, dynamic>) {
      customData = Map<String, dynamic>.from(json['customData']);
    }
    if (json["read"] is bool) {
      read = json["read"];
    } else {
      read = false;
    }
    if (json["sentTime"] is int) {
      sentTime = DateTime.fromMillisecondsSinceEpoch(json['sentTime']);
    }
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (title != null) {
      result.addAll({'title': title});
    }
    if (content != null) {
      result.addAll({'content': content});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (read != null) {
      result.addAll({'read': read});
    }
    if (customData != null) {
      result.addAll({'customData': customData});
    }
    if (sentTime != null) {
      result.addAll({'sentTime': sentTime!.millisecondsSinceEpoch});
    }

    return result;
  }

  PushNotification copyWith({
    String? id,
    String? title,
    String? content,
    String? image,
    bool? read,
    Map<String, dynamic>? customData,
    DateTime? sentTime,
  }) {
    return PushNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      read: read ?? this.read,
      customData: customData ?? this.customData,
      sentTime: sentTime ?? this.sentTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory PushNotification.fromJson(String source) => PushNotification.fromMap(json.decode(source));
}