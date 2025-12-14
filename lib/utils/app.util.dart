import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:freerasp/freerasp.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:package_info_plus/package_info_plus.dart' as pip;
import 'package:my_sage_agent/ui/components/form/outline_button.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../constants/status.const.dart';
import '../data/database/db.dart';
import '../data/device_info.dart';
import '../data/models/initialization_response.dart';
import '../data/models/push_notification.dart';
import '../data/models/response.modal.dart';
import '../data/models/user_response/user_response.dart';
import '../data/repository/auth.repo.dart';
import '../env/env.dart';
import '../firebase_options.bak.dart';
import '../logger.dart';
import '../main.dart';
import '../ui/components/form/button.dart';
import '../ui/components/popover.dart';
import '../ui/pages/notifications.page.dart';
import 'messenger.util.dart';

class AppUtil {
  static DeviceInfo? _device;
  static DeviceInfo details = const DeviceInfo();
  static Position? location;
  static pip.PackageInfo? _package;
  static late StreamSubscription<Position> locationStream;
  static late StreamSubscription<ServiceStatus> locationStatusStream;
  static bool _listeningToLocationStatus = false;
  static bool askingUserForLocation = false;
  static List<CountryWithPhoneCode> countries = [];
  static late CountryWithPhoneCode currentCountry;
  static late CountryWithPhoneCode gh;
  static String? fcmToken;

  static late InitializationResponse data;
  static late UserResponse currentUser;
  static Response deviceStatus = const Response(
    code: StatusConstants.pending,
    status: StatusConstants.pending,
    message: 'Checking Device compatibility status',
  );

  static final db = Database();
  static final auth = AuthRepo();
  static bool isLinkedMoMoWalletClosed = false;

  static String get appId {
    if (Platform.isAndroid) {
      return Env.androidBundleId;
    }

    if (Platform.isIOS) {
      return Env.iosBundleId;
    }

    return Env.appId;
  }

