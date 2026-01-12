import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/otp/otp_bloc.dart';
import 'package:my_sage_agent/blocs/payee/payee_bloc.dart';
import 'package:my_sage_agent/constants/field.const.dart';
import 'package:my_sage_agent/data/models/collection/form_verification_response.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/process_request.model.dart';
import 'package:my_sage_agent/data/models/request_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/transaction_auth.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/multiple_input_plus.dart';
import 'package:my_sage_agent/ui/components/form/schedule.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/collections.page.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/history.page.dart';
import 'package:my_sage_agent/ui/pages/more/more.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/ui/pages/receipt.page.dart';
import 'package:my_sage_agent/utils/authentication.util.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ConfirmationFormPage extends StatefulWidget {
  const ConfirmationFormPage({
    super.key,
    required this.verifyData,
    required this.formData,
    required this.payload,
    required this.activityType,
    required this.amDoing,
    required this.activity,
  });

  static const routeName = '/process-flow/confirmation-form';

  final Response<FormVerificationResponse> verifyData;
  final GeneralFlowFormData formData;
  final Map<String, dynamic> payload;
  final String activityType;
  final AmDoing amDoing;
  final ActivityDatum activity;

  @override
  State<ConfirmationFormPage> createState() => _ConfirmationFormPageState();
}

class _ConfirmationFormPageState extends State<ConfirmationFormPage> {
  late List<GeneralFlowFieldsDatum> _fieldData;
  final Map<String, (TextEditingController controller, GeneralFlowFieldsDatum fieldData)>
  _controllers = {};
  final ValueNotifier<String> _displayAmount = ValueNotifier('');
  final Loader _loader = Loader();

  String _executionType = '';
  String _nextExecutionDate = '';
  String _id = const Uuid().v4();
  late List<Widget> _previewData;

  @override
  void initState() {
    super.initState();
    _id = const Uuid().v4();
    _setupFormData();
    _previewData = _generatePreviewData();
  }

  @override
  void dispose() {
    _displayAmount.dispose();
    for (final controller in _controllers.values) {
      controller.$1.dispose();
    }
    super.dispose();
  }

  /// Initialize field data
  void _setupFormData([List<GeneralFlowFieldsDatum>? fieldsDatum]) {
    _fieldData = (fieldsDatum ?? widget.formData.fieldsDatum ?? [])
        .where(
          (e) =>
              e.field?.fieldVisible == 1 &&
              e.field?.readOnly != 1 &&
              e.field?.requiredForVerification != 1,
        )
        .toList();
    _generateControllers();
  }

