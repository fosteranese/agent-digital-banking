import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/retrieve_data/retrieve_data_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/general_flow/general_flow_bloc.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:my_sage_agent/data/models/general_flow/general_flow_form_data.dart';
import 'package:my_sage_agent/data/models/payee/payees_response.dart';
import 'package:my_sage_agent/data/models/user_response/activity_datum.dart';
import 'package:my_sage_agent/ui/components/form/schedule.dart';
import 'package:my_sage_agent/ui/components/process_flow/form_fields_list.dart';
import 'package:my_sage_agent/ui/components/process_flow/form_submit_button.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/process_flow/confirmation_form.page.dart';
import 'package:my_sage_agent/ui/pages/quick_actions.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/string.util.dart';

class ProcessFormPage extends StatefulWidget {
  const ProcessFormPage({
    super.key,
    required this.formData,
    required this.amDoing,
    required this.activity,
    this.payee,
    this.receiptId,
  });

  static const routeName = '/process-flow/form';

  final GeneralFlowFormData formData;
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
  late GeneralFlowFormData _formData = widget.formData;
  final _controllers = <String, (TextEditingController, GeneralFlowFieldsDatum)>{};
  final _scheduleType = TextEditingController();
  final _scheduleDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _id = const Uuid().v4();
    _generateField(false);
  }

  void _generateField(bool updateScreen) {
    var visibleFields =
        _formData.fieldsDatum?.where((f) {
          final status = f.field?.fieldVisible == 1;

          if (_formData.form!.requireVerification != 1) {
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

        if ((widget.amDoing == AmDoing.payeeTransaction && item.field!.isAmount == 1) ||
            (item.field!.fieldName?.toLowerCase().contains('narration') ?? false)) {
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
        final exist = visibleFields.firstWhereOrNull(
          (field) => field.field!.fieldId == item.value.$2.field!.fieldId,
        );

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
          listener: (context, state) {
            if (state is DataRetrieved) {
              _formData = state.data.data;
              _generateField(true);
              return;
            }
          },
        ),
        BlocListener<GeneralFlowBloc, GeneralFlowState>(
          listener: (context, state) {
            if (state is RequestVerified && state.routeName == _id) {
              context.push(
                ConfirmationFormPage.routeName,
                extra: {
                  'activity': widget.activity,
                  'verifyData': state.result,
                  'formData': _formData,
                  'payload': state.payload,
                  'activityType': state.activityType,
                  'amDoing': widget.amDoing,
                },
              );
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
        showNavBarOnPop: true,
        showBackBtn: true,
        title: widget.formData.form?.formName ?? '',
        sliver: SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormFieldsList(
                formData: _formData,
                controllers: Map.fromEntries(
                  _controllers.entries.where((item) {
                    return item.value.$2.field!.readOnly != 1;
                  }),
                ),
              ),

              if (_formData.form!.requireVerification != 1 &&
                  widget.amDoing == AmDoing.createSchedule)
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
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            // vertical: 10,
          ),
          child: FormSubmitButton(
            id: _id,
            formData: _formData,
            amDoing: widget.amDoing,
            controllers: _controllers,
            loader: _loader,
            scheduleType: _scheduleType,
            scheduleDate: _scheduleDate,
            activity: widget.activity,
          ),
        ),
      ),
    );
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
