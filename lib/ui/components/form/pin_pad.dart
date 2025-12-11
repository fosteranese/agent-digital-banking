import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/biometric/biometric_bloc.dart';
import '../../../utils/authentication.util.dart';
import '../../../utils/biometric.util.dart';

enum PinPadType { setup, authenticate }

class PinPad extends StatefulWidget {
  const PinPad({
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
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  int _currentIndex = 0;
  String _pin = '';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _inputContainer,
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _keyCharacter(context, 1),
                const SizedBox(height: 20),
                _keyCharacter(context, 4),
                const SizedBox(height: 20),
                _keyCharacter(context, 7),
                if (widget.pinPadType ==
                        PinPadType.authenticate &&
                    context
                        .read<BiometricBloc>()
                        .isTransactionEnabled)
                  const SizedBox(height: 20),
                if (widget.pinPadType ==
                        PinPadType.authenticate &&
                    context
                        .read<BiometricBloc>()
                        .isTransactionEnabled)
                  _authenticate,
              ],
            ),
            const SizedBox(width: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _keyCharacter(context, 2),
                const SizedBox(height: 20),
                _keyCharacter(context, 5),
                const SizedBox(height: 20),
                _keyCharacter(context, 8),
                const SizedBox(height: 20),
                _keyCharacter(context, 0),
              ],
            ),
            const SizedBox(width: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _keyCharacter(context, 3),
                const SizedBox(height: 20),
                _keyCharacter(context, 6),
                const SizedBox(height: 20),
                _keyCharacter(context, 9),
                const SizedBox(height: 20),
                _deleteKey,
              ],
            ),
          ],
        ),
        if (widget.pinPadType == PinPadType.setup)
          const SizedBox(height: 40),
        if (widget.pinPadType == PinPadType.authenticate)
          const SizedBox(height: 20),
        if (widget.pinPadType == PinPadType.authenticate)
          TextButton(
            onPressed: () {},
            child: const Text('Forgot PIN ?'),
          ),
        if (widget.pinPadType == PinPadType.authenticate)
          const SizedBox(height: 20),
      ],
    );
  }

  Widget _keyCharacter(BuildContext context, int number) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      onPressed: () {
        setState(() {
          if (_currentIndex >= widget.pinLength) {
            _currentIndex = widget.pinLength;
            return;
          }
          ++_currentIndex;
          _pin = '$_pin$number';
          if (_pin.length == widget.pinLength) {
            context.read<AuthBloc>().add(SavePin(_pin));
            widget.onPinEntered(_pin);
          }
        });
      },
      child: Text(
        number.toString(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xff97785E),
        ),
      ),
    );
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
          child: Icon(
            Icons.fingerprint_outlined,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  Widget get _deleteKey {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      onPressed: () {
        setState(() {
          if (_currentIndex <= 0) {
            _currentIndex = 0;
            _pin = '';
            return;
          }
          --_currentIndex;
          _pin = _pin.substring(0, _currentIndex);
        });
      },
      child: const Icon(
        Icons.backspace_outlined,
        color: Colors.red,
      ),
    );
  }

  Widget get _inputContainer {
    List<Widget> list = [];
    for (int i = 1; i <= widget.pinLength; i++) {
      list.add(_buildInput(i));
      if (i < widget.pinLength) {
        list.add(const SizedBox(width: 10));
      }
    }
    return SizedBox(
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: list,
      ),
    );
  }

  Widget _buildInput(int index) {
    if (index <= _currentIndex) {
      return Text(
        '*',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Container(
      width: 20,
      height: 10,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }
}

class CharacterInput extends StatelessWidget {
  const CharacterInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: FormField(
        builder: (field) {
          return TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xff919195),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xff919195),
                  width: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
