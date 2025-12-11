import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:agent_digital_banking/blocs/payee/payee_bloc.dart';
import 'package:agent_digital_banking/constants/field.const.dart';
import 'package:agent_digital_banking/data/models/collection/fields_datum.dart';
import 'package:agent_digital_banking/data/models/collection/lov.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:agent_digital_banking/data/models/payee/payees_response.dart';
import 'package:agent_digital_banking/logger.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/ui/components/form/amount_input.dart';
import 'package:agent_digital_banking/ui/components/form/bank_account_input_plus.dart';
import 'package:agent_digital_banking/ui/components/form/date_picker.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/components/form/password_input.dart';
import 'package:agent_digital_banking/ui/components/form/payee_input.dart';
import 'package:agent_digital_banking/ui/components/form/phone_number_picker.dart';
import 'package:agent_digital_banking/ui/components/form/select.dart';
import 'package:agent_digital_banking/ui/formatters/decimal.formatter.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class FormMultipleInputPlus extends StatefulWidget {
  const FormMultipleInputPlus({super.key, required this.controllers, required this.controller, this.fieldData, this.onPayeeSelectedOption, this.isFirst = false});

  static const autoFill = '[++auto-fill++]';
  final bool isFirst;
  final Map<String, (TextEditingController, GeneralFlowFieldsDatum)> controllers;
  final (TextEditingController, GeneralFlowFieldsDatum) controller;
  final dynamic fieldData;
  final void Function(Payees)? onPayeeSelectedOption;

  static String? validate({required GeneralFlowFieldsDatum generalFieldDatum, required String value}) {
    final label = (generalFieldDatum.field?.fieldCaption);

    if (generalFieldDatum.field!.readOnly == 1) {
      return null;
    }

    // check if it's required
    final isRequired = (generalFieldDatum.field?.fieldMandatory) == 1;
    if (isRequired && value.isEmpty) {
      logger.i("$label => ${generalFieldDatum.field?.fieldType}");
      logger.i("$label => ${generalFieldDatum.field?.fieldDataType}");

      return '$label is required';
    }

    final dataType = (generalFieldDatum.field?.fieldDataType);
    switch (dataType) {
      case FieldDataTypesConst.decimal:
      case FieldDataTypesConst.number:
        if (double.tryParse(value) == null) {
          return 'Invalid $label entered';
        }
        break;
    }

    return null;
  }

  static String sanitize(String dateFormat, String value) {
    var d = DateFormat('dd MMM yyyy');
    final date = d.parse(value);
    d = DateFormat(dateFormat.toLowerCase().replaceAll('m', 'M'));
    return d.format(date);
  }

  static Map<String, dynamic>? getFormData({required Map<String, (TextEditingController, GeneralFlowFieldsDatum)> controllers, List<FieldsDatum>? fieldDatum, List<GeneralFlowFieldsDatum>? preGeneralFieldDatum, Map<String, dynamic>? formData}) {
    Map<String, dynamic> payload = {};

    preGeneralFieldDatum?.forEach((e) {
      payload[e.field?.fieldName ?? ''] = formData?[e.field?.fieldName ?? ''] ?? e.field?.defaultValue;
    });

    int index = 0;
    for (var controller in controllers.entries) {
      var value = controller.value.$1.text;
      logger.i('index: ${controllers.length}');
      final formData = fieldDatum?[index];
      if ((formData?.field?.fieldDateFormat?.isNotEmpty ?? false) && formData?.field?.fieldDataType == FieldDataTypesConst.date) {
        value = sanitize((formData?.field?.fieldDateFormat ?? ''), value);
      }

      final generalFormData = controller.value.$2;
      final dataType = generalFormData.field!.fieldDataType;
      if (generalFormData.field?.fieldDateFormat?.isNotEmpty ?? false) {
        if (dataType == FieldDataTypesConst.date) {
          value = sanitize((generalFormData.field?.fieldDateFormat ?? ''), value);
        }
      }

      switch (dataType) {
        case FieldDataTypesConst.decimal:
        case FieldDataTypesConst.number:
          value = value.replaceAll('GHS', '').replaceAll(',', '').replaceAll(' ', '').replaceAll('\u00A0', '').trim();
          break;
      }

      final error = FormMultipleInputPlus.validate(generalFieldDatum: generalFormData, value: value);
      if (error?.isNotEmpty ?? false) {
        MessageUtil.displayErrorDialog(MyApp.navigatorKey.currentContext!, message: error ?? '');
        return null;
      }

      payload[formData?.field?.fieldName ?? generalFormData.field?.fieldName ?? ''] = value;
      ++index;
    }

    Map<String, dynamic> finalPayload = {};
    if (formData != null) {
      finalPayload = {...formData, ...payload};
    } else {
      finalPayload = payload;
    }

    return finalPayload;
  }

  @override
  State<FormMultipleInputPlus> createState() => _FormMultipleInputPlusState();
}

