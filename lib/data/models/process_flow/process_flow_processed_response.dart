import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'preview_datum.dart';

class ProcessFlowProcessedModel extends Equatable {
  final String? receiptId;
  final String? reference;
  final String? amount;
  final int? status;
  final String? statusLabel;
  final String? formName;
  final String? activityName;
  final String? dateCreated;
  final String? receiptDate;
  final int? showReceipt;
  final int? saveBenficiary;
  final int? allowSchedule;
  final List<PreviewDatum>? previewData;
  final dynamic scheduleForm;
  final String? benficiaryEndpoint;

  const ProcessFlowProcessedModel({
    this.receiptId,
    this.reference,
    this.amount,
    this.status,
    this.statusLabel,
    this.formName,
    this.activityName,
    this.dateCreated,
    this.receiptDate,
    this.showReceipt,
    this.saveBenficiary,
    this.allowSchedule,
    this.previewData,
    this.scheduleForm,
    this.benficiaryEndpoint,
  });

  factory ProcessFlowProcessedModel.fromMap(Map<String, dynamic> data) {
    return ProcessFlowProcessedModel(
      receiptId: data['receiptId'] as String?,
      reference: data['reference'] as String?,
      amount: data['amount'] as String?,
      status: data['status'] as int?,
      statusLabel: data['statusLabel'] as String?,
      formName: data['formName'] as String?,
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
    );
  }

  Map<String, dynamic> toMap() => {
    'receiptId': receiptId,
    'reference': reference,
    'amount': amount,
    'status': status,
    'statusLabel': statusLabel,
    'formName': formName,
    'activityName': activityName,
    'dateCreated': dateCreated,
    'receiptDate': receiptDate,
    'showReceipt': showReceipt,
    'saveBenficiary': saveBenficiary,
    'allowSchedule': allowSchedule,
    'previewData': previewData?.map((e) => e.toMap()).toList(),
    'scheduleForm': scheduleForm,
    'benficiaryEndpoint': benficiaryEndpoint,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProcessFlowProcessedModel].
  factory ProcessFlowProcessedModel.fromJson(String data) {
    return ProcessFlowProcessedModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProcessFlowProcessedModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ProcessFlowProcessedModel copyWith({
    String? receiptId,
    String? reference,
    String? amount,
    int? status,
    String? statusLabel,
    String? formName,
    String? activityName,
    String? dateCreated,
    String? receiptDate,
    int? showReceipt,
    int? saveBenficiary,
    int? allowSchedule,
    List<PreviewDatum>? previewData,
    dynamic scheduleForm,
    String? benficiaryEndpoint,
  }) {
    return ProcessFlowProcessedModel(
      receiptId: receiptId ?? this.receiptId,
      reference: reference ?? this.reference,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      formName: formName ?? this.formName,
      activityName: activityName ?? this.activityName,
      dateCreated: dateCreated ?? this.dateCreated,
      receiptDate: receiptDate ?? this.receiptDate,
      showReceipt: showReceipt ?? this.showReceipt,
      saveBenficiary: saveBenficiary ?? this.saveBenficiary,
      allowSchedule: allowSchedule ?? this.allowSchedule,
      previewData: previewData ?? this.previewData,
      scheduleForm: scheduleForm ?? this.scheduleForm,
      benficiaryEndpoint: benficiaryEndpoint ?? this.benficiaryEndpoint,
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
    ];
  }
}
