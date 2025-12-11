import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:agent_digital_banking/blocs/bulk_payment/bulk_payment_bloc.dart';
import 'package:agent_digital_banking/data/models/bulk_payment/bulk_payment_group_payees.dart';
import 'package:agent_digital_banking/data/models/bulk_payment/bulk_payment_groups.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/logger.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/utils/authentication.util.dart';
import 'package:agent_digital_banking/utils/list.util.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/messenger.util.dart';
import 'package:agent_digital_banking/utils/navigator.util.dart';
import 'package:agent_digital_banking/ui/components/avatar.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/components/form/outline_button.dart';
import 'package:agent_digital_banking/ui/components/item_level_3.dart';
import 'package:agent_digital_banking/ui/layouts/main.layout.dart';
import 'package:agent_digital_banking/ui/pages/history.page.dart';
import 'package:agent_digital_banking/ui/pages/recipient/recipient.page.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class BulkPaymentGroupDetailsPage extends StatefulWidget {
  const BulkPaymentGroupDetailsPage(this.group, {super.key});
  static const routeName = '/bulk-payment-payees/details';
  final Groups group;

  @override
  State<BulkPaymentGroupDetailsPage> createState() => _BulkPaymentGroupDetailsPageState();
}

class _BulkPaymentGroupDetailsPageState extends State<BulkPaymentGroupDetailsPage> {
  final _controller = TextEditingController();
  late Response<BulkPaymentGroupPayees>? _sourceList;
  List<Payees> _list = [];
  final _refreshController = GlobalKey<RefreshIndicatorState>();
  bool _enableSearch = false;
  final _loader = Loader();
  late final _bloc = context.read<BulkPaymentBloc>();
  final _messenger = Messenger();

