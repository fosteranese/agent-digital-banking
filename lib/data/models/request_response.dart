import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'history/preview_datum.dart';

class RequestResponse extends Equatable {
  final String? receiptId;
  final String? reference;
  final String? amount;
  final int? status;
  final String? statusLabel;
  final String? formName;
  final String? customerName;
  final String? activityName;
  final String? dateCreated;
  final String? receiptDate;
  final int? showReceipt;
  final int? saveBenficiary;
  final int? allowSchedule;
  final List<PreviewDatum>? previewData;
  final dynamic scheduleForm;
  final String? benficiaryEndpoint;
  final String? comment;
  final String? icon;
  final String? fblLogo;
  final String? receiptDateTime;

  const RequestResponse({
    this.receiptId,
    this.reference,
    this.amount,
    this.status,
    this.statusLabel,
    this.formName,
    this.customerName,
    this.activityName,
    this.dateCreated,
    this.receiptDate,
    this.showReceipt,
    this.saveBenficiary,
    this.allowSchedule,
    this.previewData,
    this.scheduleForm,
    this.benficiaryEndpoint,
    this.comment,
    this.icon,
    this.fblLogo,
    this.receiptDateTime,
  });

  factory RequestResponse.fromMap(Map<String, dynamic> data) => RequestResponse(
    receiptId: data['receiptId'] as String?,
    reference: data['reference'] as String?,
    amount: data['amount'] as String?,
    status: data['status'] as int?,
    statusLabel: data['statusLabel'] as String?,
    formName: data['formName'] as String?,
    customerName: data['customerName'] as String?,
    activityName: data['activityName'] as String?,
    dateCreated: data['dateCreated'] as String?,
    receiptDate: data['receiptDate'] as String?,
    showReceipt: data['showReceipt'] as int?,
    saveBenficiary: data['saveBenficiary'] as int?,
    allowSchedule: data['allowSchedule'] as int?,
    previewData: (data['previewData'] as List<dynamic>?)
        ?.map((e) => PreviewDatum.fromMap(e as Map<String, dynamic>))
        .toList(),
    scheduleForm: data['scheduleForm'] as dynamic,
    benficiaryEndpoint: data['benficiaryEndpoint'] as String?,
    comment: data['comment'] as String?,
    icon: data['icon'] as String?,
    fblLogo: data['fblLogo'] as String?,
    receiptDateTime: data['receiptDateTime'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'receiptId': receiptId,
    'reference': reference,
    'amount': amount,
    'status': status,
    'statusLabel': statusLabel,
    'formName': formName,
    'customerName': customerName,
    'activityName': activityName,
    'dateCreated': dateCreated,
    'receiptDate': receiptDate,
    'showReceipt': showReceipt,
    'saveBenficiary': saveBenficiary,
    'allowSchedule': allowSchedule,
    'previewData': previewData?.map((e) => e.toMap()).toList(),
    'scheduleForm': scheduleForm,
    'benficiaryEndpoint': benficiaryEndpoint,
    'comment': comment,
    'icon': icon,
    'fblLogo': fblLogo,
    'receiptDateTime': receiptDateTime,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RequestResponse].
  factory RequestResponse.fromJson(String data) {
    return RequestResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RequestResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  RequestResponse copyWith({
    String? receiptId,
    String? reference,
    String? amount,
    int? status,
    String? statusLabel,
    String? formName,
    String? customerName,
    String? activityName,
    String? dateCreated,
    String? receiptDate,
    int? showReceipt,
    int? saveBenficiary,
    int? allowSchedule,
    List<PreviewDatum>? previewData,
    dynamic scheduleForm,
    String? benficiaryEndpoint,
    String? comment,
    String? icon,
    String? fblLogo,
    String? receiptDateTime,
  }) {
    return RequestResponse(
      receiptId: receiptId ?? this.receiptId,
      reference: reference ?? this.reference,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      formName: formName ?? this.formName,
      customerName: customerName ?? this.customerName,
      activityName: activityName ?? this.activityName,
      dateCreated: dateCreated ?? this.dateCreated,
      receiptDate: receiptDate ?? this.receiptDate,
      showReceipt: showReceipt ?? this.showReceipt,
      saveBenficiary: saveBenficiary ?? this.saveBenficiary,
      allowSchedule: allowSchedule ?? this.allowSchedule,
      previewData: previewData ?? this.previewData,
      scheduleForm: scheduleForm ?? this.scheduleForm,
      benficiaryEndpoint: benficiaryEndpoint ?? this.benficiaryEndpoint,
      comment: comment ?? this.comment,
      icon: icon ?? this.icon,
      fblLogo: fblLogo ?? this.fblLogo,
      receiptDateTime: receiptDateTime ?? this.receiptDateTime,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      receiptId,
      reference,
      amount,
      status,
      statusLabel,
      formName,
      activityName,
      dateCreated,
      receiptDate,
      showReceipt,
      saveBenficiary,
      allowSchedule,
      previewData,
      scheduleForm,
      benficiaryEndpoint,
      comment,
      icon,
      fblLogo,
      receiptDateTime,
    ];
  }
}
