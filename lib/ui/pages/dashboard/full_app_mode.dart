import 'dart:async';
import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/ui/components/dashboard/dashboard_actions.dart';
import 'package:my_sage_agent/ui/components/dashboard/dashboard_recent_transactions.dart';
import 'package:my_sage_agent/ui/components/dashboard/dashboard_stats.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

class FullAppMode extends StatefulWidget {
  const FullAppMode({super.key});

  @override
  State<FullAppMode> createState() => _FullAppModeState();
}

class _FullAppModeState extends State<FullAppMode> {
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
                titleSpacing: 10,
                title: InkWell(
                  enableFeedback: true,
                  onTap: () {
                    context.push(ProfilePage.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: .start,
                    children: [
                      Builder(
                        builder: (context) {
                          if (AppUtil.currentUser.profilePicture?.isNotEmpty ?? false) {
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: MemoryImage(
                                base64Decode(AppUtil.currentUser.profilePicture!),
                              ),
                            );
                          }

                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset('assets/img/user.svg', width: double.maxFinite),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: "Welcome\n"),
                              TextSpan(
                                text: AppUtil.currentUser.user?.shortName ?? 'Sage Agent',
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
                    ],
                  ),
                ),
                centerTitle: false,
                actions: [AppUtil.notificationIcon],
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
                  slivers: [DashboardStats(), DashboardActions(), DashboardRecentTransactions()],
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
