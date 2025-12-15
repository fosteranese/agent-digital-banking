import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import 'base_input.dart';
import 'select_screen.dart';

class FormSelectOption extends Equatable {
  const FormSelectOption({
    this.text,
    this.label,
    required this.value,
    this.icon,
    this.trailing,
    this.selected = false,
    this.showOnSelected,
    this.data,
  });

  final String? text;
  final Widget? label;
  final String value;
  final Widget? icon;
  final Widget? trailing;
  final bool selected;
  final Widget? showOnSelected;
  final dynamic data;

  @override
  List<Object?> get props => [text, value, icon, trailing, selected, showOnSelected, data];
}

class FormSelect extends StatefulWidget {
  const FormSelect({
    super.key,
    this.label = '',
    this.bottomSpace = 20,
    this.prefix,
    this.controller,
    this.placeholder,
    this.validation,
    this.showIconOnSuccessfulValidation = false,
    this.showIconOnFailedValidation = false,
    this.onSuccess,
    this.info,
    required this.title,
    required this.options,
    this.selectedOption,
    this.onSelectedOption,
    this.onUnSelectedOption,
    this.useLongList = false,
    this.useTextAsSelectedDisplayItem = false,
    this.onTap,
    this.showMenu = false,
    this.color = Colors.transparent,
    this.contentPadding,
    this.placeholderStyle,
    this.textAlign,
    this.textStyle,
    this.decoration,
    this.maxLength,
    this.prefixIconPadding,
    this.inputHeight = 48,
    this.readOnly = false,
    this.tooltip,
    this.loading = false,
  });

  final String label;
  final double bottomSpace;
  final Widget? prefix;
  final TextEditingController? controller;
  final String? placeholder;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final void Function(String)? onSuccess;
  final Widget? info;
  final String title;
  final List<FormSelectOption> options;
  final FormSelectOption? selectedOption;
  final void Function(FormSelectOption option)? onSelectedOption;
  final void Function()? onUnSelectedOption;
  final bool useLongList;
  final bool useTextAsSelectedDisplayItem;
  final bool Function()? onTap;
  final bool showMenu;
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
  final String? tooltip;
  final bool loading;

  @override
  State<FormSelect> createState() => _FormSelectState();
}

class _FormSelectState extends State<FormSelect> {
  late FormSelectOption? _selectedOption = widget.selectedOption;
  late final _controller = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      if (widget.selectedOption != null) {
        _onSelected(widget.selectedOption!);
      } else {
        _previouslySelected();
      }
    });

    if (widget.showMenu) {
      Future.delayed(const Duration(seconds: 0), () {
        _openMenu();
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormSelect oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the constructor value has changed
    if (widget.selectedOption != null) {
      _onSelected(widget.selectedOption!);
    } else if (widget.controller?.text.isEmpty ?? true) {
      _onUnSelected();
    } else {
      _previouslySelected();
    }
  }

  void _previouslySelected() {
    final previousSelection = widget.options.firstWhereOrNull((item) {
      return item.value == widget.controller?.text;
    });

    if (previousSelection != null) {
      _onSelected(previousSelection);
    }
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

              if (widget.controller != null && widget.controller!.text.isNotEmpty) {
                _selectedOption = widget.options.firstWhereOrNull(
                  (option) => option.value == widget.controller!.text,
                );
              } else {
                _selectedOption = null;
                widget.controller?.text = '';
                _controller.text = '';
              }

              _openMenu();
            },

      inputHeight: widget.inputHeight,
      bottomSpace: widget.bottomSpace,
      controller: _controller,
      key: widget.key,
      readOnly: true,
      label: widget.label,
      onSuccess: widget.onSuccess,
      placeholder: widget.placeholder,
      prefix: widget.prefix,
      suffix: widget.readOnly
          ? null
          : InkWell(
              onTap: (!widget.loading) ? _openMenu : null,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!widget.loading) Icon(Icons.keyboard_arrow_down_outlined),
                    if (widget.loading)
                      SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
      validation: widget.validation,
      info: widget.info,
      color: widget.color,
      contentPadding: widget.contentPadding,
      textAlign: widget.textAlign,
      textStyle: widget.textStyle,
      decoration: widget.decoration,
      // maxLength: 1,
      prefixIconPadding: widget.prefixIconPadding,
      tooltip: widget.tooltip,
    );
  }

  void _onSelected(FormSelectOption selected) {
    setState(() {
      _selectedOption = selected;
      widget.controller?.text = selected.value;
      _controller.text = selected.text ?? '';
      if (widget.onSelectedOption != null) {
        widget.onSelectedOption!(_selectedOption!);
      }
    });
  }

  void _onUnSelected() {
    setState(() {
      _selectedOption = null;
      widget.controller?.text = '';
      _controller.text = '';
      if (widget.onUnSelectedOption != null) {
        widget.onUnSelectedOption!();
      }
    });
  }

  void _openMenu() {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext ?? context,
      isScrollControlled: widget.options.length > 5,
      // barrierColor: Colors.white.withOpacity(0.6),
      useSafeArea: false,
      builder: (context) {
        if (widget.options.length <= 5) {
          return FormSelectOptionScreen(
            fullScreen: false,
            title: widget.title,
            options: widget.options,
            onSelectedOption: _onSelected,
            selectedOption: _selectedOption,
          );
        }

        return MediaQuery(
          data: MediaQueryData.fromView(View.of(context)),
          child: FormSelectOptionScreen(
            fullScreen: true,
            title: widget.title,
            options: widget.options,
            onSelectedOption: _onSelected,
            selectedOption: _selectedOption,
          ),
        );
      },
    );
  }
}
