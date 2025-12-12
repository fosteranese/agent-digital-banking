import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/history/history_bloc.dart';
import 'package:my_sage_agent/blocs/notification/notification_bloc.dart';
import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/account/source.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/accounts_carousel.dart';
import 'package:my_sage_agent/ui/components/advertisement.dart';
import 'package:my_sage_agent/ui/components/fx_rate_horizontal_list.dart';
import 'package:my_sage_agent/ui/components/quick_access_card.cm.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/actions.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/process_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum FavouriteTypes { favourites, linkWallet, empty }

class FullAppMode extends StatefulWidget {
  const FullAppMode({super.key});

  @override
  State<FullAppMode> createState() => _FullAppModeState();
}

class _FullAppModeState extends State<FullAppMode> {
  final _controller = ScrollController();
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  final _viewAccounts = ValueNotifier(false);
  final _displayBalance = ValueNotifier(false);
  static bool isRefreshing = false;
  final _linkWallet = '1AD40BE3-4D10-4CE1-AC51-A168348055DA';

  void _stopRefresh(BuildContext context) {
    if (!isRefreshing) return;
    isRefreshing = false;
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();
    isRefreshing = true;
    context.read<AuthBloc>().add(const RefreshUserData());

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
    context.read<HistoryBloc>().add(const LoadHistory(true));

    super.initState();
  }

  List<ActivityDatum> get _activities {
    return AppUtil.currentUser.activities ?? [];
  }

