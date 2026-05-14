class NextOfKinModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String emailAddress;

  NextOfKinModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["fullName"] = fullName;
    data["phoneNumber"] = phoneNumber;
    data["emailAddress"] = emailAddress;

    return data;
  }
}
