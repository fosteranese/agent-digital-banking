import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../logger.dart';

class BiometricUtil {
  static final auth = LocalAuthentication();

  static Future<bool> isDeviceSupported() async {
    final isSupported = await auth.isDeviceSupported();

    if (!isSupported) {
      return false;
    }

    final canCheckBiometric = await checkBiometrics();

    if (!canCheckBiometric) {
      return false;
    }

    await getAvailableBiometrics();
    return true;
  }

  static Future<bool> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (_) {
      canCheckBiometrics = false;
    }

    return canCheckBiometrics;
  }

  static Future<List<BiometricType>?>
  getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth
          .getAvailableBiometrics();
    } on PlatformException catch (_) {
      availableBiometrics = <BiometricType>[];
    }

    return availableBiometrics;
  }

  static Future<bool> authenticateWithBiometrics(
    void Function() onSuccess,
  ) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Biometric Login',
        sensitiveTransaction: true,
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
      if (authenticated) {
        onSuccess();
      }
    } on PlatformException catch (e) {
      logger.i(e);
      return false;
    }

    if (authenticated) {
      return true;
    }

    return false;
  }
}
