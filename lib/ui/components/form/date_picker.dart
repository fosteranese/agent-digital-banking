import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

import 'base_input.dart';

class FormDatePicker extends StatefulWidget {
  const FormDatePicker({super.key, this.label = '', this.bottomSpace = 20, this.prefix, this.controller, this.placeholder, this.validation, this.showIconOnSuccessfulValidation = false, this.showIconOnFailedValidation = false, this.keyboardType, this.onSuccess, this.info, this.onDateSelected, this.useLongList = false, this.useTextAsSelectedDisplayItem = false, this.onTap, this.showDatePicker = false, this.color = Colors.transparent, this.contentPadding, this.placeholderStyle, this.textAlign, this.textStyle, this.decoration, this.maxLength, this.prefixIconPadding, this.inputHeight, this.readOnly = false, this.currentDate, this.tooltip, this.minDate, this.maxDate});

  final String label;
  final double bottomSpace;
  final Widget? prefix;
  final TextEditingController? controller;
  final String? placeholder;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final TextInputType? keyboardType;
  final void Function(String)? onSuccess;
  final Widget? info;
  final void Function(DateTime? date)? onDateSelected;
  final bool useLongList;
  final bool useTextAsSelectedDisplayItem;
  final bool Function()? onTap;
  final bool showDatePicker;
  final Color color;
  final EdgeInsets? contentPadding;
  final TextStyle? placeholderStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final int? maxLength;
  final EdgeInsets? prefixIconPadding;
  final double? inputHeight;
  final bool readOnly;
  final DateTime? currentDate;
  final String? tooltip;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  DateTime? _selectedDate;
  @override
  void initState() {
    if (widget.currentDate != null) {
      _selectedDate = widget.currentDate ?? DateTime.now();
      _onSelected(_selectedDate);
    }
    if (widget.showDatePicker) {
      Future.delayed(const Duration(seconds: 0), () {
        _openDatePicker();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormInput(
      focus: FocusNode(),
      onTap: widget.readOnly
          ? null
          : () {
              if (widget.onTap != null && !widget.onTap!()) {
                return;
              }

              _openDatePicker();
            },
      tooltip: widget.tooltip,
      inputHeight: 64,
      bottomSpace: widget.bottomSpace,
      controller: widget.controller,
      key: widget.key,
      readOnly: true,
      keyboardType: widget.keyboardType,
      label: widget.label,
      onSuccess: widget.onSuccess,
      placeholder: widget.placeholder,
      prefix: widget.prefix,
      showIconOnFailedValidation: widget.showIconOnFailedValidation,
      showIconOnSuccessfulValidation: widget.showIconOnFailedValidation,
      validation: widget.validation,
      info: widget.info,
      color: widget.color,
      contentPadding: widget.contentPadding,
      textAlign: widget.textAlign,
      textStyle: widget.textStyle,
      decoration: widget.decoration,
      maxLength: widget.maxLength,
      prefixIconPadding: widget.prefixIconPadding,
      suffix: IconButton(
        icon: Icon(Icons.calendar_today, color: ThemeUtil.secondaryColor),
        onPressed: () {
          _openDatePicker();
        },
      ),
    );
  }

  void _onSelected(DateTime? date) {
    setState(() {
      _selectedDate = date;
      final d = DateFormat('dd MMM yyyy');
      widget.controller?.text = date != null ? d.format(date) : '';
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(date);
      }
    });
  }

  Future<void> _openDatePicker() async {
    final previousDate = _selectedDate ?? DateTime.now();
    final date = await showDatePicker(context: context, initialDate: _initialDate(previousDate), firstDate: widget.minDate ?? DateTime(1900), lastDate: widget.maxDate ?? DateTime(3000), currentDate: previousDate);

    if (date != null) {
      _onSelected(date);
    }
  }

  DateTime? _initialDate(DateTime? previousDate) {
    if (widget.minDate == null || previousDate == null) {
      return previousDate;
    }

    if (widget.minDate!.isAfter(previousDate)) {
      return widget.minDate;
    }

    return previousDate;
  }
}
