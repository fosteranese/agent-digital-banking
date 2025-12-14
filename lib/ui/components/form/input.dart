import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base_input.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    this.label = '',
    this.labelStyle,
    this.bottomSpace = 10,
    this.prefix,
    this.suffix,
    this.controller,
    this.placeholder,
    this.inputFormatters,
    this.validation,
    this.showIconOnSuccessfulValidation = false,
    this.showIconOnFailedValidation = false,
    this.keyboardType,
    this.textInputAction,
    this.onSuccess,
    this.info,
    this.inputHeight = 64,
    this.onChange,
    this.focus,
    this.zeroLeftPadding = false,
    this.borderRadius = 4,
    this.color = Colors.white,
    this.multiLine = false,
    this.contentPadding,
    this.placeholderStyle,
    this.textAlign,
    this.textStyle,
    this.decoration,
    this.maxLength,
    this.prefixIconPadding,
    this.readOnly = false,
    this.onFocus,
    this.onUnfocus,
    this.showNumberToolbar = true,
    this.hideOnTapOutside = true,
    this.tooltip,
    this.maxLines,
    this.minLines,
  });

  final String label;
  final TextStyle? labelStyle;
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
  final TextInputAction? textInputAction;
  final void Function(String)? onSuccess;
  final Widget? info;
  final double? inputHeight;
  final void Function(String value)? onChange;
  final FocusNode? focus;
  final bool zeroLeftPadding;
  final double borderRadius;
  final Color color;
  final bool multiLine;
  final EdgeInsets? contentPadding;
  final TextStyle? placeholderStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final int? maxLength;
  final EdgeInsets? prefixIconPadding;
  final bool readOnly;
  final void Function(EdgeInsets)? onFocus;
  final void Function()? onUnfocus;
  final bool showNumberToolbar;
  final bool hideOnTapOutside;
  final String? tooltip;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final currentColor = readOnly ? Colors.blueGrey.shade100 : color;
    return BaseFormInput(
      bottomSpace: bottomSpace,
      controller: controller,
      inputFormatters: inputFormatters,
      key: key,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      label: label,
      labelStyle: labelStyle,
      onSuccess: onSuccess,
      placeholder: placeholder,
      placeholderStyle: placeholderStyle,
      prefix: prefix,
      showIconOnFailedValidation: showIconOnFailedValidation,
      showIconOnSuccessfulValidation: showIconOnFailedValidation,
      suffix: suffix,
      validation: validation,
      info: info,
      tooltip: tooltip,
      inputHeight: inputHeight,
      onChange: onChange,
      focus: focus,
      zeroLeftPadding: zeroLeftPadding,
      borderRadius: borderRadius,
      color: currentColor,
      multiLine: multiLine,
      contentPadding: contentPadding,
      textAlign: textAlign,
      textStyle: textStyle,
      decoration: decoration,
      maxLength: maxLength,
      prefixIconPadding: prefixIconPadding,
      readOnly: readOnly,
      showReadOnlyColor: readOnly,
      onFocus: onFocus,
      onUnfocus: onUnfocus,
      showNumberToolbar: showNumberToolbar,
      hideOnTapOutside: hideOnTapOutside,
    );
  }
}
