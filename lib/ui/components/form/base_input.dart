import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:my_sage_agent/blocs/activity/activity_bloc.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class BaseFormInput extends StatefulWidget {
  const BaseFormInput({
    super.key,
    this.label = '',
    this.labelStyle,
    this.bottomSpace = 15,
    this.prefix,
    this.suffix,
    this.suffixIconConstraints,
    this.controller,
    this.placeholder,
    this.inputFormatters,
    this.validation,
    this.showIconOnSuccessfulValidation = false,
    this.showIconOnFailedValidation = false,
    this.keyboardType,
    this.textInputAction,
    this.onSuccess,
    this.decoration,
    this.info,
    this.readOnly = false,
    this.onTap,
    this.inputHeight = 48,
    this.focus,
    this.onChange,
    this.zeroLeftPadding = false,
    this.borderRadius = 4,
    this.color = Colors.white,
    this.multiLine = false,
    this.contentPadding,
    this.obscureText = false,
    this.placeholderStyle,
    this.textAlign,
    this.textStyle,
    this.maxLength,
    this.prefixIconPadding,
    this.focusedColor,
    this.showReadOnlyColor = false,
    this.onFocus,
    this.onUnfocus,
    this.showNumberToolbar = true,
    this.hideOnTapOutside = true,
    this.tooltip,
  });

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
  final EdgeInsetsGeometry? prefixIconPadding;
  final Color? focusedColor;
  final bool showReadOnlyColor;
  final void Function(EdgeInsets edgeInset)? onFocus;
  final void Function()? onUnfocus;
  final bool showNumberToolbar;
  final bool hideOnTapOutside;
  final String? tooltip;

  @override
  State<BaseFormInput> createState() => _BaseFormInputState();
}

class _BaseFormInputState extends State<BaseFormInput> {
  bool? _isValid;
  late final FocusNode _focus;
  late Color _color = widget.color;
  final _tooltipController = JustTheController();

