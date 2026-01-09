import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/blocs/otp/otp_bloc.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:my_sage_agent/data/models/collection/institution.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/payee/payees_response.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/actions/action_tile.dart';
import 'package:my_sage_agent/ui/components/form/schedule.dart';
import 'package:my_sage_agent/ui/components/process_flow/form_fields_list.dart';
import 'package:my_sage_agent/ui/components/process_flow/form_submit_button.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/string.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ProcessFormPage extends StatefulWidget {
  const ProcessFormPage({super.key, required this.form, required this.amDoing, required this.activity, this.payee, this.receiptId});

  static const routeName = '/process-flow/form';

  final dynamic form;
  final AmDoing amDoing;
  final ActivityDatum activity;
  final Payees? payee;
  final String? receiptId;

  @override
  State<ProcessFormPage> createState() => _ProcessFormPageState();
}

class _ProcessFormPageState extends State<ProcessFormPage> {
  final _loader = Loader();
  late final String _id;
  final _stage = ValueNotifier(Stages.initial);
  GeneralFlowFormData? _formData;
  final _controllers = <String, (TextEditingController, GeneralFlowFieldsDatum)>{};
  final _scheduleType = TextEditingController();
  final _scheduleDate = TextEditingController();
  Response? _error;
  bool? _isMainLoading;

  @override
  void initState() {
    super.initState();
    _id = const Uuid().v4();
    _getFormData(skipSavedData: true);
  }

  void _getFormData({required bool skipSavedData}) {
    String action = '';

    if (widget.amDoing == AmDoing.createScheduleFromPayee) {
      action = (widget.payee != null) ? 'p-${widget.payee?.payeeId}' : 'r-${widget.receiptId}';

      context.read<RetrieveDataBloc>().add(RetrieveScheduleForm(id: _id, action: action, skipSavedData: skipSavedData, receiptId: widget.receiptId, payeeId: widget.payee?.payeeId));
      return;
    }

    switch (widget.form) {
      case GeneralFlowForm form:
        action = form.formId!;
        break;
      case Institution form:
        action = form.insId!;
        break;
    }
    context.read<RetrieveDataBloc>().add(RetrieveForm(id: _id, action: action, skipSavedData: skipSavedData, form: widget.form, activity: widget.activity, payeeId: widget.payee?.payeeId));

    if (_formData != null) {
      _generateField(false);
    }
  }

  String get _title {
    if (widget.form is GeneralFlowForm) {
      final form = widget.form as GeneralFlowForm;
      return form.formName ?? '';
    }
    if (widget.form is Institution) {
      final form = widget.form as Institution;
      return form.insName ?? '';
    }
    if (widget.form == null) {
      final form = widget.form as Institution;
      return form.insName ?? '';
    }
    return '';
  }

