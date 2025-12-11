import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agent_digital_banking/blocs/collection/collection_bloc.dart';
import 'package:agent_digital_banking/blocs/general_flow/general_flow_bloc.dart';
import 'package:agent_digital_banking/data/models/collection/lov.dart';
import 'package:agent_digital_banking/data/models/general_flow/general_flow_fields_datum.dart';
import 'package:agent_digital_banking/ui/components/form/multiple_input_plus.dart';
import 'package:agent_digital_banking/ui/components/form/select.dart';

class BankAccountInputPlus extends StatefulWidget {
  const BankAccountInputPlus({super.key, required this.formMultipleInput, required String label, required String placeholder, required this.selectedOption, required this.lov, required bool readOnly, required this.flowType, this.sourceAccount}) : _label = label, _placeholder = placeholder, _readOnly = readOnly;

  final FormMultipleInputPlus formMultipleInput;
  final String _label;
  final String _placeholder;
  final FormSelectOption? selectedOption;
  final List<Lov> lov;
  final bool _readOnly;
  final String flowType;
  final (TextEditingController, GeneralFlowFieldsDatum)? sourceAccount;

  @override
  State<BankAccountInputPlus> createState() => BankAccountInputPlusState();
}

class BankAccountInputPlusState extends State<BankAccountInputPlus> {
  late final _lov = ValueNotifier(widget.lov);
  late var _selectedOption = widget.selectedOption;

  @override
  void initState() {
    if (widget.sourceAccount != null) {
      widget.sourceAccount!.$1.addListener(() {
        final source = widget.sourceAccount!.$1.text;
        final current = widget.formMultipleInput.controller.$1.text;
        _lov.value = widget.lov.where((item) => item.lovValue != source).toList();
        if (source == current) {
          widget.formMultipleInput.controller.$1.text = '';
          _selectedOption = null;
        }
      });
    }

    super.initState();
  }

  void reloadLov(GeneralFlowFormDataRetrievedSilently state) {
    final field = state.fblOnlineFormData.data!.fieldsDatum!.firstWhere((item) {
      return item.field!.fieldName == _fieldName;
    });
    if (widget.sourceAccount?.$1.text.isEmpty ?? true) {
      _lov.value = field.lov ?? [];
      return;
    }

    final lovs = field.lov?.where((item) {
      return item.lovValue != (widget.sourceAccount!.$1.text);
    });

    _lov.value = lovs?.toList() ?? [];
  }

  void reloadPaymentLov(CollectionFormRetrievedSilently state) {
    final field = state.result.fieldsData!.firstWhere((item) {
      return item.field!.fieldName == _fieldName;
    });
    if (widget.sourceAccount?.$1.text.isEmpty ?? true) {
      _lov.value = field.lov ?? [];
      return;
    }

    final lovs = field.lov?.where((item) {
      return item.lovValue != (widget.sourceAccount!.$1.text);
    });

    _lov.value = lovs?.toList() ?? [];
  }

  String get _fieldName {
    return widget.formMultipleInput.controller.$2.field!.fieldName!;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        ValueListenableBuilder(
          valueListenable: _lov,
          builder: (context, value, child) {
            return Expanded(
              child: FormSelect(
                title: widget.formMultipleInput.controller.$2.field?.fieldCaption ?? '',
                label: widget._label,
                controller: widget.formMultipleInput.controller.$1,
                placeholder: widget._placeholder,
                selectedOption: _selectedOption,
                onSelectedOption: (option) {
                  _selectedOption = option;
                },
                contentPadding: const EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0),
                options: value.map((e) => FormSelectOption(value: e.lovValue ?? '', text: e.lovTitle)).toList(),
                readOnly: widget._readOnly,
                // tooltip: _tooltip,
              ),
            );
          },
        ),
        if (!widget._readOnly && widget.flowType == 'general')
          BlocConsumer<GeneralFlowBloc, GeneralFlowState>(
            listener: (context, state) {
              if (state is GeneralFlowFormDataRetrievedSilently) {
                reloadLov(state);
                return;
              }
            },
            builder: (context, state) {
              if (state is RetrievingGeneralFlowFormDataSilently) {
                return const Padding(
                  padding: EdgeInsets.only(left: 15, right: 0, bottom: 15 + 23),
                  child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator()),
                );
              }

              return const SizedBox();
            },
          ),
        if (!widget._readOnly && widget.flowType == 'payment')
          BlocConsumer<PaymentsBloc, PaymentsState>(
            listener: (context, state) {
              if (state is CollectionFormRetrievedSilently) {
                reloadPaymentLov(state);
                return;
              }
            },
            builder: (context, state) {
              if (state is SilentRetrievingCollectionForm) {
                return const Padding(
                  padding: EdgeInsets.only(left: 15, right: 0, bottom: 15 + 23),
                  child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator()),
                );
              }

              return const SizedBox();
            },
          ),
      ],
    );
  }
}