  @override
  void initState() {
    _bloc.add(RetrieveBulkPaymentGroupMembers(group: widget.group, routeName: BulkPaymentGroupDetailsPage.routeName));
    _sourceList = _bloc.groupMembers[widget.group.groupId ?? ''];
    _list = _sourceList?.data?.payees ?? [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      refreshController: _refreshController,
      onRefresh: () async {
        _bloc.add(SilentRetrieveBulkPaymentGroupMembers(routeName: BulkPaymentGroupDetailsPage.routeName, group: widget.group));
      },
      title: 'Group Beneficiaries',
      showBackBtn: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _enableSearch = !_enableSearch;
            });
          },
          icon: _enableSearch ? SvgPicture.asset('assets/img/close-search.svg', width: 25, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)) : SvgPicture.asset('assets/img/search.svg', width: 25, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        ),
      ],
      bottom: _enableSearch
          ? PreferredSize(
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
                    _search(value, _sourceList?.data?.payees ?? []);
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
                              _search('', _sourceList?.data?.payees ?? []);
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                  ),
                ),
              ),
            )
          : null,
      slivers: [
        if (!_enableSearch)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      image: const DecorationImage(image: AssetImage('assets/img/background.png'), opacity: 0.1, fit: BoxFit.cover),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Avatar(
                          text: widget.group.title ?? '',
                          size: 40,
                          textSize: 15,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.group.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.group.currency} ${widget.group.totalAmount}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Container(
            width: double.maxFinite,
            color: Colors.white,
            child: BlocConsumer<BulkPaymentBloc, BulkPaymentState>(
              listener: (context, state) {
                if (state is BulkPaymentGroupMembersRetrieved) {
                  _sourceList = state.result;
                  _search('', _sourceList?.data?.payees ?? [], shouldSetState: false);

                  MainLayout.stopRefresh(context);
                  return;
                }

                if (state is BulkPaymentGroupMembersRetrievedSilently) {
                  _sourceList = state.result;
                  _search('', _sourceList?.data?.payees ?? [], shouldSetState: false);

                  MainLayout.stopRefresh(context);
                  return;
                }

                if (state is RetrieveBulkPaymentGroupMembersError || state is SilentRetrieveBulkPaymentGroupMembersError) {
                  MainLayout.stopRefresh(context);
                  return;
                }

                if (state is AddingPayeesToBulkPaymentGroup) {
                  _loader.start('Adding');
                  return;
                }

                if (state is PayeesAddedToBulkPaymentGroup) {
                  _loader.stop();
                  _bloc.add(const RetrieveBulkPaymentGroups(BulkPaymentGroupDetailsPage.routeName));

                  Future.delayed(const Duration(seconds: 0), () {
                    NavigatorUtil.pop(context, routeName: BulkPaymentGroupDetailsPage.routeName, nav: MyApp.navigatorKey.currentState!, showNavBar: true);

                    MessageUtil.displaySuccessDialog(context, message: state.result.message);
                  });

                  return;
                }

                if (state is AddPayeesToBulkPaymentGroupError) {
                  _loader.stop();

                  Future.delayed(const Duration(seconds: 0), () {
                    MessageUtil.displayErrorDialog(context, message: state.result.message);
                  });
                  return;
                }

                if (state is RemovingPayeeFromBulkPaymentGroup) {
                  _loader.start('Removing');
                  return;
                }

                if (state is PayeeRemovedFromBulkPaymentGroup) {
                  _loader.stop();

                  Future.delayed(const Duration(seconds: 0), () {
                    NavigatorUtil.pop(context, routeName: BulkPaymentGroupDetailsPage.routeName, nav: MyApp.navigatorKey.currentState!, showNavBar: true);

                    MessageUtil.displaySuccessDialog(context, message: state.result.message);
                  });

                  return;
                }

                if (state is RemovePayeeFromBulkPaymentGroupError) {
                  _loader.stop();

                  Future.delayed(const Duration(seconds: 0), () {
                    MessageUtil.displayErrorDialog(context, message: state.result.message);
                  });
                  return;
                }

                if (state is MakingBulkPayment) {
                  _loader.start('Payment in progress');
                  return;
                }

                if (state is BulkPaymentMade) {
                  _loader.stop();

                  Future.delayed(const Duration(seconds: 0), () {
                    _loader.successBulkPayment(
                      title: 'Success',
                      result: state.result,
                      onClose: () {},
                      onGotoHistory: () {
                        context.push(HistoryPage.routeName, extra: true);
                      },
                    );
                  });

                  return;
                }

                if (state is RemovePayeeFromBulkPaymentGroupError) {
                  _loader.stop();

                  Future.delayed(const Duration(seconds: 0), () {
                    MessageUtil.displayErrorDialog(context, message: state.result.message);
                  });
                  return;
                }
              },
              buildWhen: (previous, current) => current is RetrievingBulkPaymentGroupMembers || current is BulkPaymentGroupMembersRetrieved || current is BulkPaymentGroupMembersRetrievedSilently,
              builder: (context, state) {
                if (state is RetrievingBulkPaymentGroupMembers) {
                  final shimmers = List.filled(10, const Padding(padding: EdgeInsets.only(bottom: 10), child: ListLoadingShimmer()));
                  return Column(
                    children: shimmers.map((e) => const Padding(padding: EdgeInsets.only(bottom: 10), child: ListLoadingShimmer())).toList(),
                  );
                }

                if (state is! BulkPaymentGroupMembersRetrieved && state is! BulkPaymentGroupMembersRetrievedSilently) {
                  return const SizedBox();
                }

                if (_list.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      SvgPicture.asset('assets/img/empty.svg', width: 64),
                      Text(
                        'No Beneficiaries',
                        style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'No Beneficiaries found in this group',
                        style: PrimaryTextStyle(color: Color(0xff919195), fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ListUtil.separatedLis<Payees>(
                    list: _sourceList?.data?.payees ?? [],
                    item: (record) {
                      return ItemLevel3(
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        icon: CachedNetworkImage(
                          imageUrl: '${_sourceList?.imageBaseUrl}${_sourceList?.imageDirectory}/${record.icon}',
                          width: 30,
                          placeholder: (context, url) => CircleAvatar(
                            backgroundColor: const Color(0xffF4F4F4),
                            child: Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 16),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: const Color(0xffF4F4F4),
                            child: Icon(Icons.circle_outlined, color: Theme.of(context).primaryColor, size: 16),
                          ),
                        ),
                        title: record.title ?? '',
                        subtitle: record.value,
                        subtitle2: (record.amount != null) && (record.currency?.isNotEmpty ?? false) ? '${record.formName}  -  ${record.currency} ${record.amount}' : record.formName,
                        trailing: IconButton(
                          onPressed: () {
                            _onRemovePayeeFromGroup(record);
                          },
                          color: Colors.red,
                          icon: const Icon(Icons.close),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 50, color: Colors.black.withAlpha(26), spreadRadius: 10, blurStyle: BlurStyle.normal)],
        ),
        child: SafeArea(
          right: true,
          left: true,
          bottom: true,
          maintainBottomViewPadding: true,
          top: true,
          minimum: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: _onDelete,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Delete', style: TextStyle(color: Color(0xff54534A))),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(width: 0.5), right: BorderSide(width: 0.5)),
                    ),
                    child: InkWell(
                      onTap: _addPayee,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_outlined, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 5),
                          const Text('Add', style: TextStyle(color: Color(0xff54534A))),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: _makePayment,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.send_outlined, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 5),
                          const Text('Send', style: TextStyle(color: Color(0xff54534A))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addPayee() {
    NavigatorUtil.pushName(context, routeName: PayeesPage.routeName, nav: MyApp.navigatorKey.currentState!, arguments: {'payeeAction': PayeeAction.selectPayee, 'group': widget.group, 'payees': _list});
  }

  void _onDelete() {
    _messenger.contentAlert(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/img/question.svg', width: 100),
          const SizedBox(height: 40),
          const Text('Are you sure you want to delete this group ?', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          const SizedBox(height: 20),
          FormButton(
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
              context.read<BulkPaymentBloc>().add(DeleteBulkPaymentGroup(group: widget.group, routeName: PayeesPage.routeName));
            },
            text: 'Yes, Delete',
          ),
          const SizedBox(height: 10),
          FormOutlineButton(
            onPressed: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
            },
            text: 'No, Stop',
          ),
        ],
      ),
    );
  }

  void _onRemovePayeeFromGroup(Payees payee) {
    _messenger.contentAlert(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Remove Beneficiary', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'You are about to remove\n'),
                TextSpan(
                  text: payee.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red, decorationStyle: TextDecorationStyle.solid, decorationColor: Colors.red, decoration: TextDecoration.underline),
                ),
              ],
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black),
            ),
            textAlign: TextAlign.center,
            // softWrap: true,
          ),
          const SizedBox(height: 20),
          FormButton(
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
              _bloc.add(RemovePayeeFromBulkPaymentGroup(group: widget.group, payee: payee, routeName: PayeesPage.routeName));
            },
            text: 'Yes, Remove',
          ),
          const SizedBox(height: 10),
          FormOutlineButton(
            onPressed: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
            },
            text: 'No, Stop',
          ),
        ],
      ),
    );
  }

  void _search(String value, List<Payees> requests, {shouldSetState = true}) {
    logger.i(value);
    String search = value.trim().toLowerCase();
    _list = requests.where((element) {
      return element.title?.toLowerCase().contains(search) ?? false;
    }).toList();
    if (shouldSetState) {
      setState(() {});
    }
  }

  void _makePayment() {
    _messenger.contentAlert(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bulk Payment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const SizedBox(height: 10),
          const Text(
            'You are about to make a bulk payment',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          const SizedBox(height: 20),
          FormButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
              AuthenticationUtil.pin(
                onSuccess: (pin) {
                  _bloc.add(MakeBulkPayment(group: widget.group, pin: pin, routeName: BulkPaymentGroupDetailsPage.routeName));
                },
              );
            },
            text: 'Yes, Pay',
          ),
          const SizedBox(height: 10),
          FormOutlineButton(
            onPressed: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
            },
            text: 'No, Stop',
          ),
        ],
      ),
    );
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
