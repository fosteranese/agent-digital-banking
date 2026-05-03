import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/reversal_request_model/reversal_request_model.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/authentication.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/tab_header.dart';
import 'package:my_sage_agent/ui/components/tab_header_2.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/more/profile.page.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum ReversalDetailsTypes { details, customerInfo, agentInfo }

class ReversalDetailsPage extends StatefulWidget {
  const ReversalDetailsPage({super.key, required this.record});

  static const routeName = '/request/reversal/details';
  final ReversalRequestModel record;

  @override
  State<ReversalDetailsPage> createState() => _ReversalDetailsPageState();
}

class _ReversalDetailsPageState extends State<ReversalDetailsPage> {
  final Map<String, (TextEditingController controller, GeneralFlowFieldsDatum fieldData)>
  _controllers = {};
  final ValueNotifier<String> _displayAmount = ValueNotifier('');
  final _filterBy = ValueNotifier(ReversalDetailsTypes.details.name);
  String _id = '';
  late final _record = ValueNotifier(widget.record);

  @override
  void dispose() {
    _displayAmount.dispose();
    for (final controller in _controllers.values) {
      controller.$1.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      backgroundColor: Colors.white,
      showBackBtn: true,
      showNavBarOnPop: false,
      title: '',
      sliver: _buildSlivers(),
      bottomNavigationBar: BlocListener<GeneralFlowBloc, GeneralFlowState>(
        listener: (context, state) {
          if (state is ApprovingReversalRequest && state.id == _id) {
            MessageUtil.displayLoading(context);
            return;
          } else {
            MessageUtil.stopLoading(context);
          }

          if (state is ReversalRequestApproved && state.id == _id) {
            _record.value = _record.value.copyWith(
              reversal: _record.value.reversal?.copyWith(status: 1, statusLabel: 'Approved'),
            );
            context.read<RetrieveDataBloc>().add(
              RetrieveSupervisorAgentReversalsEvent(
                id: Uuid().v4(),
                action: 'RetrieveSupervisorAgentReversalsEvent',
                skipSavedData: true,
                agentCode: _record.value.agent?.agentCode?.toString() ?? 'N/A',
              ),
            );
            context.read<RetrieveDataBloc>().add(
              RetrievePendingReversalsEvent(
                id: Uuid().v4(),
                action: 'RetrievePendingReversalsEvent',
                skipSavedData: true,
              ),
            );
            MessageUtil.displaySuccessDialog(
              context,
              title: 'Reversal Approved!',
              message: state.result.message,
            );
            return;
          }

          if (state is ReversalRequestDeclined && state.id == _id) {
            _record.value = _record.value.copyWith(
              reversal: _record.value.reversal?.copyWith(status: 6, statusLabel: 'Declined'),
            );
            context.read<RetrieveDataBloc>().add(
              RetrieveSupervisorAgentReversalsEvent(
                id: Uuid().v4(),
                action: 'RetrieveSupervisorAgentReversalsEvent',
                skipSavedData: true,
                agentCode: _record.value.agent?.agentCode?.toString() ?? 'N/A',
              ),
            );
            context.read<RetrieveDataBloc>().add(
              RetrievePendingReversalsEvent(
                id: Uuid().v4(),
                action: 'RetrievePendingReversalsEvent',
                skipSavedData: true,
              ),
            );
            MessageUtil.displaySuccessDialog(
              context,
              title: 'Reversal Declined!',
              message: state.result.message,
            );
            return;
          }

          if (state is ApproveReversalRequestError && state.id == _id) {
            MessageUtil.displayErrorDialog(
              context,
              title: 'Processing Failed',
              message: state.error.message,
            );
            return;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: _record,
          builder: (context, record, child) {
            if (record.reversal?.status != 3) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                // bottom: 20,
                // vertical: 10,
              ),
              child: _buildBottomAction(),
            );
          },
        ),
      ),
    );
  }

  /// Build the page layout content
  Widget _buildSlivers() {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: .symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: _record,
                  builder: (context, record, child) {
                    final status = _status(record);
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Reversal Request',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        if (_record.value.reversal?.status != 3)
                          Container(
                            padding: .symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: status['bg'],
                              borderRadius: .circular(20),
                              border: .all(color: status['border'], width: 1),
                            ),
                            child: Text(
                              record.reversal?.statusLabel ?? '',
                              style: PrimaryTextStyle(
                                fontSize: 14,
                                fontWeight: .w400,
                                color: status['color'],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: MyHeaderDelegate(
            maxHeight: 90,
            minHeight: 90,
            builder: (context, shrinkOffset, overlapsContent) {
              return Container(
                color: Colors.white,
                width: .maxFinite,
                height: .maxFinite,
                padding: const .symmetric(horizontal: 20, vertical: 15),
                child: MyTabHeader2(
                  controller: _filterBy,
                  scrollable: false,
                  tabItems: [
                    TabItem(title: 'Details', id: ReversalDetailsTypes.details.name),
                    TabItem(title: 'Customer Info', id: ReversalDetailsTypes.customerInfo.name),
                    TabItem(title: 'Agent Info', id: ReversalDetailsTypes.agentInfo.name),
                  ],
                ),
              );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _filterBy,
          builder: (context, value, child) {
            if (ReversalDetailsTypes.details.name == value) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  color: Colors.white,
                  padding: .symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .start,
                    children: _buildDetailsPreviewContainer,
                  ),
                ),
              );
            } else if (ReversalDetailsTypes.customerInfo.name == value) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  color: Colors.white,
                  padding: .symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .start,
                    children: _buildCustomerDetailsPreviewContainer,
                  ),
                ),
              );
            }

            return SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.white,
                padding: .symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: _buildAgentDetailsPreviewContainer,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build bottom button
  Widget _buildBottomAction() {
    if (AppUtil.currentUser?.userType == 'AGENT') {
      return SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: .min,
        children: [
          FormButton(
            onPressed: () => _confirm(
              title: 'Approve Reversal',
              message: 'Are you sure you want to approve the reversal request from ',

              type: 'approve',
            ),
            text: 'Approve Request',
          ),
          const SizedBox(height: 15),
          FormButton(
            backgroundColor: ThemeUtil.danger100,
            foregroundColor: ThemeUtil.danger500,
            borderColor: ThemeUtil.danger200,
            onPressed: () => _confirm(
              title: 'Decline Reversal',
              message: 'Are you sure you want to approve the reversal request from ',
              type: 'decline',
            ),
            text: 'Decline Request',
          ),
        ],
      ),
    );
  }

  List<Widget> get _buildDetailsPreviewContainer {
    return [
      SummaryTile(
        label: 'Amount',
        value: 'GHS ${FormatterUtil.currency(_record.value.collection?.amount)}',
        verticalPadding: _controllers.isEmpty ? 8 : 5,
      ),
      SummaryTile(
        label: 'Client name',
        value: _record.value.collection?.agentName ?? '',
        verticalPadding: _controllers.isEmpty ? 8 : 5,
      ),
      SummaryTile(
        label: 'Payment Method',
        value:
            '${_record.value.collection?.collectionMode} (${_record.value.collection?.customerAccountNumber})',
        verticalPadding: _controllers.isEmpty ? 8 : 5,
      ),
      SummaryTile(
        label: 'Reason',
        value: _record.value.reversal?.reason ?? 'N/A',
        verticalPadding: _controllers.isEmpty ? 8 : 5,
      ),
    ];
  }

  List<Widget> get _buildCustomerDetailsPreviewContainer {
    return [
      ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: ThemeUtil.iconBg,
          child: Text(FormatterUtil.getInitials(_record.value.collection?.customerName ?? '')),
        ),
        contentPadding: .zero,
        title: Text(
          _record.value.collection?.customerName ?? '',
          style: PrimaryTextStyle(fontSize: 16, fontWeight: .w700, color: ThemeUtil.black),
        ),
        subtitle: Text(
          'Customer Code: ${_record.value.collection?.customerId ?? 'N/A'}',
          style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
        ),
      ),
      const SizedBox(height: 10),
      ReceiptItem(
        label: 'Phone Number',
        icon: 'assets/img/call-us.svg',
        name: _record.value.collection?.customerPhoneNumber ?? 'N/A',
      ),
      _divider,
      ReceiptItem(
        label: 'Account Number',
        icon: 'assets/img/id-card.svg',
        name: _record.value.collection?.customerAccountNumber ?? 'N/A',
      ),
      _divider,
    ];
  }

  Widget get _divider {
    return Divider(color: ThemeUtil.border, indent: 40);
  }

  List<Widget> get _buildAgentDetailsPreviewContainer {
    return [
      ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: ThemeUtil.iconBg,
          child: Text(FormatterUtil.getInitials(_record.value.collection?.agentName ?? '')),
        ),
        contentPadding: .zero,
        title: Text(
          _record.value.collection?.agentName ?? '',
          style: PrimaryTextStyle(fontSize: 16, fontWeight: .w700, color: ThemeUtil.black),
        ),
        subtitle: Text(
          'Agent Code: ${_record.value.agent?.agentCode ?? 'N/A'}',
          style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
        ),
      ),
      const SizedBox(height: 10),
      ReceiptItem(
        label: 'Phone Number',
        icon: 'assets/img/call-us.svg',
        name: _record.value.collection?.agentPhoneNumber ?? 'N/A',
      ),
      _divider,
      ReceiptItem(
        label: 'Account Number',
        icon: 'assets/img/id-card.svg',
        name: _record.value.collection?.agentAccountNumber ?? 'N/A',
      ),
      _divider,
    ];
  }

  void _confirm({required String title, required String message, required String type}) {
    showDialog(
      context: MyApp.navigatorKey.currentContext!,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: .symmetric(vertical: 30, horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: .circular(20)),
          content: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: ThemeUtil.secondaryColor100,
                child: Icon(Icons.warning_outlined, color: ThemeUtil.secondaryColor700),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: .center,
                style: PrimaryTextStyle(fontWeight: .w600, fontSize: 20, color: ThemeUtil.black),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message,

                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: ThemeUtil.subtitleGrey,
                      ),
                    ),
                    TextSpan(
                      text: _record.value.collection?.agentName ?? 'N/A',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: ThemeUtil.subtitleGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (type == 'approve')
                FormButton(
                  onPressed: () {
                    context.pop();
                    _approve();
                  },
                  text: 'Yes, approve',
                ),
              if (type == 'decline')
                FormButton(
                  backgroundColor: ThemeUtil.danger100,
                  foregroundColor: ThemeUtil.danger500,
                  borderColor: ThemeUtil.danger200,
                  onPressed: () {
                    context.pop();
                    _decline();
                  },
                  text: 'Yes, approve',
                ),
              const SizedBox(height: 10),
              FormOutlineButton(
                onPressed: () {
                  context.pop();
                },
                text: 'No, cancel',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Trigger confirmation
  void _approve() {
    AuthenticationUtil.pin(
      onSuccess: (pin) {
        _id = Uuid().v4();
        context.read<GeneralFlowBloc>().add(
          ApproveReversalRequestEvent(
            id: _id,
            pin: pin,
            requestId: _record.value.reversal?.id ?? '',
            comment: _record.value.reversal?.comment ?? '',
            username: AppUtil.currentUser!.user!.userCode ?? '',
            status: 1,
          ),
        );
      },
    );
  }

  void _decline() {
    AuthenticationUtil.pin(
      onSuccess: (pin) {
        _id = Uuid().v4();
        context.read<GeneralFlowBloc>().add(
          ApproveReversalRequestEvent(
            id: _id,
            pin: pin,
            requestId: _record.value.reversal?.id ?? '',
            comment: _record.value.reversal?.comment ?? '',
            username: AppUtil.currentUser!.user!.userCode ?? '',
            status: 6,
          ),
        );
      },
    );
  }

  Map<String, dynamic> _status(ReversalRequestModel record) {
    switch (record.reversal?.status) {
      case 1:
        return {
          'icon': Icons.published_with_changes_outlined,
          'color': ThemeUtil.primaryColor,
          'bg': ThemeUtil.success.withAlpha(50),
          'border': ThemeUtil.success.withAlpha(150),
        };
      case 0:
      case 2:
      case 6:
      case 100:
        return {
          'color': ThemeUtil.danger500,
          'bg': ThemeUtil.danger100,
          'border': ThemeUtil.danger200,
        };
      case 3:
      case 5:
        return {
          'icon': Icons.timelapse_outlined,
          'color': ThemeUtil.secondaryColor,
          'bg': ThemeUtil.secondaryColor.withAlpha(50),
          'border': ThemeUtil.secondaryColor.withAlpha(150),
        };
      default:
        return {
          'icon': Icons.timelapse_outlined,
          'color': ThemeUtil.secondaryColor,
          'bg': ThemeUtil.secondaryColor.withAlpha(50),
          'border': ThemeUtil.secondaryColor.withAlpha(150),
        };
    }
  }
}
