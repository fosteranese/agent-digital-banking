import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/ui/components/dashboard/supervisor_dashboard_actions.dart';
import 'package:my_sage_agent/ui/components/dashboard/supervisor_dashboard_recent_transactions.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/ui/pages/request/requests.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  final _controller = ScrollController();
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  static bool isRefreshing = false;

  void _stopRefresh(BuildContext context) {
    if (!isRefreshing) return;
    isRefreshing = false;
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();
    isRefreshing = true;
    context.read<AuthBloc>().add(const RefreshUserData());

    context.read<RetrieveDataBloc>().add(
      RetrieveCollectionEvent(
        id: Uuid().v4(),
        action: 'RetrieveCollectionEvent',
        skipSavedData: true,
      ),
    );

    context.read<RetrieveDataBloc>().add(
      RetrievePendingReversalsEvent(
        id: Uuid().v4(),
        action: 'RetrievePendingReversalsEvent',
        skipSavedData: false,
      ),
    );

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!isRefreshing) {
        timer.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }

  @override
  void initState() {
    context.read<PushNotificationBloc>().add(const LoadPushNotification());

    context.read<RetrieveDataBloc>().add(
      RetrievePendingReversalsEvent(
        id: Uuid().v4(),
        action: 'RetrievePendingReversalsEvent',
        skipSavedData: false,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          _stopRefresh(context);
          return;
        }

        if (state is RefreshUserDataFailed) {
          _stopRefresh(context);
          return;
        }
      },
      buildWhen: (previous, current) => current is LoggedIn,
      builder: (context, state) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                title: InkWell(
                  enableFeedback: true,
                  onTap: () {
                    context.push(ProfilePage.routeName);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(text: "Welcome\n"),
                        TextSpan(
                          text: AppUtil.currentUser!.user?.shortName ?? 'Sage Agent',
                          style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                      style: PrimaryTextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                centerTitle: false,
                actions: [AppUtil.notificationIcon],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Padding(
                    padding: const .symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        Expanded(
                          child: Text(
                            FormatterUtil.fullDateAlt(DateTime.now()),
                            style: PrimaryTextStyle(
                              fontSize: 14,
                              fontWeight: .w400,
                              color: ThemeUtil.flat,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          height: 30,
                          child: FormOutlineButton(
                            padding: .symmetric(horizontal: 12, vertical: 6),
                            onPressed: () {
                              context.push(RequestsPage.routeName);
                            },
                            shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                            text: 'View Requests',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: EasyRefresh(
                header: MaterialHeader(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
                key: _refreshController,
                onRefresh: _onRefresh,
                triggerAxis: Axis.vertical,
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [SupervisorDashboardActions(), SupervisorDashboardRecentTransactions()],
                ),
              ),
              extendBody: false,
            ),
          ],
        );
      },
    );
  }
}
