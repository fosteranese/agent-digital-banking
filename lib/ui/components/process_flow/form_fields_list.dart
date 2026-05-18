import 'package:flutter/material.dart';

import 'package:my_sage_agent/data/models/process_flow/process_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/process_flow/process_flow_form_data.dart';
import 'package:my_sage_agent/ui/components/form/multiple_input_plus.dart';

class FormFieldsList extends StatefulWidget {
  const FormFieldsList({super.key, required this.formData, required this.controllers});

  final ProcessFlowFormData formData;
  final Map<String, (TextEditingController, ProcessFlowFieldsDatum)> controllers;

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

  Widget _buildControl(MapEntry<String, (TextEditingController, ProcessFlowFieldsDatum)> e) {
    return FormMultipleInputPlus(controllers: widget.controllers, controller: e.value);
  }
}
