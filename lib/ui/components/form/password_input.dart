import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../password_strength_checker.dart';
import '../pin_info.dart';
import 'base_input.dart';

class FormPasswordInput extends StatefulWidget {
  const FormPasswordInput({
    super.key,
    this.label = '',
    this.labelStyle,
    this.bottomSpace = 20,
    this.prefix,
    this.suffix,
    this.controller,
    this.placeholder,
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
    this.contentPadding,
    this.decoration,
    this.textStyle,
    this.visibilityColor,
    this.visibilityFocusedColor,
    this.visibilityBorderColor,
    this.focusedColor,
    this.inputFormatters,
    this.readOnly = false,
    this.tooltip,
    this.showNumberToolbar = true,
    this.placeholderStyle,
    this.maxLength,
    this.isNew = false,
    this.isPin = false,
  });

  final String label;
  final TextStyle? labelStyle;
  final double bottomSpace;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final String? placeholder;
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
  final EdgeInsets? contentPadding;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final Color? visibilityColor;
  final Color? visibilityFocusedColor;
  final Color? visibilityBorderColor;
  final Color? focusedColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final String? tooltip;
  final bool showNumberToolbar;
  final TextStyle? placeholderStyle;
  final int? maxLength;
  final bool isNew;
  final bool isPin;

  @override
  State<FormPasswordInput> createState() => _FormPasswordInputState();
}

class _FormPasswordInputState extends State<FormPasswordInput> {
  bool _hidePassword = true;
  late final FocusNode _focus;
  late Color? _iconColor = widget.visibilityColor;

  @override
  void initState() {
    _focus = widget.focus ?? FocusNode();
    _focus.addListener(() {
      setState(() {
        if (_focus.hasFocus) {
          _iconColor = widget.visibilityFocusedColor;
        } else {
          _iconColor = widget.visibilityColor;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = IconButton(
      onPressed: _togglePasswordVisibility,
      icon: SvgPicture.asset(
        _hidePassword ? 'assets/img/show-outline.svg' : 'assets/img/hide.svg',
        width: 20,
        colorFilter: _iconColor != null ? ColorFilter.mode(_iconColor!, BlendMode.srcIn) : null,
      ),
    );
    return Column(
      children: [
        BaseFormInput(
          maxLength: widget.maxLength,
          textStyle: widget.textStyle,
          bottomSpace: 10,
          controller: widget.controller,
          key: widget.key,
          keyboardType: widget.isPin
              ? TextInputType.numberWithOptions(decimal: false, signed: false)
              : widget.keyboardType,
          textInputAction: widget.textInputAction,
          label: widget.label,
          labelStyle: widget.labelStyle,
          onSuccess: widget.onSuccess,
          placeholder: widget.placeholder,
          prefix: widget.prefix,
          showIconOnFailedValidation: widget.showIconOnFailedValidation,
          showIconOnSuccessfulValidation: widget.showIconOnFailedValidation,
          suffix: widget.suffix != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [passwordVisibility, widget.suffix!],
                )
              : passwordVisibility,
          validation: widget.validation,
          inputHeight: widget.inputHeight,
          onChange: widget.onChange,
          focus: _focus,
          zeroLeftPadding: widget.zeroLeftPadding,
          borderRadius: widget.borderRadius,
          color: widget.color,
          multiLine: false,
          contentPadding: widget.contentPadding,
          obscureText: _hidePassword,
          decoration: widget.decoration,
          focusedColor: widget.focusedColor,
          inputFormatters: widget.isPin
              ? [...widget.inputFormatters ?? [], FilteringTextInputFormatter.digitsOnly]
              : widget.inputFormatters,
          readOnly: widget.readOnly,
          tooltip: widget.isNew ? null : widget.tooltip,
          showNumberToolbar: widget.isPin ? true : widget.showNumberToolbar,
          placeholderStyle: widget.placeholderStyle,
          info: widget.info,
        ),
        if (widget.isNew && !widget.isPin)
          PasswordStrengthChecker(
            controller: widget.controller!,
            validFunc: (status) {
              // _passwordStatus = status;
            },
          ),
        if (widget.isNew && widget.isPin && (widget.tooltip?.isNotEmpty ?? false))
          PinInfo(info: widget.tooltip!),
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }
}
