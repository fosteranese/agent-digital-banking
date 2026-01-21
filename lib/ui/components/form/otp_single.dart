import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../env/env.dart';
import '../../../logger.dart';
import '../../../utils/formatter.util.dart';
import 'base_input.dart';

class OtpSingle extends StatefulWidget {
  const OtpSingle({super.key, this.length = 4, this.onResendShortCode, required this.onCompleted});

  final int length;
  final void Function()? onResendShortCode;
  final void Function(String otp) onCompleted;

  @override
  State<OtpSingle> createState() => _OtpSingleState();
}

class _OtpSingleState extends State<OtpSingle> {
  String? appSignature;
  String? otpCode;
  late Timer _timer;
  late final int _otpWaitTime;
  late String _timeLeft;

  late final _focusNode = FocusNode(canRequestFocus: true);
  late final _controller = TextEditingController();

  @override
  void initState() {
    _otpWaitTime = Env.resendOtpAfterInSeconds;

    _restartCounter();
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseFormInput(
          focus: _focusNode,
          controller: _controller,
          placeholder: '******',
          // contentPadding: EdgeInsets.zero,
          bottomSpace: 0,
          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          obscureText: true,
          textAlign: TextAlign.center,
          textStyle: const TextStyle(fontSize: 28, letterSpacing: 5, fontWeight: FontWeight.bold),
          placeholderStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          textInputAction: TextInputAction.send,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.length),
          ],
          onChange: (value) {
            if (value.length >= widget.length) {
              _controller.text = value.substring(0, widget.length);
              _onSuccess();
              return;
            }
          },
        ),
        if (widget.onResendShortCode != null) const SizedBox(height: 50),
        if (widget.onResendShortCode == null) const SizedBox(height: 30),
        if (widget.onResendShortCode != null && _timeLeft == '00:00')
          TextButton(
            onPressed: () {
              if (widget.onResendShortCode != null) {
                widget.onResendShortCode!();
                _restartCounter();
              }
            },
            child: const Text(
              'Didn’t receive a code?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decorationStyle: TextDecorationStyle.solid,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        if (widget.onResendShortCode != null && _timeLeft != '00:00')
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Request a new code in ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text: '$_timeLeft mins',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _restartCounter() {
    if (widget.onResendShortCode == null) {
      return;
    }

    setState(() {
      _timeLeft = FormatterUtil.intToTimeLeft(_otpWaitTime);
    });

    // Future.delayed(const Duration(seconds: 3), () {
    //   otpCode = '123456';
    //   _autoCompleteOtp(otpCode!);
    // });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeLeft = _otpWaitTime - timer.tick;
      if (timeLeft < 0) {
        _timer.cancel();

        setState(() {
          _timeLeft = '00:00';
        });

        return;
      }

      setState(() {
        _timeLeft = FormatterUtil.intToTimeLeft(timeLeft);
      });
      logger.i('minutes: $_timeLeft');
    });
  }

  void _onSuccess() {
    _focusNode.unfocus();
    widget.onCompleted(_otp);
  }

  String get _otp {
    return _controller.text;
  }

  @override
  void dispose() {
    if (widget.onResendShortCode != null) {
      _timer.cancel();
    }

    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
