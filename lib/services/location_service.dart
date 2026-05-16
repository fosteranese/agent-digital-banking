import 'dart:async';

import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/main.dart';

/// Service for managing device location and geolocation.
///
/// Handles location permissions, GPS updates, and location service status monitoring.
class LocationService {
  static Position? location;
  static late StreamSubscription<Position> locationStream;
  static late StreamSubscription<ServiceStatus> locationStatusStream;
  static bool _listeningToLocationStatus = false;
  static bool askingUserForLocation = false;
  static List<CountryWithPhoneCode> countries = [];
  static late CountryWithPhoneCode currentCountry;
  static late CountryWithPhoneCode gh;

  /// Get the current user location async.
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

  /// Start listening to location service status changes.
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

  /// Show prompt to enable location when disabled.
  static Future<void> _onEnableLocation() async {
    askingUserForLocation = true;
    final location = await Geolocator.getServiceStatusStream().first;
    if (location == ServiceStatus.enabled) {
      MyApp.navigatorKey.currentContext!.pop();
    }
  }
}
