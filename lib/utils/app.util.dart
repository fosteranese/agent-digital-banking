// Façade for accessing app utilities and services
//
// This file re-exports common app services for backward compatibility.
// For direct service access, import the individual service files.

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/device_info.dart';
import 'package:my_sage_agent/data/models/push_notification.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/user_response.dart';
import 'package:my_sage_agent/data/repository/auth.repo.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/services/auth_service.dart';
import 'package:my_sage_agent/services/device_service.dart';
import 'package:my_sage_agent/services/location_service.dart';
import 'package:my_sage_agent/services/notification_service.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sage_agent/data/database/db.dart';

/// Façade for app utilities.
///
/// Provides backward-compatible access to device, location, auth, and notification services.
class AppUtil {
  // ============ Device Service Properties ============
  static String get appId => DeviceService.appId;

  static DeviceInfo get details => DeviceService.details;

  static DeviceInfo get info => DeviceService.info;

  static Future<DeviceInfo> get deviceInfo => DeviceService.deviceInfo;

  static Future<dynamic> get packageInfo => DeviceService.packageInfo;

  // ============ Location Service Properties ============
  static Position? get location => LocationService.location;

  static bool get askingUserForLocation => LocationService.askingUserForLocation;

  static set askingUserForLocation(bool value) => LocationService.askingUserForLocation = value;

  static Future<Position?> get locationInfo => LocationService.locationInfo;

  static void listenToLocationStatusChange() => LocationService.listenToLocationStatusChange();

  static List get countries => LocationService.countries;

  static dynamic get currentCountry => LocationService.currentCountry;

  static dynamic get gh => LocationService.gh;

  static dynamic get locationStream => LocationService.locationStream;

  static dynamic get locationStatusStream => LocationService.locationStatusStream;

  // ============ Auth Service Properties ============
  static Response get deviceStatus => AuthService.deviceStatus;

  static set deviceStatus(Response status) => AuthService.deviceStatus = status;

  static Future<Response?> isThreatFound() => AuthService.isThreatFound();

  static Future<Response> deviceCheck() => AuthService.deviceCheck();

  static Future<void> checkSecurity(
    void Function(String threat, Response<dynamic> error) callbackAction,
  ) =>
      AuthService.checkSecurity(callbackAction);

  static UserResponse? get currentUser => AuthService.currentUser;

  static set currentUser(UserResponse? user) => AuthService.currentUser = user;

  static dynamic get data => AuthService.data;

  static set data(dynamic value) => AuthService.data = value;

  static Database get db => AuthService.db;

  static AuthRepo get auth => AuthService.auth;

  static String? get fcmToken => AuthService.fcmToken;

  static set fcmToken(String? token) => AuthService.fcmToken = token;

  // ============ Notification Service Properties ============
  static Future<String?> initFirebase() => NotificationService.initFirebase();

  static Widget get notificationIcon => NotificationService.notificationIcon;

  static void showDetails(PushNotification record, BuildContext context) =>
      NotificationService.showDetails(record, context);

  // ============ Auth/Logout ============
  static void logout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      useSafeArea: true,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10 + MediaQuery.of(context).padding.bottom,
          ),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Sign Out',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(
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
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
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

  // ============ Initialization ============
  static Future<void> getInfo() async {
    await Future.wait([
      DeviceService.deviceInfo,
      DeviceService.packageInfo,
      LocationService.locationInfo,
      NotificationService.initFirebase(),
    ]);
  }
}
