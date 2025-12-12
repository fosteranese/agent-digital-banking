import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:my_sage_agent/blocs/activity/activity_bloc.dart';

import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({super.key, required this.controller, this.focusNode});

  final (TextEditingController, GeneralFlowFieldsDatum) controller;
  final FocusNode? focusNode;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  bool get _hasMax {
    return widget.controller.$2.field?.trasactionLimitAmount != null;
  }

  late final _focus = widget.focusNode ?? FocusNode(canRequestFocus: true);
  final _amount = ValueNotifier('');

  @override
  initState() {
    widget.controller.$1.addListener(() {
      _amount.value = widget.controller.$1.text.replaceAll('GHS ', '');
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: _hasMax ? 142 : 120,
      width: double.maxFinite,
      color: Color(0xffF1F4FF),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Enter amount',
            style: PrimaryTextStyle(fontSize: 14, color: Color(0xff4F4F4F), fontWeight: FontWeight.normal),
          ),

          // Spacer(),
          Expanded(
            child: KeyboardActions(
              autoScroll: false,
              overscroll: 0,
              disableScroll: true,
              enable: true,
              config: _buildConfig(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _amount,
                    builder: (context, value, child) {
                      if (value.isNotEmpty) {
                        return RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'GHS ',
                                style: PrimaryTextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xff919195)),
                              ),
                              TextSpan(text: value),
                            ],
                            style: PrimaryTextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xff010101)),
                          ),
                        );
                      }

                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'GHS ',
                              style: PrimaryTextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xff919195)),
                            ),
                            TextSpan(text: '0.00'),
                          ],
                          style: PrimaryTextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xff010101)),
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: widget.controller.$1,
                    onChanged: (_) {
                      context.read<ActivityBloc>().add(PerformActivityEvent());
                    },
                    onEditingComplete: () {
                      context.read<ActivityBloc>().add(PerformActivityEvent());
                    },
                    onSubmitted: (_) {
                      context.read<ActivityBloc>().add(PerformActivityEvent());
                    },
                    focusNode: _focus,
                    textAlign: TextAlign.center,
                    inputFormatters: [AmountTextFormatter(currencyPrefix: 'GHS ')],
                    onTapOutside: (event) {
                      _focus.unfocus(disposition: UnfocusDisposition.scope);
                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                    style: PrimaryTextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.transparent),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintStyle: PrimaryTextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.transparent),
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Spacer(),
          if (_hasMax)
            Text(
              'Maximum Amount: GHS ${widget.controller.$2.field?.trasactionLimitAmount}',
              style: PrimaryTextStyle(fontSize: 14, color: Color(0xff919195), fontWeight: FontWeight.normal),
            ),
        ],
      ),
    );
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
                  _focus.unfocus(disposition: UnfocusDisposition.scope);
                  // _onValidate();
                },
                child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Done')),
              );
            },
          ],
        ),
      ],
    );
  }
}

class AmountTextFormatter extends TextInputFormatter {
  final String currencyPrefix;
  final int decimalDigits;

  AmountTextFormatter({this.currencyPrefix = 'GHS ', this.decimalDigits = 2});

  String _getRawValue(String text) {
    return text.replaceAll(currencyPrefix, '').replaceAll(RegExp(r'[^\d.]'), '').trim();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newRawValue = _getRawValue(newValue.text);

    // --- Handle empty text safely ---
    if (newRawValue.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    // Prevent multiple decimals
    if (newRawValue.split('.').length > 2) {
      return oldValue;
    }

    // Validate decimal precision
    final parts = newRawValue.split('.');
    if (parts.length == 2 && parts[1].length > decimalDigits) {
      return oldValue;
    }

    // Format integer part
    final formatter = NumberFormat.decimalPattern();
    final integer = int.tryParse(parts[0]) ?? 0;
    String formattedText = formatter.format(integer);

    // Add decimals if present
    if (parts.length == 2) {
      formattedText += '.${parts[1]}';
    }

    final finalText = '$currencyPrefix$formattedText';

    // --- Cursor Fix (safe clamping) ---
    final selectionIndexFromRight = newValue.text.length - newValue.selection.end;

    var newOffset = finalText.length - selectionIndexFromRight;

    // Ensure cursor always stays in a valid range
    if (newOffset < currencyPrefix.length) {
      newOffset = currencyPrefix.length;
    }
    if (newOffset > finalText.length) {
      newOffset = finalText.length;
    }

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
