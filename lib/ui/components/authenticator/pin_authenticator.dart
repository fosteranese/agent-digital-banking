import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/authentication.util.dart';
import 'package:my_sage_agent/utils/biometric.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:my_sage_agent/env/env.dart';

class PinAuthenticator extends StatefulWidget {
  const PinAuthenticator({
    super.key,
    this.title,
    required this.onSuccess,
    this.allowBiometric = false,
    required this.end,
  });

  final String? title;
  final bool allowBiometric;
  final void Function(String pin) onSuccess;
  final void Function() end;

  @override
  State<PinAuthenticator> createState() => _PinAuthenticatorState();
}

class _PinAuthenticatorState extends State<PinAuthenticator> {
  final int _pinLength = Env.pingLength;
  final ValueNotifier<String> _pin = ValueNotifier('');

  static const Color _accentColor = Color(0xffF79A31);

  bool get _enableBiometric {
    if (!widget.allowBiometric) {
      return false;
    }

    return context.read<BiometricBloc>().isTransactionEnabled;
  }

  void _biometricAuthentication() {
    final nav = GoRouter.of(context);
    BiometricUtil.authenticateWithBiometrics(() async {
      final pin = await AuthenticationUtil.getPin;

      if (pin.isEmpty) {
        MessageUtil.displayErrorDialog(
          MyApp.navigatorKey.currentContext!,
          message: 'Please use your PIN at least once to use the bio feature',
        );
        return;
      }

      nav.pop();
      return widget.onSuccess(pin);
    });
  }

  @override
  initState() {
    if (context.read<BiometricBloc>().isTransactionEnabled) {
      context.read<AuthBloc>().add(const RetrievePin());
    }

    if (widget.allowBiometric && context.read<BiometricBloc>().isAutoTransactionEnabled) {
      _biometricAuthentication();
    }

    super.initState();
    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: widget.title ?? 'Authorize Transaction',
      showBackBtn: true,
      bottomNavigationBar: Padding(
        padding: const .only(top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: .min,
          children: [
            if (_enableBiometric)
              Padding(
                padding: const .only(bottom: 10),
                child: IconButton(
                  icon: Icon(Icons.fingerprint, color: _accentColor),
                  onPressed: _biometricAuthentication,
                ),
              ),
            FormButton(
              onPressed: () {
                if (_pin.value.length == _pinLength) {
                  context.pop();
                  widget.onSuccess(_pin.value);
                } else if (_pin.value.isEmpty) {
                  MessageUtil.displayErrorDialog(
                    context,
                    title: 'Authorization Failed',
                    message: 'You did not enter your PIN. Kindly provide a valid PIN to proceed',
                  );
                } else {
                  MessageUtil.displayErrorDialog(
                    context,
                    title: 'Authorization Failed',
                    message: 'Your PIN is incomplete. Kindly provide a valid PIN to proceed',
                  );
                }
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Authorize Collection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            Text(
              'Enter your Agent ID to complete the collection',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ThemeUtil.flat),
            ),
            const SizedBox(height: 20),
            FormPasswordInput(
              isPin: true,
              maxLength: 4,
              label: 'Authorization PIN',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChange: (value) {
                _pin.value = value;
                if (value.length == _pinLength) {
                  context.pop();
                  widget.onSuccess(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