  FavouriteTypes get _showDisplayFavourite {
    if (AppUtil.currentUser.recentActivity?.isEmpty ?? true) {
      return FavouriteTypes.empty;
    }

    if (AppUtil.currentUser.recentActivity!.length > 1) {
      return FavouriteTypes.favourites;
    }

    if (AppUtil.isLinkedMoMoWalletClosed) {
      return FavouriteTypes.empty;
    }

    if (AppUtil.currentUser.recentActivity!.first.formId?.toLowerCase() == _linkWallet.toLowerCase()) {
      return FavouriteTypes.linkWallet;
    }

    return FavouriteTypes.favourites;
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
        final accounts =
            AppUtil.currentUser.customerData
                ?.map((account) {
                  return account.sources;
                })
                .expand((element) => element ?? <Source>[])
                .toList() ??
            <Source>[];

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Scaffold(
              backgroundColor: Color(0xffF8F8F8),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                actionsPadding: EdgeInsets.only(right: 20),
                title: InkWell(
                  enableFeedback: true,
                  onTap: () {
                    context.push(ProfilePage.routeName);
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: Offset(0, 2))],
                        ),
                        child: Builder(
                          builder: (context) {
                            if (AppUtil.currentUser.profilePicture?.isNotEmpty ?? false) {
                              return CircleAvatar(backgroundColor: Color(0xffD9D9D9), backgroundImage: MemoryImage(base64Decode(AppUtil.currentUser.profilePicture!)));
                            }

                            return CircleAvatar(backgroundColor: Color(0xffD9D9D9), child: SvgPicture.asset('assets/img/user.svg'));
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: "Welcome\n"),
                              TextSpan(
                                text: AppUtil.currentUser.user?.shortName ?? 'Royalty',
                                style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                            style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: false,
                actions: [
                  AppUtil.notificationIcon,
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Color(0xffF8F8F8)),
                    onPressed: () {
                      AppUtil.logout();
                    },
                    icon: SvgPicture.asset('assets/img/logout.svg'),
                  ),
                ],
              ),
              body: EasyRefresh(
                header: MaterialHeader(backgroundColor: Theme.of(context).primaryColor, color: Colors.white),
                key: _refreshController,
                onRefresh: _onRefresh,
                triggerAxis: Axis.vertical,
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: AnimatedContainer(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
                          padding: EdgeInsets.all(18),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                          height: 154,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: ThemeUtil.secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: AssetImage('assets/img/bg.png'), fit: BoxFit.cover, opacity: 0.4),
                          ),
                          child: AccountsCarousel(accounts: accounts, controller: _controller, displayBalance: _displayBalance, viewAccounts: _viewAccounts),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Color(0xffF8F8F8),
                        padding: const EdgeInsets.only(
                          // left: 20,
                          // right: 20,
                          top: 15,
                          bottom: 15,
                        ),
                        child: Builder(
                          builder: (context) {
                            switch (_showDisplayFavourite) {
                              case FavouriteTypes.favourites:
                                return _buildFavouriteForms();

                              case FavouriteTypes.linkWallet:
                                return _buildLinkMoMoWallet(context);

                              case FavouriteTypes.empty:
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/img/open-trash.svg'),
                                    const SizedBox(height: 10),
                                    Text(
                                      'You have no recently used transaction',
                                      style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xff919195)),
                                    ),
                                  ],
                                );
                            }
                          },
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Quick Access',
                                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      context.push(QuickActionsPage.routeName);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'See All',
                                          style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff010101)),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(Icons.arrow_circle_right),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Builder(
                                builder: (context) {
                                  if (AppUtil.currentUser.recentActivity == null) {
                                    return const SizedBox(height: 10);
                                  }
                                  final activities = _activities.where((element) => element.activity!.showOnDashboard == 1 && element.activity!.activityId != AppUtil.currentUser.scanToPay!.activity!.activityId!).take(4).toList();

                                  final user = AppUtil.currentUser;

                                  return SizedBox(
                                    height: 110,
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: (MediaQuery.of(context).size.width / 2) / 55,
                                      physics: NeverScrollableScrollPhysics(),
                                      primary: false,
                                      children: [
                                        ...activities.map((activity) {
                                          final img = '${user.imageBaseUrl}${user.imageDirectory}/${activity.activity?.icon}';
                                          return QuickAccessCard(
                                            img: img,
                                            title: activity.activity?.activityName ?? '',

                                            onTap: () {
                                              context.push(ActionsPage.routeName, extra: {'activity': activity, 'amDoing': AmDoing.transaction});
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // const SizedBox(height: 20),
                            if (AppUtil.data.adverts?.isNotEmpty ?? false) SizedBox(height: 20),
                            if (AppUtil.data.adverts?.isNotEmpty ?? false) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Advertisement()),
                            const FXRateHorizontalList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              extendBody: false,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLinkMoMoWallet(BuildContext context) {
    final item = AppUtil.currentUser.recentActivity!.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FilledButton(
        style: FilledButton.styleFrom(
          fixedSize: Size(double.maxFinite, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(20), bottomRight: Radius.circular(8), bottomLeft: Radius.circular(20)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.only(left: 10, right: 16),
        ),
        onPressed: () {
          context.push(
            ProcessFormPage.routeName,
            extra: {
              'form': GeneralFlowForm(activityType: ActivityTypesConst.fblOnline, formName: item.formName, categoryId: item.activityId, formId: item.formId),
              'amDoing': AmDoing.transaction,
              'activity': ActivityDatum(
                activity: Activity(activityId: item.activityId, activityType: item.activityType, accessType: item.activityType),
              ),
            },
          );
        },
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(top: 18), child: Image.asset('assets/img/wallet.png', width: 86, height: 86)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Link MoMo Wallet',
                    style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  Text('Access easier payments.', style: PrimaryTextStyle(fontSize: 14, color: Colors.white)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  AppUtil.isLinkedMoMoWalletClosed = !AppUtil.isLinkedMoMoWalletClosed;
                });
              },
              child: SvgPicture.asset('assets/img/close.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildFavouriteForms() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Favourites',
                style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 70,
          width: double.maxFinite,
          child: PageView.builder(
            padEnds: false,
            controller: PageController(viewportFraction: AppUtil.currentUser.recentActivity!.length != 1 ? 0.75 : 1),
            itemCount: AppUtil.currentUser.recentActivity!.length,
            itemBuilder: (context, index) {
              final user = AppUtil.currentUser;
              final item = AppUtil.currentUser.recentActivity![index];
              final img = item.iconPath ?? '${user.imageBaseUrl}${user.imageDirectory}/${item.icon}';

              return Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.only(left: 15, right: index != (AppUtil.currentUser.recentActivity!.length - 1) ? 0 : 15),
                width: double.infinity,
                key: ValueKey(index),
                decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xffFAEFD5) : Color(0x91F7C15A), borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    context.push(
                      ProcessFormPage.routeName,
                      extra: {
                        'form': GeneralFlowForm(activityType: item.activityType, formName: item.formName, categoryId: item.activityId, formId: item.formId),
                        'amDoing': AmDoing.transaction,
                        'activity': ActivityDatum(
                          activity: Activity(activityId: item.activityId, activityType: item.activityType, accessType: item.activityType),
                        ),
                      },
                    );
                  },
                  contentPadding: EdgeInsets.symmetric(
                    // vertical:
                    //     10,
                    horizontal: 15,
                  ),
                  leading: CachedNetworkImage(
                    imageUrl: img,
                    width: 24,
                    height: 24,
                    placeholder: (context, url) => Icon(Icons.circle_outlined, color: Colors.black),
                    errorWidget: (context, url, error) => Icon(Icons.circle_outlined, color: Colors.black, size: 20),
                  ),
                  title: Text(
                    item.formName ?? '',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: PrimaryTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  subtitle: Text(
                    item.activityName ?? '',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: PrimaryTextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff54534A)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // void _openQrCodeMenu() {
  //   QrCodeUtil.openScanToPay(
  //     scanToPay: AppUtil.currentUser.scanToPay!,
  //     iconBaseUrl:
  //         '${AppUtil.currentUser.imageBaseUrl}${AppUtil.currentUser.imageDirectory}',
  //   );
  //   return;
  // }

  // ActivityDatum get _scanToPay {
  //   return _activities.firstWhere(
  //     (e) =>
  //         e.activity!.activityId ==
  //         AppUtil
  //             .currentUser
  //             .scanToPay!
  //             .activity!
  //             .activityId,
  //   );
  // }
}