  static Future<void> checkSecurity(
    void Function(String threat, Response<dynamic> error) callbackAction,
  ) async {
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: Env.appId,
        signingCertHashes: [
          Env.androidSigningCertHashes,
          Env.androidSigningCertHashUpload,
          Env.androidSigningCertHashDebug,
        ],
        // supportedStores: ['some.other.store'],
      ),
      iosConfig: IOSConfig(bundleIds: [Env.appId], teamId: Env.appleTeam),
      watcherMail: Env.watchEmail,
      isProd: kReleaseMode,
    );

    alert(String threadName, Response<dynamic> deviceStatus) {
      callbackAction(threadName, deviceStatus);
      db.add(key: 'threat', payload: {'name': threadName, 'message': deviceStatus.message});
    }

    // Setting up callbacks
    final callback = ThreatCallback(
      onAppIntegrity: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onAppIntegrity: Looks like your device configuration isn\'t compatible. Please ensure your device settings meet our requirements to access the app.',
          message:
              'Looks like your device configuration isn\'t compatible. Please ensure your device settings meet our requirements to access the app.',
        );

        alert('onAppIntegrity', deviceStatus);
      },
      onObfuscationIssues: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onObfuscationIssues: Sorry, your device is not fit to run this application.',
          message: 'Sorry, your device is not fit to run this application.',
        );

        alert('onObfuscationIssues', deviceStatus);
      },
      onDebug: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onDebug: We\'re unable to proceed due to your device setup. Please review your device settings to ensure they meet our requirements for app usage.',
          message:
              'We\'re unable to proceed due to your device setup. Please review your device settings to ensure they meet our requirements for app usage.',
        );

        alert('onDebug', deviceStatus);
      },
      onDeviceBinding: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onDeviceBinding: Uh-oh! Your device doesn\'t meet our compatibility criteria. Please check your device settings and try again.',
          message:
              'Uh-oh! Your device doesn\'t meet our compatibility criteria. Please check your device settings and try again.',
        );

        alert('onDeviceBinding', deviceStatus);
      },
      onDeviceID: () {},
      onHooks: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onHooks: It seems your device configuration isn\'t supported. Please make sure your device settings align with our requirements to access the app.',
          message:
              'It seems your device configuration isn\'t supported. Please make sure your device settings align with our requirements to access the app.',
        );

        alert('onHooks', deviceStatus);
      },
      onPasscode: () {},
      onPrivilegedAccess: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onPrivilegedAccess: Sorry, your device setup doesn\'t meet our compatibility requirements. Please adjust your device settings accordingly to use the app.',
          message:
              'Sorry, your device setup doesn\'t meet our compatibility requirements. Please adjust your device settings accordingly to use the app.',
        );

        alert('onPrivilegedAccess', deviceStatus);
      },
      // onSecureHardwareNotAvailable: () {
      //   deviceStatus = const Response(
      //     code: StatusConstants.error,
      //     status: StatusConstants.error,
      //     // message: 'onSecureHardwareNotAvailable: Sorry, your device doesn\'t meet our compatibility standards. Please adjust your device settings accordingly to use the app.',
      //     message: 'Sorry, your device doesn\'t meet our compatibility standards. Please adjust your device settings accordingly to use the app.',
      //   );

      //   alert('onSecureHardwareNotAvailable', deviceStatus);
      // },
      onSimulator: () {
        deviceStatus = const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onSimulator: Sorry, your device is our compatible with this application.',
          message: 'Sorry, your device is our compatible with this application.',
        );

        alert('onSimulator', deviceStatus);
      },
      onUnofficialStore: () => alert(
        'onUnofficialStore',
        const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onUnofficialStore: Sorry, This device cannot run this application. Contact us UMB Bank for assistance',
          message:
              'Sorry, This device cannot run this application. Contact us UMB Bank for assistance',
        ),
      ),
      // onDevMode: () => alert(
      //   'onDevMode',
      //   const Response(
      //     code: StatusConstants.error,
      //     status: StatusConstants.error,
      //     message: 'onDevMode: Sorry, This device cannot run this application. Contact us UMB Bank for assistance',
      //     message: 'Sorry, This device cannot run this application. Contact us UMB Bank for assistance',
      //   ),
      // ),
      // onSystemVPN: () => alert(
      //   'onSystemVPN',
      //   const Response(
      //     code: StatusConstants.error,
      //     status: StatusConstants.error,
      //     // message: 'onSystemVPN: Sorry, This device cannot run this application. Contact us UMB Bank for assistance',
      //     message: 'Sorry, This device cannot run this application. Contact us UMB Bank for assistance',
      //   ),
      // ),
      // onADBEnabled: () => alert(
      //   'onADBEnabled',
      //   const Response(
      //     code: StatusConstants.error,
      //     status: StatusConstants.error,
      //     message: 'onADBEnabled: Sorry, This device is not allowed to run this application. Contact us UMB Bank for assistance',
      //   ),
      // ),
      onMalware: (packageInfo) => alert(
        'onMalware',
        const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onMalware: Sorry, This device is not qualified to run this application. Contact us UMB Bank for assistance',
          message:
              'Sorry, This device is not qualified to run this application. Contact us UMB Bank for assistance',
        ),
      ),
      onMultiInstance: () => alert(
        'onMultiInstance',
        const Response(
          code: StatusConstants.error,
          status: StatusConstants.error,
          // message: 'onMultiInstance: Sorry, This device platform is not allow to run this application. Contact us UMB Bank for assistance',
          message:
              'Sorry, This device platform is not allow to run this application. Contact us UMB Bank for assistance',
        ),
      ),
    );

    // Attaching listener
    Talsec.instance.attachListener(callback);
    await Talsec.instance.start(config);
  }

  static Future<Response?> isThreatFound() async {
    return null;
    // final data = await db.read('threat');

    // if (data != null) {
    //   return Response(
    //     code: StatusConstants.error,
    //     status: StatusConstants.error,
    //     message:
    //         data["message"]?.toString() ??
    //         "You can not access this application. Contact UMB Bank for assistance",
    //   );
    // }
    // return null;
  }

  static Future<Response> deviceCheck() async {
    // if (kReleaseMode) {
    //   isPhysicalDevice() async {
    //     final device = await deviceInfo;
    //     if (!(device.isPhysicalDevice ?? false)) {
    //       deviceStatus = const Response(
    //         code: StatusConstants.error,
    //         status: StatusConstants.error,
    //         message: 'Sorry, your device is our compatible with this application.',
    //       );
    //       return deviceStatus;
    //     }
    //   }

    //   isMockLocation() async {
    //     final location = await locationInfo;
    //     if (location!.isMocked) {
    //       deviceStatus = const Response(
    //         code: StatusConstants.error,
    //         status: StatusConstants.error,
    //         message: 'We\'re unable to proceed due to your device setup. Please review your device settings to ensure they meet our requirements for app usage.',
    //       );
    //       return deviceStatus;
    //     }
    //   }

    //   await Future.wait([
    //     isPhysicalDevice(),
    //     // isMockLocation(),
    //   ]);
    // }

    // if (deviceStatus.status == StatusConstants.error) {
    //   return Future.error(deviceStatus);
    // }

    deviceStatus = const Response(
      code: StatusConstants.success,
      status: StatusConstants.success,
      message: 'This device is ready to run this application',
    );
    return deviceStatus;
  }

  static Future<void> getInfo() async {
    // ipInfo();
    _getCountries();

    Future.wait([locationInfo, initFirebase()]);

    await Future.wait([deviceInfo, packageInfo]);
  }

  static DeviceInfo get info {
    details = (_device ?? details).copyWith(
      latitude: location?.latitude.toString(),
      longitude: location?.longitude.toString(),
      build: _package?.buildNumber,
      version: _package?.version,
      channel: _package?.packageName,
      fcmToken: fcmToken,
    );

    return details;
  }

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
          // deviceId: ios.identifierForVendor,
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

  static Future<Position?> get locationInfo async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        listenToLocationStatusChange();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          listenToLocationStatusChange();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        listenToLocationStatusChange();
      }

      final currentLocation = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      );
      location = currentLocation;
      listenToLocationStatusChange();

      return location;
    } catch (ex) {
      logger.e(ex);
    }

    return location;
  }

  static void listenToLocationStatusChange() {
    if (_listeningToLocationStatus) return;

    _listeningToLocationStatus = true;
    locationStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      logger.i(status);
      if (status == ServiceStatus.disabled) {
        _onEnableLocation();
      } else if (askingUserForLocation == true) {
        askingUserForLocation = false;
        MyApp.navigatorKey.currentContext!.pop();
      }
    });
  }

  static Future<void> _onEnableLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Geolocator.requestPermission();
    }

    askingUserForLocation = true;
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) {
        return PopOver(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/img/location-pin.png', width: 200),
                const Text(
                  'Jack, where are you ?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Kindly enable your location to allow. Certain type of services will require your gps location',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(height: 20),
                FormButton(
                  onPressed: () {
                    if (!serviceEnabled) {
                      Geolocator.openLocationSettings();
                    } else {
                      Geolocator.openAppSettings();
                    }
                  },
                  text: 'Enable Your Location',
                ),
                const SizedBox(height: 10),
                FormButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    askingUserForLocation = false;
                    context.pop();
                  },
                  text: 'Set Later',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static List<CountryWithPhoneCode> _getCountries() {
    countries = CountryManager().countries
      ..sort((a, b) => (a.countryName ?? '').compareTo(b.countryName ?? ''));
    gh = AppUtil.countries.firstWhere((element) => element.countryCode == 'GH');
    currentCountry = gh;

    return countries;
  }

  static Future<String?> initFirebase() async {
    final int text = 1;
    if (text == 1) {
      return '';
    }

    final info = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    info.setAutomaticDataCollectionEnabled(true);
    info.setAutomaticResourceManagementEnabled(true);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    final fcm = FirebaseMessaging.instance;
    try {
      final _ = await fcm.getAPNSToken();

      fcmToken = await fcm.getToken();
      await fcm.setAutoInitEnabled(true);
    } catch (ex) {
      logger.i(ex);
    }

    FirebaseMessaging.onMessage.listen((message) async {
      MyApp.navigatorKey.currentContext!.read<PushNotificationBloc>().add(
        ReceivePushNotification(
          PushNotification(
            id: message.messageId,
            title: message.notification?.title ?? '',
            content: message.notification?.body ?? '',
            customData: message.data,
            image: message.notification?.title,
            read: false,
            sentTime: DateTime.now(),
          ),
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final record = PushNotification(
        id: event.messageId,
        title: event.notification?.title ?? '',
        content: event.notification?.body ?? '',
        customData: event.data,
        image: event.notification?.title,
        read: true,
        sentTime: DateTime.now(),
      );
      MyApp.navigatorKey.currentContext!.read<PushNotificationBloc>().add(
        ReceivePushNotification(record),
      );

      showDetails(record, MyApp.navigatorKey.currentContext!);
    });

    // FirebaseMessaging.onBackgroundMessage((message) async {
    //   logger.i(message);
    //   logger.i('onBackgroundMessage');
    //   final repo = PushNotificationRepo();
    //   repo.savePushNotification(
    //     PushNotification(
    //       id: message.messageId,
    //       title: message.notification?.title ?? '',
    //       content: message.notification?.body ?? '',
    //       customData: message.data,
    //       image: message.notification?.title,
    //       read: false,
    //       sentTime: message.sentTime,
    //     ),
    //   );
    // });

    logger.i('fcmToken: $fcmToken');

    _device = _device?.copyWith(fcmToken: fcmToken);

    return fcmToken;
  }

  static Widget get notificationIcon {
    return BlocBuilder<PushNotificationBloc, PushNotificationState>(
      builder: (context, state) {
        final notice = IconButton(
          onPressed: () {
            context.push(PushNotificationsPage.routeName);
          },
          icon: SvgPicture.asset('assets/img/notification.svg'),
        );

        final list = state is PushNotificationLoaded
            ? state.result.where((element) => element.read == false).length
            : 0;
        if (list == 0) {
          return notice;
        }

        final count = list > 9 ? '9+' : list.toString();

        return Badge(
          alignment: Alignment.topRight,
          textColor: Colors.white,
          label: Container(
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                count,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          smallSize: 19,
          largeSize: 19,
          padding: const EdgeInsets.only(left: 5, right: 5),
          backgroundColor: Colors.red,
          offset: Offset.zero,
          child: notice,
        );
      },
    );
  }

  static void showDetails(PushNotification record, BuildContext context) {
    context.read<PushNotificationBloc>().add(ReadPushNotification(record));
    final formatter = DateFormat('dd MMM, yyyy HH:mm');

    final messenger = Messenger();
    messenger.customAlert(
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.title ?? '',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
          ),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xff919195)),
              const SizedBox(width: 5),
              Text(
                formatter.format(record.sentTime ?? DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(record.content ?? '', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 40),
          FormButton(
            text: 'Ok',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  static void logout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      useSafeArea: true,
      builder: (context) {
        return Container(
          margin: .only(left: 10, right: 10, bottom: 10 + MediaQuery.of(context).padding.bottom),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: .center,
                children: [
                  const Text(
                    'Sign Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ThemeUtil.danger,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      iconSize: 18,

                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        maximumSize: const Size(32, 32),
                        minimumSize: const Size(32, 32),
                        backgroundColor: ThemeUtil.offWhite,
                        fixedSize: const Size(32, 32),
                        padding: .zero,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Are you sure you want to Sign Out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: ThemeUtil.subtitleGrey,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: FormOutlineButton(
                      height: 42,
                      onPressed: () {
                        context.pop();
                        context.read<AuthBloc>().add(const Logout());
                      },
                      text: 'Sign Out',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FormButton(
                      height: 42,
                      onPressed: () {
                        context.pop();
                      },
                      text: 'No, Cancel',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void forceUpdate(Response result) {
    MyApp.navigatorKey.currentContext!.read<AuthBloc>().add(ForceUpdate(result));
  }
}
