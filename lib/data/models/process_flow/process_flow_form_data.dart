import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:my_sage_agent/data/models/collection/institution.dart';
import 'package:my_sage_agent/data/models/process_flow/process_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/process_flow/process_flow_form.dart';

class ProcessFlowFormData extends Equatable {
  final ProcessFlowFormModel? form;
  final List<ProcessFlowFieldsDatum>? fieldsDatum;
  final List<Map<String, dynamic>>? authMode;
  final Institution? institution;

  const ProcessFlowFormData({this.form, this.fieldsDatum, this.authMode, this.institution});

  factory ProcessFlowFormData.fromMap(Map<String, dynamic> data) {
    return ProcessFlowFormData(
      form: data['form'] == null
          ? null
          : ProcessFlowFormModel.fromMap(data['form'] as Map<String, dynamic>),
      fieldsDatum: (data['fields'] as List<dynamic>?)
          ?.map((e) => ProcessFlowFieldsDatum.fromMap(e as Map<String, dynamic>))
          .toList(),
      authMode: (data['authMode'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'form': form?.toMap(),
    'fields': fieldsDatum?.map((e) => e.toMap()).toList(),
    'authMode': authMode,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProcessFlowFormData].
  factory ProcessFlowFormData.fromJson(String data) {
    return ProcessFlowFormData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProcessFlowFormData] to a JSON string.
  String toJson() => json.encode(toMap());

  ProcessFlowFormData copyWith({
    ProcessFlowFormModel? form,
    List<ProcessFlowFieldsDatum>? fieldsDatum,
    List<Map<String, dynamic>>? authMode,
  }) {
    return ProcessFlowFormData(
      form: form ?? this.form,
      fieldsDatum: fieldsDatum ?? this.fieldsDatum,
      authMode: authMode ?? this.authMode,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [form, fieldsDatum, authMode];
}
