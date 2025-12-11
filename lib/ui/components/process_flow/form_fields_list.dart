import 'package:flutter/material.dart';

import 'package:agent_digital_banking/constants/field.const.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form_data.dart';
import 'package:agent_digital_banking/ui/components/form/multiple_input_plus.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: widget.controllers.entries.map((e) {
        final isFirst = e.key == widget.controllers.entries.first.key;
        if (isFirst && e.value.$2.field!.isAmount == 1 && e.value.$2.field!.fieldDataType == FieldDataTypesConst.decimal) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FormMultipleInputPlus(
              isFirst: isFirst,
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
              },
            ),
          );
        }

        return _buildControl(isFirst, e);
      }).toList(),
    );
  }

  Padding _buildControl(bool isFirst, MapEntry<String, (TextEditingController, GeneralFlowFieldsDatum)> e) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: isFirst ? 20 : 0),
      child: FormMultipleInputPlus(
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
      ),
    );
  }

  String _toLowerCamel(String input) {
    if (input.isEmpty) return input;
    return "${input[0].toLowerCase()}${input.substring(1)}";
  }
}
