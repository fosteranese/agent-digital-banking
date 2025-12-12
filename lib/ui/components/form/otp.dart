import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import '../../../env/env.dart';
import '../../../logger.dart';
import '../../../utils/formatter.util.dart';

class Otp extends StatefulWidget {
  const Otp({super.key, this.length = 4, this.onResendShortCode, required this.onCompleted});

  final int length;
  final VoidCallback? onResendShortCode;
  final void Function(String otp) onCompleted;

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // static const double _inputWidth = 60;
  static const double _spacing = 5.0;
  static const Color _borderColor = Color(0xff919195);

  late final int _otpWaitTime;
  late Timer _timer;
  String _timeLeft = '00:00';

  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _otpWaitTime = Env.resendOtpAfterInSeconds;

    _initializeInputs();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildOtpFields(), SizedBox(height: 20), if (widget.onResendShortCode != null) _timeLeft == '00:00' ? _buildResendButton() : _buildCountdownText(context)]);
  }

  /// --- UI Builders ---

  Widget _buildOtpFields() {
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: index < widget.length - 1 ? _spacing : 0),
              child: CharacterInput(controller: _controllers[index], focusNode: _focusNodes[index], previousFocusNode: index > 0 ? _focusNodes[index - 1] : null, nextFocusNode: index < widget.length - 1 ? _focusNodes[index + 1] : null, action: index == widget.length - 1 ? () => _onCompleted() : null, onPaste: _fillOtpAutomatically, initialFocus: index == 0),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildResendButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onResendShortCode?.call();
              _startTimer();
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Didn’t get the code? '),
                  TextSpan(
                    text: 'Resend',
                    style: PrimaryTextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                style: PrimaryTextStyle(fontSize: 14, color: Color(0xff010101)),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Icon(Icons.access_time_filled_outlined, color: Color(0xff919195)),
        SizedBox(width: 5),
        Text('0:00', style: PrimaryTextStyle(fontSize: 16, color: Color(0xff010101))),
      ],
    );
  }

  Widget _buildCountdownText(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onResendShortCode?.call();
              _startTimer();
            },
            child: Text('Request a new code in ', style: PrimaryTextStyle(fontSize: 14, color: Color(0xff010101))),
          ),
        ),
        SizedBox(width: 20),
        Icon(Icons.access_time_filled_outlined, color: Color(0xff919195)),
        SizedBox(width: 5),
        Text(_timeLeft, style: PrimaryTextStyle(fontSize: 16, color: Color(0xff010101))),
      ],
    );
  }

  /// --- Logic ---

  void _initializeInputs() {
    _focusNodes = List.generate(widget.length, (_) => FocusNode(), growable: false);
    _controllers = List.generate(widget.length, (_) => TextEditingController(), growable: false);
  }

  void _startTimer() {
    if (widget.onResendShortCode == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _otpWaitTime - timer.tick;
      if (remaining < 0) {
        timer.cancel();
        setState(() => _timeLeft = '00:00');
      } else {
        setState(() => _timeLeft = FormatterUtil.intToTimeLeft(remaining));
        logger.i('Time left: $_timeLeft');
      }
    });
  }

  void _onCompleted() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  void _fillOtpAutomatically(String otp) {
    final length = otp.length.clamp(0, widget.length);
    for (int i = 0; i < length; i++) {
      _controllers[i].text = otp[i];
    }

    // Unfocus last field after auto-fill
    if (_focusNodes.isNotEmpty) {
      _focusNodes.last.unfocus();
    }

    if (length == widget.length) {
      widget.onCompleted(otp.substring(0, widget.length));
    }
  }

  @override
  void dispose() {
    if (widget.onResendShortCode != null) _timer.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

class CharacterInput extends StatefulWidget {
  const CharacterInput({super.key, required this.controller, required this.focusNode, this.previousFocusNode, this.nextFocusNode, this.action, this.onPaste, this.initialFocus = false});

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? action;
  final void Function(String text)? onPaste;
  final bool initialFocus;

  @override
  State<CharacterInput> createState() => _CharacterInputState();
}

class _CharacterInputState extends State<CharacterInput> {
  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        widget.controller.clear();
      }
    });

    if (widget.initialFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 70,
      child: TextField(
        expands: true,
        maxLines: null,
        minLines: null,
        focusNode: widget.focusNode,
        controller: widget.controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: _handleInput,
        onSubmitted: (_) => _handleInput(widget.controller.text),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: _OtpState._borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _OtpState._borderColor, width: 1.5),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        contextMenuBuilder: widget.onPaste != null
            ? (context, editableTextState) => AdaptiveTextSelectionToolbar.editable(
                anchors: editableTextState.contextMenuAnchors,
                clipboardStatus: ClipboardStatus.pasteable,
                onCopy: null,
                onCut: null,
                onSelectAll: null,
                onShare: null,
                onLiveTextInput: null,
                onLookUp: null,
                onSearchWeb: null,
                onPaste: () async {
                  final data = await Clipboard.getData(Clipboard.kTextPlain);
                  final text = data?.text;
                  if (text?.isNotEmpty ?? false) {
                    widget.onPaste?.call(text!);
                  }
                },
              )
            : null,
      ),
    );
  }

  void _handleInput(String value) {
    if (value.isEmpty && widget.previousFocusNode != null) {
      widget.previousFocusNode!.requestFocus();
      return;
    }

    if (value.length == 1) {
      widget.nextFocusNode?.requestFocus();
      widget.action?.call();
    } else if (value.length > 1 && widget.onPaste != null) {
      widget.onPaste!(value);
    }
  }
}