  void _generateField(bool updateScreen) {
    var visibleFields =
        _formData!.fieldsDatum?.where((f) {
          final status = f.field?.fieldVisible == 1;

          if (_formData!.form!.requireVerification != 1) {
            return status;
          }

          return status && f.field!.requiredForVerification == 1;
        }).toList() ??
        [];

    final amountField = visibleFields.firstWhereOrNull((item) {
      return item.field!.isAmount == 1;
    });

    if (amountField != null) {
      visibleFields = [
        amountField,
        ...visibleFields.where((item) {
          return item.field!.fieldId != amountField.field!.fieldId;
        }),
      ];
    }

    for (final item in visibleFields) {
      final controller = _controllers[item.field!.fieldId!];
      if (controller == null) {
        String? text = '';

        if (widget.payee != null) {
          text = widget.payee!.formData?[item.field!.fieldName!.unCapitalize()];
        }

        if ((widget.amDoing == AmDoing.payeeTransaction && item.field!.isAmount == 1) || (item.field!.fieldName?.toLowerCase().contains('narration') ?? false)) {
          text = '';
        } else if (text?.isEmpty ?? true) {
          text = item.field!.defaultValue ?? '';
        }

        _controllers[item.field!.fieldId!] = (TextEditingController(text: text), item);
      } else {
        _controllers[item.field!.fieldId!] = (controller.$1, item);
      }
    }

    if (updateScreen) {
      for (final item in _controllers.entries) {
        final exist = visibleFields.firstWhereOrNull((field) => field.field!.fieldId == item.value.$2.field!.fieldId);

        if (exist == null) {
          _controllers.remove(item.key);
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RetrieveDataBloc, RetrieveDataState>(
          listenWhen: (previous, current) => current.id == _id,
          listener: (context, state) {
            // delegate handling to utility functions
            _handleRetrieveDataState(context, state);
          },
        ),
        BlocListener<OtpBloc, OtpState>(
          listener: (context, state) {
            _handleOtpState(context, state);
          },
        ),
        BlocListener<GeneralFlowBloc, GeneralFlowState>(
          listener: (context, state) {
            if (state is RequestVerified && state.routeName == _id) {
              context.push(ConfirmationFormPage.routeName, extra: {'activity': widget.activity, 'verifyData': state.result, 'formData': _formData, 'payload': state.payload, 'activityType': state.activityType, 'amDoing': widget.amDoing});
              return;
            }

            if (state is RequestProcessed && state.routeName == _id) {
              return;
            }
          },
        ),
      ],
      child: MainLayout(
        backgroundColor: Colors.white,
        onRefresh: () async {
          _getFormData(skipSavedData: true);
        },
        showNavBarOnPop: true,
        showBackBtn: true,
        title: _title,
        sliver: ValueListenableBuilder(
          valueListenable: _stage,
          builder: (context, stage, child) {
            if (stage == Stages.error) {
              return SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: Color(0xff4F4F4F), size: 50),
                      const SizedBox(height: 10),
                      Text(
                        _error!.message,
                        textAlign: TextAlign.center,
                        style: PrimaryTextStyle(fontSize: 16, color: Color(0xff4F4F4F)),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            }

            if (stage == Stages.loading || _formData == null) {
              return SliverToBoxAdapter();
              // return SliverPadding(
              //   padding: const EdgeInsets.all(20),
              //   sliver: SliverList.separated(
              //     itemBuilder: (_, _) {
              //       return FormShimmerItem();
              //     },
              //     separatorBuilder: (_, _) {
              //       return SizedBox(height: 20);
              //     },
              //   ),
              // );
            }

            return SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormFieldsList(
                    formData: _formData!,
                    controllers: Map.fromEntries(
                      _controllers.entries.where((item) {
                        return item.value.$2.field!.readOnly != 1;
                      }),
                    ),
                  ),
                  // _buildPaymentControl(),
                  if (_formData?.form!.requireVerification != 1 && widget.amDoing == AmDoing.createSchedule)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FormSchedule(
                        onInput: (type, date) {
                          _scheduleType.text = type;
                          _scheduleDate.text = date;
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _stage,
          builder: (context, stage, child) {
            if (stage != Stages.done && _formData == null) {
              return SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                // vertical: 10,
              ),
              child: FormSubmitButton(id: _id, formData: _formData!, amDoing: widget.amDoing, controllers: _controllers, loader: _loader, scheduleType: _scheduleType, scheduleDate: _scheduleDate, activity: widget.activity),
            );
          },
        ),
      ),
    );
  }

  void _handleRetrieveDataState(BuildContext context, RetrieveDataState state) {
    if (state is! RetrievingData) {
      MainLayout.stopRefresh(context);
      if (_isMainLoading == true) {
        _isMainLoading = false;
        context.pop();
      }
    } else {
      _stage.value = Stages.loading;

      if (_formData == null) {
        _isMainLoading = true;
        MessageUtil.displayLoading(context);
      }
    }

    if (state is DataRetrieved) {
      _formData = state.data!.data;
      _generateField(true);
      _stage.value = Stages.done;
      return;
    }

    if (state is RetrieveDataError) {
      _stage.value = Stages.error;
      _error = state.error;
      return;
    }

    if (state is RequestProcessed) {
      return;
    }
  }

  void _handleOtpState(BuildContext context, OtpState state) {
    // keep OTP handling logic here
  }

  @override
  void dispose() {
    for (final c in _controllers.entries) {
      c.value.$1.dispose();
    }

    _scheduleType.dispose();
    _scheduleDate.dispose();
    super.dispose();
  }
}