class _FormMultipleInputPlusState extends State<FormMultipleInputPlus> {
  FormSelectOption? selectedOption;

  @override
  Widget build(BuildContext context) {
    if (widget.controller.$2.field?.fieldVisible != 1) {
      return const SizedBox();
    }

    final defaultValue = widget.controller.$1.text;
    // final defaultValue = _getValue;
    // widget.controller.$1.text = defaultValue.isNotEmpty
    //     ? defaultValue
    //     : widget.controller.$1.text;
    switch (widget.controller.$2.field?.fieldType) {
      case FieldTypesConst.textBox:
      case FieldTypesConst.date:
      case FieldTypesConst.other:
        if (widget.fieldData != null) {
          widget.controller.$1.text = widget.fieldData as String;
        }

        switch (widget.controller.$2.field?.fieldDataType) {
          case FieldDataTypesConst.string:
            return FormInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
            );
          case FieldDataTypesConst.date:
            return FormDatePicker(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
            );
          case FieldDataTypesConst.dateAfterCurrent:
            return FormDatePicker(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              minDate: DateTime.now().add(Duration(days: 1)),
            );
          case FieldDataTypesConst.dateToCurrent:
            return FormDatePicker(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxDate: DateTime.now(),
            );
          case FieldDataTypesConst.decimal:
            if (widget.isFirst && widget.controller.$2.field!.isAmount == 1) {
              return AmountInput(controller: widget.controller);
            }

            return FormInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
            );
          case FieldDataTypesConst.link:
            return FormInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
            );
          case FieldDataTypesConst.number:
            if (widget.isFirst && widget.controller.$2.field!.isAmount == 1) {
              return AmountInput(controller: widget.controller);
            }

