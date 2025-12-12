import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/authentication.util.dart';
import 'package:my_sage_agent/utils/biometric.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:my_sage_agent/env/env.dart';

class PinAuthenticator extends StatefulWidget {
  const PinAuthenticator({super.key, required this.onSuccess, this.allowBiometric = false, required this.end});

  final bool allowBiometric;
  final void Function(String pin) onSuccess;
  final void Function() end;

  @override
  State<PinAuthenticator> createState() => _PinAuthenticatorState();
}

class _PinAuthenticatorState extends State<PinAuthenticator> {
  final int _pinLength = Env.pingLength;
  final ValueNotifier<String> _pin = ValueNotifier('');

  static const double _pinBoxHeight = 70;
  static const double _buttonSize = 63;
  static const double _spacing = 10.0;

  static const Color _bgColor = Colors.white;
  static const Color _pinBoxBg = Color(0xffFAFAFA);
  static const Color _pinBoxBorder = Color(0xffE7E7E7);
  static const Color _pinBoxActiveBorder = Color(0xffF79A31);
  static const Color _buttonBg = Color(0xffF6F6F6);
  static const Color _accentColor = Color(0xffF79A31);

  bool get _enableBiometric {
    if (!widget.allowBiometric) {
      return false;
    }

    return context.read<BiometricBloc>().isTransactionEnabled;
  }

  void _updatePin(int digit) {
    if (_pin.value.length < _pinLength) {
      _pin.value += digit.toString();
      if (_pin.value.length == _pinLength) {
        Navigator.pop(context);
        widget.onSuccess(_pin.value);
      }
    }
  }

  void _deletePin() {
    if (_pin.value.isNotEmpty) {
      _pin.value = _pin.value.substring(0, _pin.value.length - 1);
    }
  }

  Widget _buildPinBoxes() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ValueListenableBuilder<String>(
        valueListenable: _pin,
        builder: (context, pin, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = (constraints.maxWidth - (_spacing * (_pinLength - 1))) / _pinLength;
              return Row(
                children: List.generate(
                  _pinLength,
                  (i) => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: i == 0 ? 0 : _spacing),
                    width: itemWidth,
                    height: _pinBoxHeight,
                    decoration: BoxDecoration(
                      color: pin.length > i ? Colors.white : _pinBoxBg,
                      border: Border.all(color: pin.length == i ? _pinBoxActiveBorder : _pinBoxBorder),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: pin.length > i ? const Icon(Icons.emergency, size: 25, color: Colors.black) : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildKeypadButton({required Widget child, required VoidCallback onPressed, bool filled = true}) {
    return IconButton(
      style: IconButton.styleFrom(backgroundColor: filled ? _buttonBg : null, fixedSize: const Size(_buttonSize, _buttonSize)),
      onPressed: onPressed,
      icon: child,
    );
  }

  Widget _buildKeypad() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 30, mainAxisSpacing: 15.0, childAspectRatio: 1.0),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (index < 9) {
            return _buildKeypadButton(
              child: Text('${index + 1}', style: PrimaryTextStyle(fontSize: 20)),
              onPressed: () => _updatePin(index + 1),
            );
          } else if (index == 9) {
            return _enableBiometric
                ? _buildKeypadButton(
                    filled: false,
                    child: Icon(Icons.fingerprint, color: _accentColor),
                    onPressed: _biometricAuthentication,
                  )
                : const SizedBox.shrink();
          } else if (index == 10) {
            return _buildKeypadButton(
              child: Text('0', style: PrimaryTextStyle(fontSize: 20)),
              onPressed: () => _updatePin(0),
            );
          } else {
            return _buildKeypadButton(
              filled: false,
              child: const Icon(Icons.backspace_outlined, color: Colors.black),
              onPressed: _deletePin,
            );
          }
        },
      ),
    );
  }

  void _biometricAuthentication() {
    final nav = GoRouter.of(context);
    BiometricUtil.authenticateWithBiometrics(() async {
      final pin = await AuthenticationUtil.getPin;

      if (pin.isEmpty) {
        MessageUtil.displayErrorDialog(MyApp.navigatorKey.currentContext!, message: 'Please use your PIN at least once to use the bio feature');
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
    return Scaffold(
      appBar: AppBar(backgroundColor: _bgColor),
      backgroundColor: _bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Transaction PIN',
            textAlign: TextAlign.center,
            style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          Text('Enter your PIN to authorize the transaction', textAlign: TextAlign.center, style: PrimaryTextStyle(fontSize: 14)),
          const Spacer(),
          _buildPinBoxes(),
          const Spacer(flex: 2),
          TextButton(
            onPressed: () {
              context.push(
                ProcessFormPage.routeName,
                extra: {
                  'form': GeneralFlowForm(formId: "602694fa-a957-4f58-8312-3ef135368d65", categoryId: "b534d7fc-5365-4cbe-9cb2-d2ae36c2c173", accessType: 'CUSTOMER', formName: "Reset Authorisation Pin", description: '', caption: 'Reset Authorisation Pin', tooltip: 'Reset Authorisation Pin', icon: 'resetPin.png', iconType: 'png', requireVerification: 0, verifyEndpoint: "internalResource/userSettings/verifyForgotPIN", processEndpoint: "FBLOnline/Initiate", rank: 3, status: 1, statusLabel: 'Success'),
                  'amDoing': AmDoing.transaction,
                  'activity': ActivityDatum(
                    activity: Activity(activityId: "4b964e1b-5670-4fc5-8cb9-80e97e6498db", activityType: ActivityTypesConst.fblOnline),
                    imageDirectory: "Internal",
                  ),
                },
              );
            },
            child: Text(
              'Forgot PIN ?',
              style: PrimaryTextStyle(color: Color(0xff211F1F), fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
          ),
          const Spacer(flex: 1),
          Center(child: _buildKeypad()),
          const Spacer(),
        ],
      ),
    );
  }
}
