import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:agent_digital_banking/blocs/bulk_payment/bulk_payment_bloc.dart';
import 'package:agent_digital_banking/blocs/payee/payee_bloc.dart';
import 'package:agent_digital_banking/data/models/bulk_payment/bulk_payment_group_payees.dart' as bulk_payment;
import 'package:agent_digital_banking/data/models/bulk_payment/bulk_payment_groups.dart';
import 'package:agent_digital_banking/data/models/payee/payees_response.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/utils/list.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/service.util.dart';
import 'package:agent_digital_banking/ui/components/form/search_box.dart';
import 'package:agent_digital_banking/ui/components/item_level_3.dart';
import 'package:agent_digital_banking/ui/layouts/main.layout.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/ui/pages/recipient/recipient_details.page.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

enum PayeeAction { normal, selectPayee }

class PayeesPage extends StatefulWidget {
  const PayeesPage({super.key, this.payeeAction = PayeeAction.normal, this.group, this.payees});

  static const routeName = '/payees';
  final PayeeAction payeeAction;
  final Groups? group;
  final List<bulk_payment.Payees>? payees;

  @override
  State<PayeesPage> createState() => PayeesPageState();
}

class PayeesPageState extends State<PayeesPage> {
  final _controller = TextEditingController();
  final scrollController = ScrollController();
  final _refreshController = GlobalKey<RefreshIndicatorState>();

  static String id = '';

  Response<PayeesResponse> _sourceList = Response(code: '', message: '', status: '', data: PayeesResponse());
  List<Payees> _list = [];
  final Map<String, bool> _selection = {};

  bool _silentLoading = false;
  bool _showSearchBox = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PayeeBloc>();
    bloc.add(const LoadPayees(false));
    _replayGetAllPayees = () {
      bloc.add(const LoadPayees(false));
    };
    _replayGetAllPayees();

