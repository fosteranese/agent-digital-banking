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

import 'package:my_sage_agent/blocs/account/account_bloc.dart';
import 'package:my_sage_agent/blocs/activity/activity_bloc.dart';
import 'package:my_sage_agent/blocs/app/app_bloc.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/blocs/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:my_sage_agent/blocs/bulk_payment/bulk_payment_bloc.dart';
import 'package:my_sage_agent/blocs/collection/collection_bloc.dart';
import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/history/history_bloc.dart';
import 'package:my_sage_agent/blocs/infra/infra_bloc.dart';
import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/blocs/otp/otp_bloc.dart';
import 'package:my_sage_agent/blocs/payee/payee_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/blocs/security_settings/security_settings_bloc.dart';
import 'package:my_sage_agent/blocs/setup/setup_bloc.dart';
import 'package:my_sage_agent/data/database/db.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/repository/fbl_online.repo.dart';
import 'package:my_sage_agent/data/repository/payment.repo.dart';
import 'package:my_sage_agent/data/repository/quickflow.repo.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/router/app_router.dart';
import 'package:my_sage_agent/ui/pages/app_error.page.dart';
import 'package:my_sage_agent/ui/pages/login/existing_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/new_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/update.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

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
  // static final dashboardNav = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer _timer;
  var _threadDetected = false;
  Response<dynamic>? _error;

  @override
  void initState() {
    // _securityCheck();
    super.initState();
    // isMounted = true;
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
      providers: [
        RepositoryProvider(create: (_) => FblOnlineRepo()),
        RepositoryProvider(create: (_) => QuickFlowRepo()),
        RepositoryProvider(create: (_) => PaymentRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBloc()..add(DeviceStatusCheckEvent())),
          BlocProvider(create: (context) => BottomNavBarBloc()),
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => SecuritySettingsBloc()),
          BlocProvider(create: (context) => PaymentsBloc()),
          BlocProvider(create: (context) => GeneralFlowBloc()),
          BlocProvider(
            create: (context) => RetrieveDataBloc(
              fblOnlineRepo: context.read<FblOnlineRepo>(),
              quickflow: context.read<QuickFlowRepo>(),
              paymentRepo: context.read<PaymentRepo>(),
            ),
          ),
          BlocProvider(create: (context) => AccountBloc()),
          BlocProvider(create: (context) => PayeeBloc()),
          BlocProvider(
            create: (context) => PushNotificationBloc()..add(const LoadPushNotification()),
          ),
          BlocProvider(create: (context) => BiometricBloc()),
          BlocProvider(create: (context) => ActivityBloc()),
          BlocProvider(create: (context) => BulkPaymentBloc()),
          BlocProvider(create: (context) => InfraBloc()),
          BlocProvider(create: (context) => SetupBloc()),
          BlocProvider(create: (context) => OtpBloc()),
          BlocProvider(create: (context) => HistoryBloc()),
        ],
        child: MaterialApp.router(
          title: 'Agent Digital Banking',
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
          theme: ThemeData(
            fontFamily: PrimaryTextStyle().fontFamily,
            fontFamilyFallback: PrimaryTextStyle().fontFamilyFallback,
            primaryColorDark: const Color(0xff191443),
            primaryColorLight: const Color(0xffF2F8FF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              primary: Colors.black,
              secondary: ThemeUtil.secondaryColor,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            textTheme: TextTheme(
              bodySmall: PrimaryTextStyle(
                color: const Color(0xff919195),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
              displaySmall: PrimaryTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: const Color(0xff54534A),
              ),
              labelSmall: PrimaryTextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xff242424),
              ),
              titleSmall: PrimaryTextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              headlineSmall: PrimaryTextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              bodyMedium: PrimaryTextStyle(
                color: const Color(0xff242424),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              displayMedium: PrimaryTextStyle(
                color: const Color(0xff54534A),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labelMedium: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              headlineMedium: PrimaryTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff828282),
              ),
              titleMedium: PrimaryTextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              headlineLarge: PrimaryTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xff010203),
              ),
            ),
          ),
          routerConfig: router,
          builder: _buildApp,
        ),
      ),
    );
  }

  Widget _buildApp(BuildContext context, Widget? child) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (_threadDetected || state is AppError) {
              final error = state is AppError ? state.result : _error;
              MyApp.navigatorKey.currentContext!.go(AppErrorPage.routeName, extra: error);

              FlutterNativeSplash.remove();
              return;
            }

            context.read<BiometricBloc>().add(const RetrieveBiometricSettings());

            if (state is NewDevice) {
              MyApp.navigatorKey.currentContext!.go(NewDeviceLoginPage.routeName);

              FlutterNativeSplash.remove();
              return;
            }

            if (state is UserExistOnDevice) {
              MyApp.navigatorKey.currentContext!.go(ExistingDeviceLoginPage.routeName, extra: true);
              FlutterNativeSplash.remove();
              return;
            }

            if (state is ExistingDevice) {
              MyApp.navigatorKey.currentContext!.go(NewDeviceLoginPage.routeName);
              FlutterNativeSplash.remove();
              return;
            }

            if (state is AppError) {
              MyApp.navigatorKey.currentContext!.go(AppErrorPage.routeName, extra: state.result);
              FlutterNativeSplash.remove();
              return;
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoggedOut) {
              MyApp.navigatorKey.currentContext!.go(
                ExistingDeviceLoginPage.routeName,
                extra: false,
              );
              return;
            }

            if (state is UpdateForced) {
              FlutterNativeSplash.remove();
              MyApp.navigatorKey.currentContext!.go(UpdatePage.routeName, extra: state.result);
              return;
            }
          },
        ),
      ],
      child: child!,
    );
  }

  @override
  void dispose() {
    AppUtil.locationStream.cancel();
    _timer.cancel();
    super.dispose();
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
//   }
// }
