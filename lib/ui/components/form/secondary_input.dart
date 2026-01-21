import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base_input.dart';

class MySecondaryInput extends StatelessWidget {
  const MySecondaryInput({
    super.key,
    this.label = '',
    this.bottomSpace = 20,
    this.prefix,
    this.suffix,
    this.controller,
    this.placeholder,
    this.inputFormatters,
    this.validation,
    this.showIconOnSuccessfulValidation = false,
    this.showIconOnFailedValidation = false,
    this.keyboardType,
    this.onSuccess,
    this.info,
    this.readOnly = false,
  });

  final String label;
  final double bottomSpace;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final String? placeholder;
  final List<TextInputFormatter>? inputFormatters;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final TextInputType? keyboardType;
  final void Function(String)? onSuccess;
  final Widget? info;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return BaseFormInput(
      bottomSpace: bottomSpace,
      controller: controller,
      inputFormatters: inputFormatters,
      key: key,
      keyboardType: keyboardType,
      label: label,
      onSuccess: onSuccess,
      placeholder: placeholder,
      decoration: const InputDecoration(
        fillColor: Color(0xffEEEEEE),
        filled: true,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE6E6E6))),
      ),
      prefix: prefix,
      showIconOnFailedValidation: showIconOnFailedValidation,
      showIconOnSuccessfulValidation: showIconOnFailedValidation,
      suffix: suffix,
      validation: validation,
      info: info,
      readOnly: readOnly,
    );
  }
}
