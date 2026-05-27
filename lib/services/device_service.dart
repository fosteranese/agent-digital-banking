import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart' as pip;

import 'package:my_sage_agent/data/device_info.dart';
import 'package:my_sage_agent/env/env.dart';
import 'package:my_sage_agent/logger.dart';

/// Service for managing device information and metadata.
/// 
/// Provides access to device details like OS info, package info, UDID, etc.
class DeviceService {
  static DeviceInfo? _device;
  static DeviceInfo details = const DeviceInfo();
  static pip.PackageInfo? _package;

  /// Get the unique app bundle ID for the current platform.
  static String get appId {
    if (Platform.isAndroid) {
      return Env.androidBundleId;
    }

    if (Platform.isIOS) {
      return Env.iosBundleId;
    }

    return Env.appId;
  }

  /// Get combined device information with location and package metadata.
  static DeviceInfo get info {
    details = (_device ?? details).copyWith(
      latitude: null,
      longitude: null,
      build: _package?.buildNumber,
      version: _package?.version,
      channel: _package?.packageName,
      fcmToken: null,
    );

    return details;
  }

  /// Get device information async (Android/iOS specific details).
  static Future<DeviceInfo> get deviceInfo async {
    final device = DeviceInfoPlugin();
    DeviceInfo? newInfo;
    try {
      String udid = await FlutterUdid.udid;
      if (Platform.isAndroid) {
        final android = await device.androidInfo;

        newInfo = DeviceInfo(
          channel: android.device,
          description:
              '${android.manufacturer}::${android.brand}::${android.model}::${android.display}::${android.version}::${android.device}::$udid::${android.isPhysicalDevice}',
          deviceId: udid,
          deviceName: android.product,
          deviceType: 'android',
          userAgent: android.device,
          version: android.version.release,
          isPhysicalDevice: android.isPhysicalDevice,
        );
      } else if (Platform.isIOS) {
        final ios = await device.iosInfo;
        newInfo = DeviceInfo(
          channel: ios.utsname.release,
          description:
              '${ios.utsname.sysname}::${ios.model}::${ios.utsname.release}::${ios.utsname.version}::${ios.systemVersion}::${ios.isPhysicalDevice}',
          deviceId: udid,
          deviceName: ios.name,
          deviceType: 'iphone',
          userAgent: ios.utsname.machine,
          version: ios.utsname.version,
          isPhysicalDevice: ios.isPhysicalDevice,
        );
      }
    } catch (ex) {
      logger.e(ex);
    }

    if (newInfo != null) {
      _device = newInfo;
    }

    return _device ?? details;
  }

  /// Get app package information (version, build number, etc.).
  static Future<pip.PackageInfo> get packageInfo async {
    try {
      _package = await pip.PackageInfo.fromPlatform();
      if (_package != null) {
        _package = pip.PackageInfo(
          appName: _package!.appName,
          buildNumber: Env.buildNumber,
          packageName: _package!.packageName,
          version: _package!.version,
          buildSignature: _package!.buildSignature,
          installerStore: _package!.installerStore,
        );
      }

      logger.i(_package);
      logger.i(_package?.buildNumber ?? '');
    } catch (ex) {
      logger.e(ex);
    }

    return _package!;
  }
}
