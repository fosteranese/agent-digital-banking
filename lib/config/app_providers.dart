import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sage_agent/blocs/activity/activity_bloc.dart';
import 'package:my_sage_agent/blocs/app/app_bloc.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/blocs/otp/otp_bloc.dart';
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

List<RepositoryProvider> buildRepositories() {
  return [
    RepositoryProvider(create: (_) => FblOnlineRepo()),
    RepositoryProvider(create: (_) => QuickFlowRepo()),
    RepositoryProvider(create: (_) => PaymentRepo()),
    RepositoryProvider(create: (_) => HistoryRepo()),
    RepositoryProvider(create: (_) => TeamRepo()),
    RepositoryProvider(create: (_) => ReversalRepo()),
    RepositoryProvider(create: (_) => GoogleMapRepo()),
  ];
}

List<BlocProvider> buildBlocs(BuildContext context) {
  return [
    BlocProvider(create: (context) => AppBloc()..add(DeviceStatusCheckEvent())),
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(create: (context) => SecuritySettingsBloc()),
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
    BlocProvider(
      create: (context) => PushNotificationBloc()..add(const LoadPushNotification()),
    ),
    BlocProvider(create: (context) => BiometricBloc()),
    BlocProvider(create: (context) => ActivityBloc()),
    BlocProvider(create: (context) => SetupBloc()),
    BlocProvider(create: (context) => OtpBloc()),
  ];
}