  /// Generate controllers for dynamic fields
  void _generateControllers({bool updateScreen = false}) {
    for (final item in _fieldData) {
      var value = widget.verifyData.data!.formData?[item.field!.fieldName];
      if (value?.isEmpty ?? true) {
        value = item.field!.defaultValue;
      }
      final controller = _controllers[item.field!.fieldId!];
      if (controller == null) {
        _controllers.putIfAbsent(
          item.field!.fieldId!,
          () => (TextEditingController(text: item.field!.defaultValue), item),
        );
      } else {
        _controllers[item.field!.fieldId!] = (controller.$1, item);
      }
    }

    if (updateScreen) {
      _controllers.removeWhere((key, _) => !_fieldData.any((f) => f.field!.fieldId == key));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _previewData = _generatePreviewData();
    return MultiBlocListener(
      listeners: [
        BlocListener<GeneralFlowBloc, GeneralFlowState>(listener: _handleGeneralFlowState),
      ],
      child: MainLayout(
        backgroundColor: Colors.white,
        showBackBtn: true,
        showNavBarOnPop: false,
        title: widget.formData.form?.formName ?? 'Confirm Transaction',
        sliver: _buildSlivers(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            // bottom: 20,
            // vertical: 10,
          ),
          child: _buildBottomAction(),
        ),
      ),
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
              'Transaction Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            Text(
              'Kindly check and confirm the transaction details before you proceed',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: ThemeUtil.flat),
            ),
            const SizedBox(height: 20),
            _buildFormSection(),
            if (widget.amDoing == AmDoing.createSchedule)
              Padding(
                padding: EdgeInsets.only(top: _fieldData.isNotEmpty ? 0 : 20, left: 20, right: 20),
                child: FormSchedule(
                  onInput: (type, date) {
                    _executionType = type;
                    _nextExecutionDate = date;
                  },
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Build bottom button
  Widget _buildBottomAction() {
    return FormButton(onPressed: _confirm, text: 'Confirm & Continue');
  }

  /// Build form section dynamically
  Widget _buildFormSection() {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: Column(
        children: [
          _buildPreviewContainer(),
          if (_controllers.isNotEmpty) const SizedBox(height: 20),
          ..._controllers.entries.map((entry) {
            return FormMultipleInputPlus(
              controllers: _controllers,
              controller: entry.value,
              fieldData: widget.verifyData.data?.formData?[entry.value.$2.field?.fieldName ?? ''],
              onPayeeSelectedOption: (payee) {
                for (final item in _fieldData) {
                  if (item.field?.fieldDataType == FieldDataTypesConst.sourceAccount) {
                    continue;
                  }

                  final fieldName = item.field!.fieldName!.replaceRange(
                    0,
                    1,
                    item.field!.fieldName![0].toLowerCase(),
                  );
                  if (payee.formData?.containsKey(fieldName) ?? false) {
                    entry.value.$1.text =
                        '${FormMultipleInputPlus.autoFill}${payee.formData![fieldName]}';
                  }
                }
                setState(() {});
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPreviewContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(children: _previewData),
    );
  }

  /// Build preview summary
  List<Widget> _generatePreviewData() {
    final list = <Widget>[
      SummaryTile(
        label: 'Service',
        value: widget.formData.form?.formName ?? '',
        verticalPadding: _controllers.isEmpty ? 8 : 5,
      ),
    ];

    for (var element in widget.verifyData.data!.previewData!) {
      list.add(
        SummaryTile(
          label: element.key ?? '',
          value: element.value ?? '',
          verticalPadding: _controllers.isEmpty ? 8 : 5,
        ),
      );

      if (element.key?.toLowerCase() == 'amount') {
        _displayAmount.value = element.value ?? '';
      }
    }

    return list;
  }

  /// Trigger confirmation
  void _confirm() {
    final payload = _buildPayload();
    if (payload == null) return;

    if (widget.amDoing == AmDoing.createSchedule && !_validateScheduleInputs()) {
      return;
    }

    _startAuthentication(payload);
  }

  Map<String, dynamic>? _buildPayload() {
    return FormMultipleInputPlus.getFormData(
      controllers: _controllers,
      preGeneralFieldDatum:
          widget.formData.fieldsDatum
              ?.where(
                (e) =>
                    e.field?.fieldVisible != 1 ||
                    e.field?.readOnly == 1 ||
                    e.field?.requiredForVerification == 1,
              )
              .toList() ??
          [],
      formData: widget.verifyData.data?.formData ?? {},
    );
  }

  bool _validateScheduleInputs() {
    if (_executionType.isEmpty) {
      _showError('Schedule is required');
      return false;
    }
    if (_nextExecutionDate.isEmpty) {
      _showError('Start Date is required');
      return false;
    }
    return true;
  }

  void _startAuthentication(Map<String, dynamic> payload) {
    AuthenticationUtil.start(
      title: widget.formData.form?.formName ?? '',
      authModes: widget.verifyData.data?.authMode ?? [],
      payload: payload,
      complete: _complete,
      onResendShortCode: () {
        context.read<OtpBloc>().add(ResendOtp(uid: _id, formId: widget.formData.form!.formId!));
      },
    );
  }

  void _showError(String message) {
    MessageUtil.displayErrorDialog(context, message: message);
  }

  /// Handle completion after authentication
  void _complete({
    String? pin,
    String? secretAnswer,
    String? otp,
    required Map<String, dynamic> payload,
  }) {
    final request = ProcessRequestModel(
      activityId: widget.activity.activity?.activityId ?? '',
      formId: widget.verifyData.data?.formId ?? '',
      paymentMode: widget.verifyData.data?.formData?['SourceAccount'] ?? '',
      auth: TransactionAuth(pin: pin, otp: otp, secretAnswer: secretAnswer),
    );

    _id = const Uuid().v4();

    switch (widget.amDoing) {
      case AmDoing.addPayee:
        context.read<PayeeBloc>().add(AddPayee(routeName: _id, payment: request, payload: payload));
        break;
      default:
        context.read<GeneralFlowBloc>().add(
          ProcessRequest(
            routeName: _id,
            activityType: widget.activityType,
            request: request,
            payload: payload,
          ),
        );
    }
  }

  /// Handle state updates for GeneralFlowBloc
  void _handleGeneralFlowState(BuildContext context, GeneralFlowState state) {
    if ((state as dynamic).routeName != _id) return;

    switch (state) {
      case ProcessingRequest _:
        MessageUtil.displayLoading(context);
        break;

      case RequestProcessed processed:
        MessageUtil.stopLoading(context);
        context.read<AuthBloc>().add(const RefreshUserData());
        _handleRequestProcessed(context, processed.result);
        break;

      case ProcessRequestError error:
        MessageUtil.stopLoading(context);
        _showProcessRequestError(context, error);
        break;
    }
  }

  /// Handle request processed event
  void _handleRequestProcessed(BuildContext context, Response<RequestResponse> result) async {
    _loader.successTransaction(
      title: 'Success',
      result: result,
      onClose: () {
        final destinations = [
          '/',
          DashboardPage.routeName,
          CollectionsPage.routeName,
          HistoryPage.routeName,
          MorePage.routeName,
        ];

        while (!destinations.contains(GoRouter.of(context).state.path)) {
          context.pop();
        }
      },
      onShowReceipt: () async {
        context.push(
          ReceiptPage.routeName,
          extra: {
            'request': result.data,
            'fblLogo': result.data?.fblLogo ?? '',
            'imageBaseUrl': result.imageBaseUrl,
            'imageDirectory': result.imageDirectory,
          },
        );
      },
    );
  }

  /// Show error bottom sheet
  void _showProcessRequestError(BuildContext context, ProcessRequestError state) {
    _loader.failed(state.result.message);
  }
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.allBold = false,
    this.verticalPadding = 10,
    this.margin = 10,
  });

  final String label;
  final String value;
  final bool allBold;
  final double verticalPadding;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: margin),
      padding: .all(verticalPadding),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: .all(color: ThemeUtil.border),
        boxShadow: [
          // BoxShadow(
          //   color: Color(0x0F000000),
          //   spreadRadius: 0,
          //   blurRadius: 10,
          //   offset: Offset(0, 4),
          // ),
        ],
      ),
      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
            style: PrimaryTextStyle(
              color: allBold ? null : ThemeUtil.flat,
              fontSize: 14,
              fontWeight: allBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.right,
            style: PrimaryTextStyle(
              fontSize: 16,
              fontWeight: allBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
