import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/app/app_bloc.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/pages/app_error.page.dart';
import 'package:my_sage_agent/ui/pages/login/existing_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/new_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/update.page.dart';

class AppNavigationListener extends StatelessWidget {
  final Widget child;

  const AppNavigationListener({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listener: _handleAppStateChange,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthStateChange,
        ),
      ],
      child: child,
    );
  }

  void _handleAppStateChange(BuildContext context, AppState state) {
    MyApp.routerRefreshNotifier.value = const Uuid().v4();

    if (state is AppError) {
      _navigateToError(context, state.result);
      FlutterNativeSplash.remove();
      return;
    }

    context.read<BiometricBloc>().add(const RetrieveBiometricSettings());

    if (state is NewDevice) {
      _navigateToNewDeviceLogin(context);
      FlutterNativeSplash.remove();
      return;
    }

    if (state is UserExistOnDevice) {
      _navigateToExistingDeviceLogin(context, extra: true);
      FlutterNativeSplash.remove();
      return;
    }

    if (state is ExistingDevice) {
      _navigateToNewDeviceLogin(context);
      FlutterNativeSplash.remove();
      return;
    }
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    MyApp.routerRefreshNotifier.value = const Uuid().v4();

    if (state is LoggedOut) {
      _navigateToExistingDeviceLogin(context, extra: false);
      return;
    }

    if (state is UpdateForced) {
      FlutterNativeSplash.remove();
      _navigateToUpdate(context, state.result);
      return;
    }
  }

  void _navigateToError(BuildContext context, dynamic error) {
    context.go(AppErrorPage.routeName, extra: error);
  }

  void _navigateToNewDeviceLogin(BuildContext context) {
    context.go(NewDeviceLoginPage.routeName);
  }

  void _navigateToExistingDeviceLogin(BuildContext context, {required bool extra}) {
    context.go(ExistingDeviceLoginPage.routeName, extra: extra);
  }

  void _navigateToUpdate(BuildContext context, dynamic result) {
    context.go(UpdatePage.routeName, extra: result);
  }
}
