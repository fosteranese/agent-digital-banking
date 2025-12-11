import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

import '../../../utils/validator.util.dart';
import 'input.dart';

// import '../../../utils/validator.util.dart';

class GhanaCardInput extends StatefulWidget {
  const GhanaCardInput({
    super.key,
    required TextEditingController controller,
    this.onSuccess,
    this.isRequired = true,
  }) : _controller = controller;

  final TextEditingController _controller;
  final void Function(String)? onSuccess;
  final bool isRequired;

  @override
  State<GhanaCardInput> createState() =>
      _GhanaCardInputState();
}

class _GhanaCardInputState extends State<GhanaCardInput> {
  @override
  Widget build(BuildContext context) {
    return FormInput(
      label:
          'Ghana Card Number ${widget.isRequired ? '*' : ''}',
      placeholder: 'GHA-012345678-9',
      controller: widget._controller,
      showIconOnSuccessfulValidation: true,
      validation: () =>
          Validator.ghanaCard(widget._controller.text),
      onSuccess: widget.onSuccess,
      inputFormatters: [GhanaCardInputFormatter()],
    );
  }
}

class GhanaCardInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text =
        oldValue.text.length > newValue.text.length &&
            oldValue.text.replaceAll(newValue.text, '') ==
                '-'
        ? newValue.text.substring(
            0,
            newValue.text.length - 1,
          )
        : newValue.text;
    var formattedText = '';

    var prefix = text
        .substring(0, text.length < 3 ? text.length : 3)
        .toUpperCase();
    if (!prefix.isAlpha) {
      return oldValue;
    }

    if (prefix.length == 3) {
      prefix = '$prefix-';
    }

    formattedText = prefix;

    if (text.length < 5) {
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(
          offset: formattedText.length,
        ),
      );
    }

    var middle = text
        .substring(4, text.length < 13 ? text.length : 13)
        .toUpperCase();
    if (middle.isNotEmpty && !middle.isNumeric) {
      return oldValue;
    }

    if (middle.length == 9) {
      middle = '$middle-';
    }
    formattedText += middle;

    if (text.length < 14) {
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(
          offset: formattedText.length,
        ),
      );
    }

    var end = text
        .substring(14, text.length < 15 ? text.length : 15)
        .toUpperCase();
    if (end.isNotEmpty && !end.isAlphanumeric) {
      return oldValue;
    }
    formattedText += end;

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: formattedText.length,
      ),
    );
  }
}