import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/ui/components/actions/action_tile.dart';
import 'package:agent_digital_banking/ui/components/form/search_box.dart';
import 'package:agent_digital_banking/ui/layouts/main.layout.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

enum AmDoing { transaction, addPayee, payeeTransaction, createBulkPaymentGroup, createSchedule, createScheduleFromPayee }

class QuickActionsPage extends StatefulWidget {
  const QuickActionsPage({super.key, this.amDoing = AmDoing.transaction});
  static const routeName = '/quick-actions';
  final AmDoing amDoing;

  @override
  State<QuickActionsPage> createState() => _QuickActionsPageState();
}

class _QuickActionsPageState extends State<QuickActionsPage> {
  final _controller = TextEditingController();
  List<ActivityDatum> _activities = [];
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  bool _silentLoading = false;
  final _id = Uuid().v4();
  final _expandedItem = ValueNotifier('');
  bool _showSearchBox = false;

  @override
  void initState() {
    _activities = _getActivities(AppUtil.currentUser.activities ?? []);
    super.initState();
  }

  List<ActivityDatum> _getActivities(List<ActivityDatum> activities) {
    if (widget.amDoing != AmDoing.addPayee && widget.amDoing != AmDoing.createSchedule) {
      return activities;
    }

    return activities.where((element) => element.activity?.allowPayee == 1).toList();
  }

  String get _title {
    switch (widget.amDoing) {
      case AmDoing.addPayee:
        return 'New Beneficiary';
      case AmDoing.createSchedule:
        return 'New Standing Order';
      case AmDoing.transaction:
      case AmDoing.payeeTransaction:
      default:
        return 'Actions';
    }
  }

  List<ActivityDatum> get _activityList {
    final search = _controller.text.trim().toLowerCase();
    return _activities.where((item) {
      return item.activity?.activityName?.toLowerCase().contains(search) ?? false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          MainLayout.stopRefresh(context);
          _silentLoading = false;
          return;
        }

        if (state is RefreshUserDataFailed) {
          MainLayout.stopRefresh(context);
          _silentLoading = false;
          return;
        }
      },
      buildWhen: (previous, current) => !(current is RefreshingUserData && _silentLoading),
      builder: (context, state) {
        return MainLayout(
          backgroundColor: const Color(0xffF8F8F8),
          refreshController: _refreshController,
          bottom: _showSearchBox
              ? SearchBox(
                  controller: _controller,
                  onSearch: (_) {
                    setState(() {});
                  },
                )
              : null,
          actions: [
            IconButton(
              style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
              onPressed: () => setState(() {
                _controller.text = '';
                _showSearchBox = !_showSearchBox;
              }),
              icon: SvgPicture.asset('assets/img/search.svg', width: 20, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
            ),
            const SizedBox(width: 10),
          ],
          onRefresh: () async {
            _silentLoading = true;
            context.read<AuthBloc>().add(const RefreshUserData());
          },
          showBackBtn: true,
          title: _title,
          sliver: SliverPadding(
            padding: EdgeInsets.all(15),
            sliver: ValueListenableBuilder(
              valueListenable: _expandedItem,
              builder: (context, value, child) {
                if (_activityList.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/img/empty.svg', width: 64),
                            const SizedBox(height: 10),
                            Text(
                              'Nothing found',
                              textAlign: TextAlign.center,
                              style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff4F4F4F)),
                            ),
                            Text(
                              'no "${_controller.text}" was found',
                              textAlign: TextAlign.center,
                              style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff919195)),
                            ),
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList.separated(
                  itemCount: _activityList.length,
                  itemBuilder: (_, index) {
                    final action = _activityList[index];
                    return ActionTile(
                      id: _id,
                      amDoing: widget.amDoing,
                      action: action,
                      isExpanded: value == action.activity?.activityId,
                      onExpand: (status) {
                        if (!status) {
                          return;
                        }

                        _expandedItem.value = action.activity?.activityId ?? '';
                      },
                    );
                  },
                  separatorBuilder: (_, _) {
                    return SizedBox(height: 10);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
