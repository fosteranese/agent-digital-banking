import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import 'package:agent_digital_banking/blocs/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:agent_digital_banking/blocs/bulk_payment/bulk_payment_bloc.dart';
import 'package:agent_digital_banking/blocs/general_flow/general_flow_bloc.dart';
import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/data/models/bulk_payment/bulk_payment_groups.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/logger.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/ui/components/avatar.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/components/item.dart';
import 'package:agent_digital_banking/ui/layouts/main.layout.dart';
import 'package:agent_digital_banking/ui/pages/bulk_payments/bulk_payment_group_details.page.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/utils/list.util.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/navigator.util.dart';
import 'package:agent_digital_banking/utils/service.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class BulkPaymentGroupsPage extends StatefulWidget {
  const BulkPaymentGroupsPage(this.action, {super.key});
  static const routeName = '/bulk-payment-groups';
  final ActivityDatum action;

  @override
  State<BulkPaymentGroupsPage> createState() => _BulkPaymentGroupsPageState();
}

class _BulkPaymentGroupsPageState extends State<BulkPaymentGroupsPage> {
  final _controller = TextEditingController();
  late Response<BulkPaymentGroups> _sourceList;
  List<Groups> _list = [];
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  late final _bloc = context.read<BulkPaymentBloc>();
  final _loader = Loader();
  bool _moving = false;

