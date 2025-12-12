import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/payee/payee_bloc.dart';
import 'package:my_sage_agent/data/models/payee/payees_response.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/select.dart';
import 'package:my_sage_agent/ui/components/form/select_screen.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class FormPayeeInput extends StatefulWidget {
  const FormPayeeInput({super.key, this.label = '', this.bottomSpace = 20, this.prefix, this.controller, this.placeholder, this.validation, this.showIconOnSuccessfulValidation = false, this.showIconOnFailedValidation = false, this.keyboardType, this.onSuccess, this.info, this.onSelectedOption, this.useLongList = false, this.useTextAsSelectedDisplayItem = false, this.onTap, this.showMenu = false, this.color = Colors.transparent, this.contentPadding, this.placeholderStyle, this.textAlign, this.textStyle, this.decoration, this.maxLength, this.prefixIconPadding, this.inputHeight, this.readOnly = false, this.tooltip, required this.formId, required this.title});

  final String label;
  final double bottomSpace;
  final Widget? prefix;
  final TextEditingController? controller;
  final String? placeholder;
  final bool Function()? validation;
  final bool showIconOnSuccessfulValidation;
  final bool showIconOnFailedValidation;
  final TextInputType? keyboardType;
  final void Function(String)? onSuccess;
  final Widget? info;
  final void Function(Payees payee)? onSelectedOption;
  final bool useLongList;
  final bool useTextAsSelectedDisplayItem;
  final bool Function()? onTap;
  final bool showMenu;
  final Color color;
  final EdgeInsets? contentPadding;
  final TextStyle? placeholderStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final int? maxLength;
  final EdgeInsetsGeometry? prefixIconPadding;
  final double? inputHeight;
  final bool readOnly;
  final String? tooltip;
  final String formId;
  final String title;

  @override
  State<FormPayeeInput> createState() => _FormPayeeInputState();
}

class _FormPayeeInputState extends State<FormPayeeInput> {
  @override
  void initState() {
    context.read<PayeeBloc>().add(RetrieveFormPayees(widget.formId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(readOnly: widget.readOnly, label: widget.label, controller: widget.controller, tooltip: widget.tooltip, keyboardType: TextInputType.phone, placeholder: widget.placeholder ?? AppUtil.gh.exampleNumberMobileNational, contentPadding: const EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0), onChange: (value) {}, suffix: _suffix());
  }

  Widget? _suffix() {
    if (widget.readOnly) {
      return null;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: BlocConsumer<PayeeBloc, PayeeState>(
        listenWhen: (previous, current) {
          return current is RetrievingFormPayees || current is RetrieveFormPayeesError || current is FormPayeesRetrieved;
        },
        listener: (context, state) {
          if (state is RetrieveFormPayeesError) {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
            return;
          }
        },
        builder: (context, state) {
          if (state is RetrievingFormPayees) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(color: ThemeUtil.secondaryColor)),
            );
          }

          if (state is RetrieveFormPayeesError || state is! FormPayeesRetrieved) {
            return IconButton(
              onPressed: () {
                context.read<PayeeBloc>().add(RetrieveFormPayees(widget.formId));
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                padding: const EdgeInsets.all(5),
              ),
              icon: const Icon(Icons.refresh_outlined),
            );
          }

          return IconButton(
            icon: Icon(Icons.group_outlined, color: ThemeUtil.secondaryColor),
            onPressed: () async {
              final payees = state.result;
              final title = widget.title.isNotEmpty && widget.title.substring(widget.title.length - 1, widget.title.length) == '*' ? widget.title.substring(0, widget.title.length - 1) : widget.title;

              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: MyApp.navigatorKey.currentContext!,
                isScrollControlled: (payees.data?.length ?? 0) > 5,
                elevation: 0,
                // barrierColor: Colors.white.withOpacity(0.6),
                useSafeArea: false,
                builder: (context) {
                  final options =
                      payees.data
                          ?.map(
                            (e) => FormSelectOption(
                              value: e.value ?? '',
                              text: e.title ?? '',
                              label: ListTile(
                                // dense: true,
                                title: Text(e.title ?? ''),
                                subtitle: Text('${e.value}'),
                              ),
                              data: e,
                            ),
                          )
                          .toList() ??
                      [];

                  if (options.length <= 5) {
                    return FormSelectOptionScreen(
                      fullScreen: false,
                      title: title,
                      options: options,
                      onSelectedOption: (selected) {
                        _onSelected(selected.data as Payees);
                      },
                    );
                  }

                  return MediaQuery(
                    data: MediaQueryData.fromView(View.of(context)),
                    child: FormSelectOptionScreen(
                      fullScreen: true,
                      title: title,
                      options: options,
                      onSelectedOption: (selected) {
                        _onSelected(selected.data as Payees);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _onSelected(Payees selected) {
    setState(() {
      // _selectedOption = selected;
      widget.controller?.text = selected.value ?? '';
      if (widget.onSelectedOption != null) {
        widget.onSelectedOption!(selected);
      }
    });
  }
}
