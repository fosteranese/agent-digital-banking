import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:agent_digital_banking/blocs/activity/activity_bloc.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class BaseFormInput extends StatefulWidget {
  const BaseFormInput({super.key, this.label = '', this.labelStyle, this.bottomSpace = 10, this.prefix, this.suffix, this.suffixIconConstraints, this.controller, this.placeholder, this.inputFormatters, this.validation, this.showIconOnSuccessfulValidation = false, this.showIconOnFailedValidation = false, this.keyboardType, this.textInputAction, this.onSuccess, this.decoration, this.info, this.readOnly = false, this.onTap, this.inputHeight = 64, this.focus, this.onChange, this.zeroLeftPadding = false, this.borderRadius = 10, this.color = Colors.white, this.multiLine = false, this.contentPadding, this.obscureText = false, this.placeholderStyle, this.textAlign, this.textStyle, this.maxLength, this.prefixIconPadding, this.focusedColor, this.showReadOnlyColor = false, this.onFocus, this.onUnfocus, this.showNumberToolbar = true, this.hideOnTapOutside = true, this.tooltip, this.onDoneUnfocus = true, this.maxLines, this.minLines, this.visibilityBorderColor});

  final String label;
  final TextStyle? labelStyle;
  final double bottomSpace;
  final Widget? prefix;
  final Widget? suffix;
  final BoxConstraints? suffixIconConstraints;
  final TextEditingController? controller;
  final String? placeholder;
  final List<TextInputFormatter>? inputFormatters;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onSuccess;
  final InputDecoration? decoration;
  final Widget? info;
  final bool readOnly;
  final void Function()? onTap;
  final double? inputHeight;
  final FocusNode? focus;
  final void Function(String value)? onChange;
  final bool zeroLeftPadding;
  final double borderRadius;
  final Color color;
  final bool multiLine;
  final EdgeInsets? contentPadding;
  final bool obscureText;
  final TextStyle? placeholderStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final int? maxLength;
  final EdgeInsets? prefixIconPadding;
  final Color? focusedColor;
  final bool showReadOnlyColor;
  final void Function(EdgeInsets edgeInset)? onFocus;
  final void Function()? onUnfocus;
  final bool showNumberToolbar;
  final bool hideOnTapOutside;
  final String? tooltip;
  final bool onDoneUnfocus;
  final int? maxLines;
  final int? minLines;
  final Color? visibilityBorderColor;

  @override
  State<BaseFormInput> createState() => _BaseFormInputState();
}

class _BaseFormInputState extends State<BaseFormInput> {
  bool? _isValid;
  late final FocusNode _focus;
  // late Color _color = widget.color;
  final _tooltipController = ElTooltipController();
  var _contentPadding = const EdgeInsets.symmetric(vertical: 20, horizontal: 20);

  final _isFocused = ValueNotifier(false);
  late Color _color = widget.color;

