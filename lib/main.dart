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
import 'package:my_sage_agent/config/app_theme.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/router/app_router.dart';
import 'package:my_sage_agent/ui/pages/app_error.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';

import 'package:my_sage_agent/blocs/activity/activity_bloc.dart';
import 'package:my_sage_agent/blocs/app/app_bloc.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/blocs/otp/otp_bloc.dart';
import 'package:my_sage_agent/blocs/process_flow/process_flow_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/blocs/security_settings/security_settings_bloc.dart';
import 'package:my_sage_agent/blocs/setup/setup_bloc.dart';
import 'package:my_sage_agent/data/repository/fbl_online.repo.dart';
import 'package:my_sage_agent/data/repository/google_map.repo.dart';
import 'package:my_sage_agent/data/repository/history.repo.dart';
import 'package:my_sage_agent/data/repository/payment.repo.dart';
import 'package:my_sage_agent/data/repository/quickflow.repo.dart';
import 'package:my_sage_agent/data/repository/reversal.repo.dart';
import 'package:my_sage_agent/data/repository/team.repo.dart';

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
  Response<dynamic>? _error;

  @override
  void initState() {
    _securityCheck();
    super.initState();
  }

  void _securityCheck() {
    AppUtil.checkSecurity((threat, error) {
      _error = error;
      logger.e(threat);
      MyApp.navigatorKey.currentContext!.go(AppErrorPage.routeName, extra: _error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FblOnlineRepo()),
        RepositoryProvider(create: (_) => QuickFlowRepo()),
        RepositoryProvider(create: (_) => PaymentRepo()),
        RepositoryProvider(create: (_) => HistoryRepo()),
        RepositoryProvider(create: (_) => TeamRepo()),
        RepositoryProvider(create: (_) => ReversalRepo()),
        RepositoryProvider(create: (_) => GoogleMapRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AppBloc()..add(DeviceStatusCheckEvent())),
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => SecuritySettingsBloc()),
          BlocProvider(
            create: (context) => RetrieveDataBloc(
              fblOnlineRepo: context.read<FblOnlineRepo>(),
              quickflow: context.read<QuickFlowRepo>(),
              paymentRepo: context.read<PaymentRepo>(),
              historyRepo: context.read<HistoryRepo>(),
              teamRepo: context.read<TeamRepo>(),
              reversalRepo: context.read<ReversalRepo>(),
              mapRepo: context.read<GoogleMapRepo>(),
            ),
          ),
          BlocProvider(create: (_) => PushNotificationBloc()..add(const LoadPushNotification())),
          BlocProvider(create: (_) => BiometricBloc()),
          BlocProvider(create: (_) => ActivityBloc()),
          BlocProvider(create: (_) => SetupBloc()),
          BlocProvider(create: (_) => OtpBloc()),
          BlocProvider(create: (_) => ProcessFlowBloc()),
        ],
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
    );
  }

  Widget _buildApp(_, Widget? child) {
    return AppNavigationListener(child: child!);
  }

  @override
  void dispose() {
    AppUtil.locationStream.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
