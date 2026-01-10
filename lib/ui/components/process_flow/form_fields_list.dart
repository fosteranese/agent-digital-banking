import 'package:flutter/material.dart';

import 'package:my_sage_agent/constants/field.const.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/ui/components/form/multiple_input_plus.dart';

class FormFieldsList extends StatefulWidget {
  const FormFieldsList({super.key, required this.formData, required this.controllers});

  final GeneralFlowFormData formData;
  final Map<String, (TextEditingController, GeneralFlowFieldsDatum)> controllers;

  @override
  State<FormFieldsList> createState() => _FormFieldsListState();
}

class _FormFieldsListState extends State<FormFieldsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: widget.controllers.entries.map((e) {
          return _buildControl(e);
        }).toList(),
      ),
    );
  }

  Widget _buildControl(MapEntry<String, (TextEditingController, GeneralFlowFieldsDatum)> e) {
    return FormMultipleInputPlus(
      controllers: widget.controllers,
      controller: e.value,
      onPayeeSelectedOption: (payee) {
        for (final item in widget.controllers.entries) {
          if (item.value.$2.field?.fieldDataType == FieldDataTypesConst.sourceAccount) {
            continue;
          }

          final fieldName = _toLowerCamel(item.value.$2.field?.fieldName ?? '');
          if (payee.formData?.containsKey(fieldName) ?? false) {
            item.value.$1.text = '${FormMultipleInputPlus.autoFill}${payee.formData![fieldName]}';
          }
        }
        setState(() {});
      },
    );
  }

  String _toLowerCamel(String input) {
    if (input.isEmpty) return input;
    return "${input[0].toLowerCase()}${input.substring(1)}";
  }
}