    _sourceList = bloc.payees;
    _list = _filterPayees(_sourceList.data?.payees ?? []);
    _initSelection();
  }

  void _initSelection() {
    for (var e in _list) {
      _selection[e.payeeId ?? ''] = false;
    }
  }

  String get _title => widget.payeeAction == PayeeAction.selectPayee ? 'Select Beneficiaries' : 'Beneficiaries';

  // ---------- SELECTION ----------
  void _toggleSelection(String id, [bool? value]) {
    _selection[id] = value ?? !_selection[id]!;
    setState(() {});
  }

  void _selectAll() {
    _selection.updateAll((_, _) => true);
    setState(() {});
  }

  void _clearSelection() {
    _selection.updateAll((_, _) => false);
    setState(() {});
  }

  // ---------- SEARCH ----------
  void _search(String query, List<Payees> all, {bool shouldSetState = true}) {
    final search = query.trim().toLowerCase();
    _list = all.where((p) {
      final matches = [p.formName, p.title, p.value].any((f) => f?.toLowerCase().contains(search) ?? false);
      return matches && _excludePayees(p);
    }).toList();
    if (shouldSetState) setState(() {});
  }

  bool _excludePayees(Payees p) => (widget.payees?.isEmpty ?? true) || !widget.payees!.any((e) => e.payeeId == p.payeeId);

  List<Payees> _filterPayees(List<Payees> all) => all.where((p) => (p.title?.isNotEmpty ?? false) && (p.value?.isNotEmpty ?? false) && _excludePayees(p)).toList();

  // ---------- BLOC STATE HANDLER ----------
  void _handleBlocState(BuildContext context, PayeeState state) {
    if (state is PayeesLoaded || state is PayeesLoadedSilently) {
      late Response<PayeesResponse> sourceList;
      if (state is PayeesLoaded) {
        sourceList = state.result;
      } else if (state is PayeesLoadedSilently) {
        sourceList = state.result;
        MainLayout.stopRefresh(context);
      }
      _sourceList = sourceList;
      _search('', _sourceList.data?.payees ?? [], shouldSetState: false);
      return;
    }

    if (state is LoadPayeesError || state is SilentLoadPayeesError) {
      MainLayout.stopRefresh(context);
      return;
    }

    if (state is DeletingPayee || state is SendingPayeeNow) {
      MessageUtil.displayLoading(MyApp.navigatorKey.currentContext!);
      return;
    }

    if (state is PayeeDeleted || state is PayeeSentNow) {
      String title = '';
      String message = '';

      context.pop();
      if (state is PayeeDeleted) {
        title = 'Beneficiary Deleted';
        message = state.result.message;
      } else if (state is PayeeSentNow) {
        title = 'Successful';
        message = state.result.message;
      }

      _showRecipientDeleted(title, message);
      return;
    }

    if (state is DeletePayeeError || state is SendPayeeNowError) {
      String message = '';

      context.pop();
      if (state is DeletePayeeError) {
        message = state.result.message;
      } else if (state is SendPayeeNowError) {
        message = state.result.message;
      }

      Future.microtask(() => MessageUtil.displayErrorDialog(MyApp.navigatorKey.currentContext!, message: message));
    }
  }

  void Function() _replayGetAllPayees = () {};

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      onBackPressed: () {
        context.replace(DashboardPage.routeName);
      },
      backgroundColor: Colors.white,
      scrollController: scrollController,
      refreshController: _refreshController,
      onRefresh: () async {
        _controller.text = '';

        _silentLoading = true;
        _replayGetAllPayees();
        setState(() {});
      },
      backIcon: _buildBackButton(),
      showBackBtn: true,
      title: _title,
      actions: _buildActions(),
      bottom: _showSearchBox ? SearchBox(controller: _controller, onSearch: (v) => _search(v, _sourceList.data?.payees ?? [])) : null,
      isTopPadded: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.only(top: 15),
        sliver: BlocConsumer<PayeeBloc, PayeeState>(
          listener: _handleBlocState,
          buildWhen: (_, state) => !(state is LoadingPayees && _silentLoading),
          builder: (context, state) {
            if (state is LoadingPayees) {
              return _buildLoadingShimmer();
            }

            if (_list.isEmpty) return _buildEmptyState();

            return _buildPayeesList();
          },
        ),
      ),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButtonMargin: 20,
    );
  }

  Widget _buildBackButton() => IconButton(
    style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
    onPressed: () {
      context.replace(DashboardPage.routeName);
    },
    icon: const Icon(Icons.arrow_back, color: Colors.black),
  );

  List<Widget> _buildActions() {
    if (widget.payeeAction == PayeeAction.selectPayee) {
      return [_selection.values.any((v) => v) ? TextButton(onPressed: _clearSelection, child: const Text('Clear')) : TextButton(onPressed: _selectAll, child: const Text('Select All')), const SizedBox(width: 10)];
    }
    return [
      IconButton(
        style: IconButton.styleFrom(fixedSize: const Size(35, 35), backgroundColor: const Color(0x91F7C15A)),
        onPressed: () => setState(() {
          _controller.text = '';
          _search(_controller.text, _sourceList.data?.payees ?? []);
          _showSearchBox = !_showSearchBox;
        }),
        icon: SvgPicture.asset('assets/img/search.svg', width: 20, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
      ),
      const SizedBox(width: 10),
    ];
  }

  Widget _buildLoadingShimmer() => SliverFillRemaining(
    child: Column(
      children: ListUtil.separatedLis(
        list: List.filled(5, const Padding(padding: EdgeInsets.all(10), child: ListLoadingShimmer())),
        item: (e) => e,
      ),
    ),
  );

  Widget _buildEmptyState() => SliverFillRemaining(
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
              'No beneficiaries found',
              textAlign: TextAlign.center,
              style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff919195)),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    ),
  );

  Widget _buildPayeesList() => SliverList.builder(
    itemCount: _list.length,
    itemBuilder: (_, i) {
      final r = _list[i];
      return ItemLevel3(
        onPressed: widget.payeeAction == PayeeAction.normal ? () => context.push(PayeeDetailsPage.routeName, extra: r) : () => _toggleSelection(r.payeeId ?? ''),
        fullIcon: widget.payeeAction == PayeeAction.normal
            ? const Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xffF8F8F8),
                  child: Icon(Icons.person_2, color: Color(0xff919195)),
                ),
              )
            : null,
        icon: widget.payeeAction == PayeeAction.normal
            ? null
            : Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                value: _selection[r.payeeId],
                onChanged: (v) => _toggleSelection(r.payeeId ?? '', v),
              ),
        title: r.title ?? '',
        subtitle: r.value,
        subtitle2: r.formName,
        trailing: widget.payeeAction == PayeeAction.normal
            ? InkWell(
                onTap: () => ServiceUtil.sendPayeeNow(parentContext: MyApp.navigatorKey.currentContext!, payee: r, routeName: PayeeDetailsPage.routeName),
                child: const Icon(Icons.more_vert),
              )
            : null,
      );
    },
  );

  Widget? _buildFab(BuildContext context) {
    if (widget.payeeAction == PayeeAction.normal) {
      return FloatingActionButton(
        onPressed: () => context.push(QuickActionsPage.routeName, extra: AmDoing.addPayee),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      );
    }
    if (_selection.values.any((v) => v)) {
      return FloatingActionButton(
        onPressed: () {
          final selectedIds = _selection.entries.where((e) => e.value).map((e) => e.key).toList();

          _replayGetAllPayees = () {
            context.read<BulkPaymentBloc>().add(AddPayeesToBulkPaymentGroup(group: widget.group!, payees: selectedIds, routeName: PayeesPage.routeName));
          };

          _replayGetAllPayees();
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 6),
        ),
        child: const Icon(Icons.done_outlined),
      );
    }
    return null;
  }

  void _showRecipientDeleted(String title, String message) {
    showModalBottomSheet(
      context: MyApp.navigatorKey.currentContext!,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xffCEFFCE),
                child: Icon(Icons.task_alt_outlined, color: Color(0xff067335)),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff4F4F4F)),
              ),
              const SizedBox(height: 30),
              FormButton(
                onPressed: () {
                  context.pop();
                },
                text: 'Ok',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------- SHIMMER ----------
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
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(color: const Color(0xff919195), borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 15,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 15,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
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
