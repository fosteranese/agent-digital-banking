import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/constants/activity_type.const.dart';
import 'package:my_sage_agent/data/models/agent_collection_model.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/user_response/activity.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/formatter.util.dart';
import 'package:my_sage_agent/utils/process_flow.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class CollectionsDetailsPage extends StatefulWidget {
  const CollectionsDetailsPage({super.key, required this.record});

  static const routeName = '/collections/details';
  final AgentCollectionModel record;

  @override
  State<CollectionsDetailsPage> createState() => _CollectionsDetailsPageState();
}

class _CollectionsDetailsPageState extends State<CollectionsDetailsPage> {
  final Map<String, (TextEditingController controller, GeneralFlowFieldsDatum fieldData)>
  _controllers = {};
  final ValueNotifier<String> _displayAmount = ValueNotifier('');

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
      bottomNavigationBar: widget.record.status == 1 && AppUtil.currentUser?.userType == 'AGENT'
          ? Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                // bottom: 20,
                // vertical: 10,
              ),
              child: _buildBottomAction(),
            )
          : const SizedBox.shrink(),
    );
  }

  /// Build the page layout content
  Widget _buildSlivers() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        color: Colors.white,
        padding: .symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Transaction Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            Text(
              'Kindly check and confirm the transaction details before you proceed',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ThemeUtil.flat),
            ),
            const SizedBox(height: 20),
            _buildPreviewContainer(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Build bottom button
  Widget _buildBottomAction() {
    return FormButton(onPressed: _confirmReverse, text: 'Reverse Transaction');
  }

  Widget _buildPreviewContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SummaryTile(
            label: 'Client name',
            value: widget.record.customerName ?? '',
            verticalPadding: _controllers.isEmpty ? 8 : 5,
          ),
          SummaryTile(
            label: 'Payment Method',
            value: '${widget.record.collectionMode} (${widget.record.customerAccountNumber})',
            verticalPadding: _controllers.isEmpty ? 8 : 5,
          ),
          SummaryTile(
            label: 'Amount',
            value: 'GHS ${FormatterUtil.currency(widget.record.amount)}',
            verticalPadding: _controllers.isEmpty ? 8 : 5,
          ),
        ],
      ),
    );
  }

  void _confirmReverse() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      useSafeArea: true,
      builder: (context) {
        return Container(
          margin: .only(left: 10, right: 10, bottom: 10 + MediaQuery.of(context).padding.bottom),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              Stack(
                alignment: .center,
                children: [
                  const Text(
                    'Reverse Transaction',
                    textAlign: .center,
                    style: PrimaryTextStyle(
                      fontWeight: .bold,
                      fontSize: 16,
                      color: ThemeUtil.danger,
                    ),
                  ),
                  Align(
                    alignment: .centerRight,
                    child: IconButton(
                      iconSize: 18,

                      style: IconButton.styleFrom(
                        tapTargetSize: .shrinkWrap,
                        maximumSize: const Size(32, 32),
                        minimumSize: const Size(32, 32),
                        backgroundColor: ThemeUtil.offWhite,
                        fixedSize: const Size(32, 32),
                        padding: .zero,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Are you sure you want to reverse this transaction?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: ThemeUtil.subtitleGrey,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: FormOutlineButton(
                      height: 42,
                      onPressed: () {
                        context.pop();
                        _reverse();
                      },
                      text: 'Reverse Now',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FormButton(
                      height: 42,
                      onPressed: () {
                        context.pop();
                      },
                      text: 'No, Cancel',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Trigger confirmation
  void _reverse() {
    ProcessFlowUtil.activityDatum = ActivityDatum(
      activity: Activity(
        activityType: ActivityTypesConst.fblOnline,
        activityName: 'Reverse Transaction',
      ),
    );

    ProcessFlowUtil.loadFormData(
      context,
      skipSavedData: true,
      amDoing: AmDoing.transaction,
      id: const Uuid().v4(),
      form: GeneralFlowForm(
        formId: 'b6bdf056-ee54-4643-9c56-681f5a090fec',
        activityType: ActivityTypesConst.fblOnline,
      ),
      activity: ActivityDatum(),
      collectionId: (widget.record.collectionId?.isNotEmpty ?? false)
          ? widget.record.collectionId
          : null,
    );
  }
}
