import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/blocs/bulk_payment/bulk_payment_bloc.dart';
import 'package:agent_digital_banking/blocs/general_flow/general_flow_bloc.dart';
import 'package:agent_digital_banking/blocs/otp/otp_bloc.dart';
import 'package:agent_digital_banking/blocs/payee/payee_bloc.dart';
import 'package:agent_digital_banking/blocs/schedule/schedule_bloc.dart';
import 'package:agent_digital_banking/constants/activity_type.const.dart';
import 'package:agent_digital_banking/constants/field.const.dart';
import 'package:agent_digital_banking/data/models/collection/form_verification_response.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_form_data.dart';
import 'package:agent_digital_banking/data/models/process_request.model.dart';
import 'package:agent_digital_banking/data/models/request_response.dart';
import 'package:agent_digital_banking/data/models/response.modal.dart';
import 'package:agent_digital_banking/data/models/transaction_auth.dart';
import 'package:agent_digital_banking/data/models/user_response/activity.dart';
import 'package:agent_digital_banking/data/models/user_response/activity_datum.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/multiple_input_plus.dart';
import 'package:agent_digital_banking/ui/components/form/outline_button.dart';
import 'package:agent_digital_banking/ui/components/form/schedule.dart';
import 'package:agent_digital_banking/ui/layouts/main.layout.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/history.page.dart';
import 'package:agent_digital_banking/ui/pages/more/more.page.dart';
import 'package:agent_digital_banking/ui/pages/process_flow/process_form.page.dart';
import 'package:agent_digital_banking/ui/pages/quick_actions.page.dart';
import 'package:agent_digital_banking/ui/pages/receipt.page.dart';
import 'package:agent_digital_banking/ui/pages/recipient/recipient.page.dart';
import 'package:agent_digital_banking/utils/authentication.util.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class ConfirmationFormPage extends StatefulWidget {
  const ConfirmationFormPage({super.key, required this.verifyData, required this.formData, required this.payload, required this.activityType, required this.amDoing, required this.activity});

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
  final Map<String, (TextEditingController controller, GeneralFlowFieldsDatum fieldData)> _controllers = {};
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
    _fieldData = (fieldsDatum ?? widget.formData.fieldsDatum ?? []).where((e) => e.field?.fieldVisible == 1 && e.field?.readOnly != 1 && e.field?.requiredForVerification != 1).toList();
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
        _controllers.putIfAbsent(item.field!.fieldId!, () => (TextEditingController(text: item.field!.defaultValue), item));
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
        BlocListener<OtpBloc, OtpState>(listener: _handleOtpState),
      ],
      child: MainLayout(
        backgroundColor: Colors.white,
        showBackBtn: true,
        showNavBarOnPop: false,
        title: 'Transaction Summary',
        sliver: _buildSlivers(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
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
        child: Column(
          children: [
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
    return BlocBuilder<GeneralFlowBloc, GeneralFlowState>(
      builder: (context, generalState) {
        return BlocConsumer<PayeeBloc, PayeeState>(
          listener: _handlePayeeState,
          builder: (context, payeeState) {
            return BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, scheduleState) {
                final isLoading = generalState is ProcessingRequest || payeeState is AddingPayee || scheduleState is AddingSchedule;

                final actionText = switch (widget.amDoing) {
                  AmDoing.createSchedule => 'Schedule',
                  AmDoing.addPayee => 'Save',
                  _ => 'Send',
                };

                return FormButton(loading: isLoading, onPressed: _confirm, text: 'Confirm & $actionText');
              },
            );
          },
        );
      },
    );
  }

  /// Build form section dynamically
  Widget _buildFormSection() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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

                  final fieldName = item.field!.fieldName!.replaceRange(0, 1, item.field!.fieldName![0].toLowerCase());
                  if (payee.formData?.containsKey(fieldName) ?? false) {
                    entry.value.$1.text = '${FormMultipleInputPlus.autoFill}${payee.formData![fieldName]}';
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
      margin: const EdgeInsets.only(top: 25),
      child: Column(children: _previewData),
    );
  }

  /// Build preview summary
  List<Widget> _generatePreviewData() {
    final list = <Widget>[SummaryTile(label: 'Service', value: widget.formData.form?.formName ?? '', verticalPadding: _controllers.isEmpty ? 8 : 5), const Divider(color: Color(0xffF8F8F8))];

    for (var element in widget.verifyData.data!.previewData!) {
      list.add(SummaryTile(label: element.key ?? '', value: element.value ?? '', verticalPadding: _controllers.isEmpty ? 8 : 5));
      list.add(const Divider(color: Color(0xffF8F8F8)));

      if (element.key?.toLowerCase() == 'amount') {
        _displayAmount.value = element.value ?? '';
      }
    }

    // list.add(
    //   ValueListenableBuilder<String>(
    //     valueListenable: _displayAmount,
    //     builder: (context, value, _) => value.isEmpty
    //         ? const SizedBox()
    //         : _buildTotalAmount(value),
    //   ),
    // );

    return list;
  }

  // Widget _buildTotalAmount(String value) {
  //   return SummaryTile(
  //     label: 'Total Amount',
  //     value: value,
  //     allBold: true,
  //     verticalPadding: _controllers.isEmpty ? 8 : 5,
  //   );
  // }

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
    return FormMultipleInputPlus.getFormData(controllers: _controllers, preGeneralFieldDatum: widget.formData.fieldsDatum?.where((e) => e.field?.fieldVisible != 1 || e.field?.readOnly == 1 || e.field?.requiredForVerification == 1).toList() ?? [], formData: widget.verifyData.data?.formData ?? {});
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
  void _complete({String? pin, String? secretAnswer, String? otp, required Map<String, dynamic> payload}) {
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
      case AmDoing.createSchedule:
        context.read<ScheduleBloc>().add(AddSchedule(routeName: _id, request: request, payload: payload, schedulePayload: {'ExecutionType': _executionType, 'NextExecutionDate': _nextExecutionDate}));
        break;
      default:
        context.read<GeneralFlowBloc>().add(ProcessRequest(routeName: _id, activityType: widget.activityType, request: request, payload: payload));
    }
  }

  /// Handle state updates for GeneralFlowBloc
  void _handleGeneralFlowState(BuildContext context, GeneralFlowState state) {
    if ((state as dynamic).routeName != _id) return;

    switch (state) {
      case RequestProcessed processed:
        context.read<AuthBloc>().add(const RefreshUserData());
        _handleRequestProcessed(context, processed.result);
        break;
      case ProcessRequestError error:
        _showProcessRequestError(context, error);
        break;
      case SavingBeneficiary _:
        MessageUtil.displayLoading(context, message: 'Saving Beneficiary');
        break;
      case BeneficiarySaved saved:
        context.pop();
        MessageUtil.displaySuccessDialog(context, message: saved.result.message);
        break;
      case SaveBeneficiaryError saveError:
        MessageUtil.displayErrorDialog(context, message: saveError.result.message);
        break;
    }
  }

  /// Handle payee state changes
  void _handlePayeeState(BuildContext context, PayeeState state) {
    if (state is PayeeAdded && state.routeName == _id) {
      MessageUtil.displaySuccessDialog(context, message: state.result.message, onOk: () => context.go(PayeesPage.routeName));
    } else if (state is AddPayeeError && state.routeName == _id) {
      MessageUtil.displayErrorDialog(context, message: state.result.message);
    }
  }

  /// Handle request processed event
  void _handleRequestProcessed(BuildContext context, Response<RequestResponse> result) async {
    if (widget.amDoing != AmDoing.createBulkPaymentGroup) {
      _loader.successTransaction(
        title: 'Success',
        result: result,
        onClose: () {
          final destinations = ['/', DashboardPage.routeName, PayeesPage.routeName, HistoryPage.routeName, MorePage.routeName];

          while (!destinations.contains(GoRouter.of(context).state.path)) {
            context.pop();
          }
        },
        onSaveBeneficiary: () {
          context.read<GeneralFlowBloc>().add(SaveBeneficiary(routeName: _id, payload: result.data!));
        },
        onScheduleTransaction: () {
          context.push(
            ProcessFormPage.routeName,
            extra: {
              'form': widget.formData.form,
              'amDoing': AmDoing.createScheduleFromPayee,
              'activity': ActivityDatum(activity: Activity(activityType: widget.formData.form!.activityType)),
              'receiptId': result.data!.receiptId,
            },
          );
        },
        onShowReceipt: () async {
          context.push(ReceiptPage.routeName, extra: {'request': result.data, 'fblLogo': result.data?.fblLogo ?? '', 'imageBaseUrl': result.imageBaseUrl, 'imageDirectory': result.imageDirectory});
        },
      );
    } else {
      context.read<BulkPaymentBloc>().add(const GotoNewGroup());
    }
  }

  /// Handle OTP Bloc state updates
  void _handleOtpState(BuildContext context, OtpState state) {
    if ((state as dynamic).uid != _id) return;

    switch (state.runtimeType) {
      case OtpResent _:
        MessageUtil.displaySuccessDialog(context, message: (state as OtpResent).result.message);
        break;
      case ResendOtpError _:
        MessageUtil.displayErrorDialog(context, message: (state as ResendOtpError).result.message);
        break;
    }
  }

  /// Show error bottom sheet
  void _showProcessRequestError(BuildContext context, ProcessRequestError state) {
    showModalBottomSheet(
      context: context,
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
                backgroundColor: Color(0xffFFE0DF),
                child: Icon(Icons.error_outline_outlined, color: Color(0xffF10404)),
              ),
              const SizedBox(height: 15),
              Text(
                'Processing Failed',
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                state.result.message,
                textAlign: TextAlign.center,
                style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: const Color(0xff4F4F4F)),
              ),
              const SizedBox(height: 30),
              if (widget.formData.form?.formId != '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a')
                FormButton(
                  onPressed: () {
                    context.pop();
                    _confirm();
                  },
                  text: 'Try Again',
                )
              else
                FormButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: 'Ok',
                ),
              if (widget.formData.form?.formId != '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a') const SizedBox(height: 15),
              if (widget.formData.form?.formId != '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a')
                FormOutlineButton(
                  onPressed: () {
                    context.push(
                      ProcessFormPage.routeName,
                      extra: {
                        'form': GeneralFlowForm(activityType: ActivityTypesConst.quickFlow, formName: 'Submit a complaint', categoryId: '0fdc593e-89f2-4950-a491-75c66749bbcc', formId: '6b3aeefc-34c7-4bf4-a321-24d05dd2d63a'),
                        'amDoing': AmDoing.transaction,
                        'activity': ActivityDatum(
                          activity: Activity(activityId: '0fdc593e-89f2-4950-a491-75c66749bbcc', activityType: ActivityTypesConst.quickFlow, accessType: 'CUSTOMER'),
                        ),
                      },
                    );
                  },
                  text: 'Submit a Complaint',
                ),
            ],
          ),
        );
      },
    );
  }
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({super.key, required this.label, required this.value, this.allBold = false, this.verticalPadding = 8});

  final String label;
  final String value;
  final bool allBold;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: PrimaryTextStyle(color: allBold ? null : const Color(0xff919195), fontSize: 14, fontWeight: allBold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: PrimaryTextStyle(fontSize: 14, fontWeight: allBold ? FontWeight.bold : FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