  @override
  void initState() {
    _bloc.add(const RetrieveBulkPaymentGroups(BulkPaymentGroupsPage.routeName));
    _sourceList = _bloc.groups;
    _list = _sourceList.data?.groups ?? [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      refreshController: _refreshController,
      onRefresh: () async {
        _bloc.add(const SilentRetrieveBulkPaymentGroups(BulkPaymentGroupsPage.routeName));
      },
      showBackBtn: true,
      title: widget.action.activity?.activityName ?? '',
      bottom: PreferredSize(
        preferredSize: const Size(double.maxFinite, 80),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: FormInput(
            controller: _controller,
            inputHeight: 40,
            prefix: const Icon(Icons.search),
            placeholder: 'Search',
            bottomSpace: 0,
            color: const Color(0xffF3F4F9),
            contentPadding: EdgeInsets.zero,
            onChange: (value) {
              _search(value, _sourceList.data?.groups ?? []);
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xffD9DADB), width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(width: 1, color: Color(0xffD9DADB)),
              ),
              suffix: _controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _controller.text = '';
                        _search('', _sourceList.data?.groups ?? []);
                      },
                      icon: const Icon(Icons.close),
                    )
                  : null,
            ),
          ),
        ),
      ),
      sliver: SliverList.list(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.white,
            child: MultiBlocListener(
              listeners: ServiceUtil.onShortcutListeners(nav: MyApp.navigatorKey.currentState, routeName: BulkPaymentGroupsPage.routeName, amDoing: AmDoing.createBulkPaymentGroup),
              child: BlocConsumer<BulkPaymentBloc, BulkPaymentState>(
                listener: (context, state) {
                  if (state is BulkPaymentGroupsRetrieved) {
                    _sourceList = state.result;
                    _search('', _sourceList.data?.groups ?? [], shouldSetState: false);

                    MainLayout.stopRefresh(context);
                    return;
                  }

                  if (state is BulkPaymentGroupsRetrievedSilently) {
                    _sourceList = state.result;
                    _search('', _sourceList.data?.groups ?? [], shouldSetState: false);

                    MainLayout.stopRefresh(context);
                    return;
                  }

                  if (state is RetrieveBulkPaymentGroupsError || state is SilentRetrieveBulkPaymentGroupsError) {
                    MainLayout.stopRefresh(context);
                    if (_moving) {
                      _moving = false;
                      _loader.stop();

                      Future.delayed(const Duration(seconds: 0), () {
                        NavigatorUtil.pop(context, routeNames: ['/', DashboardPage.routeName, BulkPaymentGroupsPage.routeName], nav: MyApp.navigatorKey.currentState!);
                      });
                    }

                    return;
                  }

                  if (state is DeletingBulkPaymentGroup) {
                    _loader.start('Deleting');
                    return;
                  }

                  if (state is BulkPaymentGroupDeleted) {
                    _loader.stop();
                    _bloc.add(const RetrieveBulkPaymentGroups(BulkPaymentGroupsPage.routeName));

                    Future.delayed(const Duration(seconds: 0), () {
                      NavigatorUtil.pop(context, routeName: BulkPaymentGroupsPage.routeName, nav: MyApp.navigatorKey.currentState!, showNavBar: true);

                      MessageUtil.displaySuccessDialog(context, message: state.result.message);
                    });

                    return;
                  }

                  if (state is DeleteBulkPaymentGroupError) {
                    _loader.stop();

                    Future.delayed(const Duration(seconds: 0), () {
                      MessageUtil.displayErrorDialog(context, message: state.result.message);
                    });
                    return;
                  }

                  if (state is MovingToNewGroup) {
                    _loader.start('Loading');
                    _moving = true;
                    return;
                  }

                  if (state is MovedToNewGroup) {
                    _loader.stop();

                    Future.delayed(const Duration(seconds: 0), () {
                      MyApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(BulkPaymentGroupDetailsPage.routeName, ModalRoute.withName(BulkPaymentGroupsPage.routeName), arguments: state.group);

                      context.read<BottomNavBarBloc>().add(const ShowBottomNavBar(BulkPaymentGroupsPage.routeName));
                    });
                    return;
                  }
                },
                buildWhen: (previous, current) => current is RetrievingBulkPaymentGroups || current is BulkPaymentGroupsRetrieved || current is BulkPaymentGroupsRetrievedSilently,
                builder: (context, state) {
                  if (state is RetrievingBulkPaymentGroups) {
                    final shimmers = List.filled(10, const Padding(padding: EdgeInsets.only(bottom: 10), child: ListLoadingShimmer()));
                    return Column(
                      children: shimmers.map((e) => const Padding(padding: EdgeInsets.only(bottom: 10), child: ListLoadingShimmer())).toList(),
                    );
                  }

                  if (state is! BulkPaymentGroupsRetrieved && state is! BulkPaymentGroupsRetrievedSilently) {
                    return const SizedBox();
                  }

                  if (_list.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/img/empty.svg', width: 64),
                          Text(
                            'No Groups found',
                            style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'Create a group to see it appear here',
                            style: PrimaryTextStyle(color: Color(0xff919195), fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: ListUtil.separatedLis<Groups>(
                        list: _sourceList.data?.groups ?? [],
                        item: (group) {
                          return Item(
                            key: ValueKey(group.groupId),
                            onPressed: () {
                              NavigatorUtil.pushName(context, routeName: BulkPaymentGroupDetailsPage.routeName, nav: MyApp.navigatorKey.currentState!, showNavBar: true, arguments: group);
                            },
                            title: group.title ?? '',
                            subtitle: '${group.currency} ${group.totalAmount}',
                            fullIcon: Avatar(key: ValueKey('${group.groupId}-icon'), text: group.title ?? '', size: 18, textSize: 13),
                            count: group.numberOfPayee,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<BulkPaymentBloc, BulkPaymentState>(
        builder: (context, state) {
          if (state is RetrieveBulkPaymentGroupsError || state is RetrievingBulkPaymentGroups || (state is BulkPaymentGroupsRetrieved && _list.isEmpty)) {
            return const SizedBox();
          }

          return SizedBox(
            height: 40,
            width: 170,
            child: FormButton(
              onPressed: () {
                context.read<GeneralFlowBloc>().add(RetrieveGeneralFlowFormData(formId: _sourceList.data?.formId ?? '', routeName: '${BulkPaymentGroupsPage.routeName}fav', activityType: ActivityTypesConst.fblOnline));
              },
              icon: Icons.add,
              text: 'Create Group',
            ),
          );
        },
      ),
    );
  }

  void _search(String value, List<Groups> requests, {shouldSetState = true}) {
    logger.i(value);
    String search = value.trim().toLowerCase();
    _list = requests.where((element) {
      return element.title?.toLowerCase().contains(search) ?? false;
    }).toList();
    if (shouldSetState) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ListLoadingShimmer extends StatelessWidget {
  const ListLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff919195),
      highlightColor: const Color(0x99919195),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(color: const Color(0xff919195), borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      ),
                      const Spacer(),
                      Container(
                        height: 15,
                        width: 50,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      ),
                      const Spacer(),
                      Container(
                        height: 15,
                        width: 70,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
