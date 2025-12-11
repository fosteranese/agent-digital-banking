import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/collection/collection_bloc.dart';
import '../../../blocs/general_flow/general_flow_bloc.dart';
import '../../../utils/service.util.dart';
import '../../components/session_tracker.dart';
import '../quick_actions.page.dart';
import 'full_app_mode.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const routeName = '/dashboard';

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SessionTimeout(
      child: MultiBlocListener(
        listeners: [
          BlocListener<PaymentsBloc, PaymentsState>(
            listener: (context, state) =>
                ServiceUtil.paymentsListener(
                  context: context,
                  state: state,
                  routeName: DashboardPage.routeName,
                  amDoing: AmDoing.transaction,
                ),
          ),
          BlocListener<GeneralFlowBloc, GeneralFlowState>(
            listener: (context, state) {
              ServiceUtil.generalFlowListener(
                context: context,
                state: state,
                routeName: DashboardPage.routeName,
                amDoing: AmDoing.transaction,
              );
            },
          ),
        ],
        child: const FullAppMode(),
      ),
    );
  }
}