  @override
  void initState() {
    _focus = widget.focus ?? FocusNode();
    _focus.addListener(() {
      _isFocused.value = _focus.hasFocus;
      setState(() {
        if (_focus.hasFocus) {
          if (widget.onFocus != null) {
            widget.onFocus!(_scrollPadding);
          }
          if (!widget.showReadOnlyColor) {
            _color = widget.focusedColor ?? widget.color;
          }
        } else {
          _color = widget.color;
          if (widget.onUnfocus != null) {
            widget.onUnfocus!();
          }
        }
      });
    });

    if (widget.contentPadding != null) {
      _contentPadding = widget.contentPadding!;
      if (widget.multiLine) {
        _contentPadding = _contentPadding.copyWith(top: 20, bottom: 20);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isFocused,
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label.isNotEmpty && (widget.info != null || widget.tooltip != null))
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [const Spacer(), widget.tooltip != null ? _info! : widget.info!]),
              ),
            Container(
              height: widget.multiLine ? 150 : widget.inputHeight,
              margin: EdgeInsets.only(bottom: widget.bottomSpace),
              decoration: BoxDecoration(
                color: _color,
                border: _isFocused.value ? Border.all(color: (widget.visibilityBorderColor ?? Theme.of(context).primaryColor), width: 1.5) : Border.all(color: (widget.visibilityBorderColor ?? Color(0xffD9DADB))),
                borderRadius: _isFocused.value ? BorderRadius.circular(widget.borderRadius) : BorderRadius.circular(widget.borderRadius),
              ),
              child: Stack(
                children: [
                  if (value || (widget.controller?.text.isNotEmpty ?? false))
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: widget.labelStyle ?? PrimaryTextStyle(color: const Color(0xff919195), fontWeight: FontWeight.w400, fontSize: 13, backgroundColor: Colors.transparent),
                        ),
                      ),
                    ),
                  if (!value && ((widget.placeholder?.isNotEmpty ?? false) || widget.label.isNotEmpty) && (widget.controller?.text.isEmpty ?? false)) _placeholder,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.prefix != null) Padding(padding: _prefixPadding!, child: widget.prefix!),
                      Expanded(child: _fullInputControl),
                      if (_suffixIcon != null) Align(alignment: Alignment.centerRight, child: _suffixIcon!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get _placeholder {
    var text = widget.placeholder ?? '';
    if (text.isEmpty) {
      text = widget.label;
    }

    return Align(
      alignment: widget.multiLine ? Alignment.topLeft : Alignment.centerLeft,
      child: Padding(
        padding: _contentPadding.copyWith(left: widget.prefix == null ? _contentPadding.left : widget.prefixIconPadding?.left ?? (widget.prefixIconPadding?.left ?? 70), top: widget.prefixIconPadding?.top ?? _contentPadding.top, bottom: widget.prefixIconPadding?.bottom ?? _contentPadding.bottom),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.placeholderStyle ?? PrimaryTextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16, backgroundColor: Colors.transparent),
        ),
      ),
    );
  }

  Widget get _fullInputControl {
    if (widget.showNumberToolbar && (widget.keyboardType != null && (widget.keyboardType!.index == 2 || widget.keyboardType!.index == 3))) {
      return KeyboardActions(autoScroll: false, overscroll: 0, disableScroll: true, enable: true, config: _buildConfig(context), child: _input);
    }

    return _input;
  }

  Widget? get _info {
    return ElTooltip(
      controller: _tooltipController,
      content: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.tooltip ?? '', style: PrimaryTextStyle(color: Colors.white)),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  _tooltipController.hide();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'Okay',
                    style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: const Icon(Icons.info_outline, color: Colors.blueGrey),
    );
  }

  EdgeInsets get _scrollPadding {
    return widget.keyboardType != null && (widget.keyboardType!.index == 2 || widget.keyboardType!.index == 3) ? const EdgeInsets.only(bottom: 40.0) : const EdgeInsets.all(0.0);
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  if (widget.focus == null) {
                    _focus.unfocus(disposition: UnfocusDisposition.scope);
                  }
                  _onValidate();
                },
                child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Done')),
              );
            },
          ],
        ),
      ],
    );
  }

  Widget? get _suffixIcon {
    if (widget.suffix != null && (widget.showIconOnSuccessfulValidation != true || _isValid == null)) {
      return widget.suffix;
    }

    if (widget.showIconOnSuccessfulValidation && _isValid == true) {
      return Container(
        padding: widget.zeroLeftPadding ? const EdgeInsets.symmetric(horizontal: 15) : const EdgeInsets.only(right: 15),
        child: const Icon(Icons.check_circle, color: Color(0xff039612)),
      );
    }

    if (widget.showIconOnFailedValidation && _isValid == false) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: const Icon(Icons.check_circle, color: Color(0xff039612)),
      );
    }

    return null;
  }

  void _onValidate() {
    if (widget.validation != null) {
      _isValid = widget.validation!();
      if (_isValid == true && widget.onSuccess != null) {
        widget.onSuccess!(widget.controller!.text);
      }
    } else if (widget.onSuccess != null) {
      widget.onSuccess!(widget.controller!.text);
    }
    setState(() {});
  }

  Widget get _input {
    return Padding(
      padding: EdgeInsets.only(top: widget.multiLine ? 10 : 0),
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: TextField(
          cursorHeight: 16,
          expands: widget.multiLine,
          onTapOutside: (p) {
            if (widget.hideOnTapOutside) {
              _focus.unfocus();
            }
          },
          textAlignVertical: widget.multiLine ? TextAlignVertical.top : TextAlignVertical.center,

          // maxLength: widget.maxLength,
          obscureText: widget.obscureText,

          obscuringCharacter: "*",
          focusNode: _focus,
          onTap: widget.onTap,
          controller: widget.controller,
          readOnly: widget.readOnly,
          style: widget.textStyle ?? PrimaryTextStyle(fontSize: 16, color: Color(0xff242424), fontWeight: FontWeight.w600),

          textAlign: widget.textAlign ?? TextAlign.left,
          decoration: InputDecoration(
            // fillColor: Colors.pink,
            // filled: true,
            border: InputBorder.none,
            contentPadding: ((widget.inputHeight ?? 0) > 40 ? _inputPadding : EdgeInsets.only(top: 0, bottom: 10, left: widget.zeroLeftPadding ? (_inputPadding?.left ?? 0) : 0)),
            isDense: false,
          ),
          keyboardType: widget.multiLine ? TextInputType.multiline : widget.keyboardType,
          maxLines: !widget.multiLine ? 1 : null /*widget.maxLines*/,
          minLines: !widget.multiLine ? null : widget.minLines,
          textInputAction: widget.multiLine ? TextInputAction.newline : widget.textInputAction ?? TextInputAction.done,
          inputFormatters: widget.maxLength == null || widget.maxLength! < 1 ? widget.inputFormatters : [...widget.inputFormatters ?? [], LengthLimitingTextInputFormatter(widget.maxLength)],
          onChanged: (value) {
            context.read<ActivityBloc>().add(PerformActivityEvent());

            if (widget.onChange != null) {
              widget.onChange!(value);
            }

            if (widget.validation == null) {
              setState(() {
                _isValid = null;
              });
              return;
            }
            _onValidate();
          },
          onEditingComplete: () {
            context.read<ActivityBloc>().add(PerformActivityEvent());

            _onValidate();
          },
          onSubmitted: (value) {
            context.read<ActivityBloc>().add(PerformActivityEvent());

            if (widget.focus == null) {
              // _focus.unfocus(disposition: UnfocusDisposition.scope);
              _focus.unfocus();
            } else if (widget.focus != null && widget.onDoneUnfocus) {
              widget.focus!.unfocus();
            }
          },
        ),
      ),
    );
  }

  EdgeInsets? get _inputPadding {
    if (widget.label.isEmpty) {
      return EdgeInsets.only(left: 10, right: 10);
    }

    if (!_isFocused.value && (widget.controller?.text.isEmpty ?? false)) {
      return widget.contentPadding;
    }

    return EdgeInsets.only(top: widget.obscureText ? 30 : 15, left: 10, right: 10);
  }

  EdgeInsets? get _prefixPadding {
    if (widget.label.isEmpty) {
      return EdgeInsets.only(left: 10, right: 10);
    }

    if (!_isFocused.value && (widget.controller?.text.isEmpty ?? false)) {
      return _contentPadding.copyWith(left: 0, right: 0);
    }

    return EdgeInsets.only(
      top: widget.obscureText ? 30 : 15,
      // left: 10,
      // right: 10,
    );
  }
}
