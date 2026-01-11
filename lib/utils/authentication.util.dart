import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../main.dart';
import '../ui/components/authenticator/otp_authenticator.dart';
import '../ui/components/authenticator/pin_authenticator.dart';
import '../ui/components/authenticator/secret_answer_authenticator.dart';
import 'app.util.dart';

class AuthenticationUtil {
  static void start({
    String? title,
    required List<Map<String, dynamic>> authModes,
    required Map<String, dynamic> payload,
    required void Function({
      String? pin,
      String? secretAnswer,
      String? otp,
      required Map<String, dynamic> payload,
    })
    complete,
    void Function()? onResendShortCode,
  }) {
    String pin = '';
    String secretAnswer = '';
    String otp = '';

    Future<void> getLocationAndComplete() async {
      // await AppUtil.locationInfo;
      complete(payload: payload, otp: otp, pin: pin, secretAnswer: secretAnswer);
    }

    if (authModes.isEmpty) {
      getLocationAndComplete();
      return;
    }

    // authentication sequence
    int index = 0;
    authenticate() async {
      await Future.delayed(const Duration(seconds: 0));
      var authMode = authModes[index];
      switch (authMode['type']) {
        case 'PIN':
          AuthenticationUtil.pin(
            title: title,
            onSuccess: (value) {
              ++index;
              pin = value;

              if (authModes.length != index) {
                authenticate();
              } else {
                getLocationAndComplete();
              }
            },
            allowBiometric: true,
          );
          break;
        case 'OTP':
          AuthenticationUtil.otp(
            authMode: authMode,
            onResendShortCode: onResendShortCode,
            onSuccess: (value) {
              ++index;
              otp = value;

              if (authModes.length != index) {
                authenticate();
              } else {
                getLocationAndComplete();
              }
            },
          );
          break;
        case 'SECRET_ANSWER':
        default:
          AuthenticationUtil.secretAnswer(
            onSuccess: (value) {
              ++index;
              secretAnswer = value;

              if (authModes.length != index) {
                authenticate();
              } else {
                getLocationAndComplete();
              }
            },
          );
          break;
      }
    }

    // start authenticate
    authenticate();
  }

  static Future pin({
    String? title,
    required void Function(String pin) onSuccess,
    bool allowBiometric = false,
  }) {
    return showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: const Color(0xE0000000),
      useSafeArea: false,
      builder: (BuildContext context) {
        return PinAuthenticator(
          title: title,
          onSuccess: onSuccess,
          allowBiometric: allowBiometric,
          end: () => end(context),
        );
      },
    );
  }

  static Future secretAnswer({
    required void Function(String pin) onSuccess,
    bool allowBiometric = false,
  }) {
    return showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierColor: Colors.white.withAlpha(153),
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretAnswerAuthenticator(onSuccess: onSuccess, end: () => end(context));
      },
    );
  }

  static Future otp({
    required void Function(String pin) onSuccess,
    bool allowBiometric = false,
    required Map<String, dynamic> authMode,
    void Function()? onResendShortCode,
  }) {
    if (onResendShortCode != null) {
      onResendShortCode();
    }

    return showDialog(
      context: MyApp.navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierColor: Colors.white.withAlpha(153),
      useSafeArea: false,
      builder: (BuildContext context) {
        return OtpAuthenticator(
          authMode: authMode,
          onSuccess: onSuccess,
          onResendShortCode: onResendShortCode,
          end: () => end(context),
        );
      },
    );
  }

  static void end(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<String> get getPin async {
    var pin = MyApp.navigatorKey.currentContext!.read<AuthBloc>().pin;

    if (pin.isNotEmpty) {
      return pin;
    }

    pin = await AppUtil.auth.getCurrentUserPin() ?? '';
    return pin;
  }
}