  @override
  void initState() {
    _focus = widget.focus ?? FocusNode();
    _focus.addListener(() {
      setState(() {
        if (_focus.hasFocus) {
          if (widget.onFocus != null) {
            widget.onFocus!(_scrollPadding);
          }
          if (!widget.showReadOnlyColor) {
            _color = widget.focusedColor ?? Colors.white;
          }
        } else {
          _color = widget.color;
          if (widget.onUnfocus != null) {
            widget.onUnfocus!();
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty && (widget.info != null || widget.tooltip != null))
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.label, style: _labelStyle),
                widget.tooltip != null ? _info! : widget.info!,
              ],
            ),
          ),
        if (widget.label.isNotEmpty && widget.tooltip == null && widget.info == null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.label, style: _labelStyle),
          ),
        SizedBox(
          height: widget.multiLine ? 150 : widget.inputHeight ?? 50,
          child:
              widget.showNumberToolbar &&
                  (widget.keyboardType != null &&
                      (widget.keyboardType!.index == 2 || widget.keyboardType!.index == 3))
              ? KeyboardActions(
                  autoScroll: false,
                  overscroll: 0,
                  disableScroll: true,
                  enable: true,
                  config: _buildConfig(context),
                  child: _input,
                )
              : _input,
        ),
        if (widget.bottomSpace > 0) SizedBox(height: widget.bottomSpace),
      ],
    );
  }

  TextStyle get _labelStyle {
    return widget.labelStyle ??
        PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);
  }

  Widget? get _info {
    return JustTheTooltip(
      controller: _tooltipController,
      backgroundColor: Colors.transparent,
      borderRadius: .circular(8),
      barrierDismissible: true,
      curve: Curves.easeIn,
      preferredDirection: .up,
      tailBaseWidth: 0,
      tailLength: 0,
      elevation: 0,
      margin: .only(left: 40),
      content: Container(
        padding: .all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 50,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          widget.tooltip ?? '',
          style: const PrimaryTextStyle(color: ThemeUtil.black, fontSize: 14, fontWeight: .w400),
        ),
      ),
      child: InkWell(
        onTap: () {
          _tooltipController.showTooltip();
        },
        child: const Icon(Icons.info, color: ThemeUtil.flat, size: 16),
      ),
    );
  }

  EdgeInsets get _scrollPadding {
    return widget.keyboardType != null &&
            (widget.keyboardType!.index == 2 || widget.keyboardType!.index == 3)
        ? const EdgeInsets.only(bottom: 40.0)
        : const EdgeInsets.all(0.0);
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
    if (widget.suffix != null &&
        (widget.showIconOnSuccessfulValidation != true || _isValid == null)) {
      return widget.suffix;
    }

    if (widget.showIconOnSuccessfulValidation && _isValid == true) {
      return Padding(
        padding: widget.zeroLeftPadding
            ? const EdgeInsets.symmetric(horizontal: 15)
            : const EdgeInsets.only(right: 15),
        child: const Icon(Icons.check_circle, color: Color(0xff039612)),
      );
    }

    if (widget.showIconOnFailedValidation && _isValid == false) {
      return Padding(
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
    return TextField(
      onTapOutside: (p) {
        if (widget.hideOnTapOutside) {
          _focus.unfocus();
        }
      },
      maxLength: widget.maxLength,
      obscureText: widget.obscureText,
      scrollPadding: _scrollPadding,
      focusNode: _focus,
      onTap: widget.onTap,
      controller: widget.controller,
      readOnly: widget.readOnly,
      style:
          widget.textStyle ??
          const PrimaryTextStyle(
            fontSize: 15,
            color: Color(0xff242424),
            fontWeight: FontWeight.w500,
          ),
      textAlign: widget.textAlign ?? TextAlign.left,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              prefixIcon: widget.prefix != null
                  ? Padding(
                      padding:
                          widget.prefixIconPadding ??
                          (widget.zeroLeftPadding
                              ? const EdgeInsets.only(left: 17, right: 10)
                              : const EdgeInsets.symmetric(horizontal: 17)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [widget.prefix!],
                      ),
                    )
                  : null,
              contentPadding: widget.contentPadding,
              suffixIcon: _suffixIcon,
              suffixIconConstraints: widget.suffixIconConstraints,
              hintText: widget.placeholder,
              hintStyle: widget.placeholderStyle ?? Theme.of(context).textTheme.headlineMedium,
              enabledBorder:
                  widget.decoration?.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: const BorderSide(color: ThemeUtil.fade),
                  ),
              focusedBorder:
                  widget.decoration?.focusedBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: const BorderSide(color: ThemeUtil.fade),
                  ),
              filled: true,
              fillColor: _color,
            )
          : InputDecoration(
              counterText: '',
              contentPadding: widget.contentPadding,
              prefixIcon: widget.prefix != null
                  ? Padding(
                      padding:
                          widget.prefixIconPadding ??
                          (widget.zeroLeftPadding
                              ? const EdgeInsets.only(left: 17, right: 10)
                              : const EdgeInsets.symmetric(horizontal: 5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [widget.prefix!],
                      ),
                    )
                  : null,
              suffixIconConstraints: widget.suffixIconConstraints,
              suffixIcon: _suffixIcon,
              hintText: widget.placeholder,
              hintStyle: widget.placeholderStyle ?? Theme.of(context).textTheme.headlineMedium,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: ThemeUtil.fade),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: ThemeUtil.fade, width: 1.5),
              ),
              filled: true,
              fillColor: _color,
            ),
      keyboardType: widget.multiLine ? TextInputType.multiline : widget.keyboardType,
      maxLines: widget.multiLine ? 5 : 1,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      onChanged: (value) {
        context.read<ActivityBloc>().add(PerformActivityEvent());
        // if (widget.controller != null) {
        //   widget.controller!.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
        // }

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
          _focus.unfocus(disposition: UnfocusDisposition.scope);
        }
      },
    );
  }
}

class SimpleInputFormatter extends TextInputFormatter {
  SimpleInputFormatter({required this.mask});

  String mask = "";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // masking
    final StringBuffer newText = StringBuffer();
    if (newValue.text.isNotEmpty && newValue.text.substring(0, 1) == '0') {
      const format = 'xxx xxx xxxx';
      for (int i = 0; i < newValue.text.length; i++) {
        final maskCharacter = format.characters.elementAt(i);
        final character = newValue.text.characters.elementAt(i);
        if (maskCharacter.toLowerCase() != 'x' && maskCharacter != character) {
          newText.write('$maskCharacter$character');
          continue;
        }
        newText.write(character);

        if (i == (format.characters.length - 1)) {
          return TextEditingValue(
            text: newText.toString(),
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      }
    } else if (newValue.text.isNotEmpty) {
      const format = 'xx xxx xxxx';
      for (int i = 0; i < newValue.text.length; i++) {
        final maskCharacter = format.characters.elementAt(i);
        final character = newValue.text.characters.elementAt(i);
        if (maskCharacter.toLowerCase() != 'x' && maskCharacter != character) {
          newText.write('$maskCharacter$character');
          continue;
        }
        newText.write(character);

        if (i == (format.characters.length - 1)) {
          return TextEditingValue(
            text: newText.toString(),
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
