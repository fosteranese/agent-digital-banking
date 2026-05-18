import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'category.dart';
import 'process_flow_form.dart';

class ProcessFlowCategory extends Equatable {
  final Category? category;
  final List<ProcessFlowFormModel>? forms;

  const ProcessFlowCategory({this.category, this.forms});

  factory ProcessFlowCategory.fromMap(Map<String, dynamic> data) {
    return ProcessFlowCategory(
      category: data['category'] == null
          ? null
          : Category.fromMap(data['category'] as Map<String, dynamic>),
      forms: (data['forms'] as List<dynamic>?)
          ?.map((e) => ProcessFlowFormModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'category': category?.toMap(),
    'forms': forms?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProcessFlowCategory].
  factory ProcessFlowCategory.fromJson(String data) {
    return ProcessFlowCategory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProcessFlowCategory] to a JSON string.
  String toJson() => json.encode(toMap());

  ProcessFlowCategory copyWith({Category? category, List<ProcessFlowFormModel>? forms}) {
    return ProcessFlowCategory(category: category ?? this.category, forms: forms ?? this.forms);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [category, forms];
}
