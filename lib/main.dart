import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:my_sage_agent/config/app_navigation_listener.dart';
import 'package:my_sage_agent/config/app_providers.dart';
import 'package:my_sage_agent/config/app_theme.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/router/app_router.dart';
import 'package:my_sage_agent/ui/pages/app_error.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await Hive.initFlutter();
      await Database.init();
      await init();

      runApp(const MyApp());
    },
    (dynamic error, dynamic stack) {
      developer.log("Something went wrong!", error: error, stackTrace: stack);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final routerRefreshNotifier = ValueNotifier('');

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;
  var _threadDetected = false;
  Response<dynamic>? _error;

  @override
  void initState() {
    _securityCheck();
    super.initState();
  }

  void _securityCheck() {
    AppUtil.checkSecurity((threat, error) {
      _threadDetected = true;
      _error = error;
      logger.e(threat);
      MyApp.navigatorKey.currentContext!.go(AppErrorPage.routeName, extra: _error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: buildRepositories(),
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: buildBlocs(context),
        child: MaterialApp.router(
          title: 'MySage Agent',
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            // RefreshLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null && supportedLocales.isEmpty) {
              return null;
            }

            return supportedLocales.firstWhere(
              (item) => item.languageCode == locale?.languageCode,
              orElse: () {
                return supportedLocales.firstWhere(
                  (el) {
                    return el.languageCode == 'en';
                  },
                  orElse: () {
                    return supportedLocales.first;
                  },
                );
              },
            );
          },
          theme: AppTheme.lightTheme,
          routerConfig: router,
          builder: _buildApp,
        ),
        ),
      ),
    );
  }

  Widget _buildApp(BuildContext context, Widget? child) {
    return AppNavigationListener(child: child!);
  }

  @override
  void dispose() {
    AppUtil.locationStream.cancel();
    _timer?.cancel();
    super.dispose();
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
//   }
// }
