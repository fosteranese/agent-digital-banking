import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/activity/activity_bloc.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/logger.dart';

class SessionTimeout extends StatefulWidget {
  const SessionTimeout({super.key, required this.child});
  final Widget child;

  @override
  State<SessionTimeout> createState() => _SessionTimeoutState();
}

class _SessionTimeoutState extends State<SessionTimeout> with WidgetsBindingObserver {
  late Timer _timer;
  bool forceLogout = false;
  final navigatorKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _initializeTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 500), (_) => _logOutUser());
  }

  void _logOutUser() {
    _timer.cancel();
    setState(() {
      forceLogout = true;
    });
  }

  // You'll probably want to wrap this function in a debounce
  void _handleUserInteraction() {
    // logger.i("_handleUserInteraction");
    _timer.cancel();
    _initializeTimer();
  }

  void navToHomePage(BuildContext context) {
    context.read<AuthBloc>().add(const Logout());
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<ActivityBloc>().add(PerformActivityEvent());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Conservatively set a timer on all three
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (forceLogout) {
      logger.i("ForceLogout is $forceLogout");
      navToHomePage(context);
    }
    return BlocListener<ActivityBloc, ActivityState>(
      listener: (context, state) {
        if (state is ActionJustPerformed) {
          _handleUserInteraction();
        }
      },
      child: Listener(
        onPointerDown: (_) => context.read<ActivityBloc>().add(PerformActivityEvent()),
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