            return FormInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                // signed: false,
              ),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
            );
          case FieldDataTypesConst.password:
            return FormPasswordInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
              isNew: false,
            );
          case FieldDataTypesConst.newPassword:
            return FormPasswordInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
              isNew: true,
            );
          case FieldDataTypesConst.payee:
            return BlocProvider(
              create: (context) => PayeeBloc(),
              child: FormPayeeInput(
                label: _label,
                controller: widget.controller.$1,
                placeholder: _placeholder,
                readOnly: _readOnly,
                // tooltip: _tooltip,
                formId: widget.controller.$2.field?.formId ?? '',
                title: _label,
              ),
            );
          case FieldDataTypesConst.payeeNumber:
            return BlocProvider(
              create: (context) => PayeeBloc(),
              child: FormPayeeInput(
                label: _label,
                controller: widget.controller.$1,
                placeholder: _placeholder,
                keyboardType: TextInputType.number,
                readOnly: _readOnly,
                // tooltip: _tooltip,
                formId: widget.controller.$2.field?.formId ?? '',
                title: _label,
                onSelectedOption: (option) {
                  if (widget.onPayeeSelectedOption != null) {
                    widget.onPayeeSelectedOption!(option);
                  }
                },
                maxLength: widget.controller.$2.field?.fieldLength,
              ),
            );
          case FieldDataTypesConst.phoneBook:
            return FormPhonePicker(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
              onSelected: (_) {
                setState(() {});
              },
            );
          case FieldDataTypesConst.pin:
            return FormPasswordInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
              isPin: true,
              isNew: false,
            );
          case FieldDataTypesConst.newPin:
            return FormPasswordInput(label: _label, controller: widget.controller.$1, placeholder: _placeholder, readOnly: _readOnly, tooltip: _tooltip, maxLength: widget.controller.$2.field?.fieldLength, isPin: true, isNew: true);
          case FieldDataTypesConst.sourceAccount:
            return FormInput(
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              readOnly: _readOnly,
              // tooltip: _tooltip,
              maxLength: widget.controller.$2.field?.fieldLength,
            );
        }

      case FieldTypesConst.textArea:
        return FormInput(
          label: _label,
          controller: widget.controller.$1,
          placeholder: _placeholder,
          readOnly: _readOnly,
          // tooltip: _tooltip,
          multiLine: true,
          maxLength: widget.controller.$2.field?.fieldLength,
        );

      case FieldTypesConst.listOfValues:
      case FieldTypesConst.multiSelect:
        List<Lov> lov = widget.controller.$2.lov ?? [];

        if (widget.fieldData != null) {
          lov = (widget.fieldData as List<dynamic>).map((e) => Lov.fromMap(e)).toList();
        }

        // widget.controller.$1.text = '';
        if (defaultValue.isNotEmpty && lov.isNotEmpty) {
          selectedOption = lov.where((element) => element.lovValue == defaultValue).map((element) => FormSelectOption(value: element.lovValue ?? '', text: element.lovTitle ?? '')).firstOrNull;
        }

        switch (widget.controller.$2.field?.fieldDataType) {
          case FieldDataTypesConst.sourceAccount:
            if (_label.toLowerCase().contains('cr')) {
              final sourceAccount = widget.controllers.entries.firstWhere((item) => item.value.$2.field!.fieldDataType == FieldDataTypesConst.sourceAccount).value;
              return BankAccountInputPlus(sourceAccount: sourceAccount, formMultipleInput: widget, label: _label, placeholder: _placeholder, selectedOption: selectedOption, lov: lov, readOnly: _readOnly, flowType: 'general');
            }

            return BankAccountInputPlus(formMultipleInput: widget, label: _label, placeholder: _placeholder, selectedOption: selectedOption, lov: lov, readOnly: _readOnly, flowType: 'general');
          case FieldDataTypesConst.destinationAccount:
            final sourceAccount = widget.controllers.entries.firstWhere((item) => item.value.$2.field!.fieldDataType == FieldDataTypesConst.sourceAccount).value;
            return BankAccountInputPlus(sourceAccount: sourceAccount, formMultipleInput: widget, label: _label, placeholder: _placeholder, selectedOption: selectedOption, lov: lov, readOnly: _readOnly, flowType: 'general');
          default:
            return FormSelect(
              title: widget.controller.$2.field?.fieldCaption ?? '',
              label: _label,
              controller: widget.controller.$1,
              placeholder: _placeholder,
              selectedOption: selectedOption,
              onSelectedOption: (option) {
                selectedOption = option;
              },
              options: lov.map((e) => FormSelectOption(value: e.lovValue ?? '', text: e.lovTitle)).toList(),
              readOnly: _readOnly,
              // tooltip: _tooltip,
            );
        }

      case FieldTypesConst.radioButton:
        return const SizedBox();
      case FieldTypesConst.checkBox:
        return const SizedBox();

      default:
        logger.i("$_label => ${widget.controller.$2.field?.fieldType}");
        return const SizedBox();
    }

    return const SizedBox();
  }

  // String get _getValue {
  //   if (widget.controller.$1.text.startsWith(
  //     FormMultipleInputPlus.autoFill,
  //   )) {
  //     widget.controller.$1.text = widget.controller.$1.text
  //         .replaceFirst(FormMultipleInputPlus.autoFill, '');
  //     return widget.controller.$1.text;
  //   }

  //   return widget.controller.$2.field?.defaultValue ?? '';
  // }

  String get _label {
    return '${widget.controller.$2.field?.fieldCaption} ${widget.controller.$2.field?.fieldMandatory == 1 ? '*' : ''}';
  }

  String get _placeholder {
    return widget.controller.$2.field?.toolTip ?? '';
  }

  bool get _readOnly {
    return widget.controller.$2.field?.readOnly == 1;
  }

  String? get _tooltip {
    return widget.controller.$2.field?.toolTip;
  }
}
