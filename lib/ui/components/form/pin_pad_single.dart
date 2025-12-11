import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/biometric/biometric_bloc.dart';
import '../../../utils/authentication.util.dart';
import '../../../utils/biometric.util.dart';
import '../../../utils/theme.util.dart';
import 'base_input.dart';
import 'pin_pad.dart';

class PinPadSingle extends StatefulWidget {
  const PinPadSingle({
    super.key,
    required this.previous,
    required this.next,
    required this.padding,
    required this.onPinEntered,
    this.pinLength = 6,
    this.pinPadType = PinPadType.setup,
  });

  final void Function() previous;
  final void Function() next;
  final EdgeInsets padding;
  final void Function(String value) onPinEntered;
  final int pinLength;
  final PinPadType pinPadType;

  @override
  State<PinPadSingle> createState() => _PinPadSingleState();
}

class _PinPadSingleState extends State<PinPadSingle> {
  late final _focusNode = FocusNode(canRequestFocus: true);
  late final _controller = TextEditingController();

  @override
  void initState() {
    if (context
        .read<BiometricBloc>()
        .isTransactionEnabled) {
      context.read<AuthBloc>().add(const RetrievePin());
    }

    if (widget.pinPadType == PinPadType.authenticate &&
        context
            .read<BiometricBloc>()
            .isAutoTransactionEnabled) {
      _biometricAuthentication();
    }

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
          placeholder: '****',
          contentPadding: EdgeInsets.zero,
          bottomSpace: 0,
          keyboardType:
              const TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
          obscureText: true,
          textAlign: TextAlign.center,
          textStyle: const TextStyle(
            fontSize: 28,
            letterSpacing: 5,
            fontWeight: FontWeight.bold,
          ),
          placeholderStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
          textInputAction: TextInputAction.send,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(
              widget.pinLength,
            ),
          ],
          onChange: (value) {
            if (value.length >= widget.pinLength) {
              _controller.text = value.substring(
                0,
                widget.pinLength,
              );
              _onSuccess();
              return;
            }
          },
        ),
        // if (widget.pinPadType == PinPadType.authenticate) const SizedBox(height: 20),
        // if (widget.pinPadType == PinPadType.authenticate)
        //   TextButton(
        //     onPressed: () {},
        //     child: Text(
        //       'Forgot PIN ?',
        //       style: TextStyle(
        //         fontFamily: ThemeUtil.fontHelveticaNeue,
        //         fontWeight: FontWeight.w600,
        //         fontSize: 14,
        //         color: Colors.black,
        //       ),
        //     ),
        //   ),
        if (widget.pinPadType == PinPadType.authenticate)
          const SizedBox(height: 20),
        if (widget.pinPadType == PinPadType.authenticate)
          _authenticate,
        if (widget.pinPadType == PinPadType.authenticate)
          const SizedBox(height: 20),
      ],
    );
  }

  void _onSuccess() {
    _focusNode.unfocus();
    context.read<AuthBloc>().add(SavePin(_pin));
    widget.onPinEntered(_pin);
  }

  String get _pin {
    return _controller.text;
  }

  void _biometricAuthentication() {
    BiometricUtil.authenticateWithBiometrics(() async {
      final pin = await AuthenticationUtil.getPin;
      return widget.onPinEntered(pin);
    });
  }

  Widget get _authenticate {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (context.read<AuthBloc>().pin.isEmpty) {
          return const SizedBox();
        }

        return TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          onPressed: () {
            _biometricAuthentication();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.fingerprint_outlined,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                'Use biometric authorization',
                style: TextStyle(
                  fontFamily: ThemeUtil.fontHelveticaNeue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
