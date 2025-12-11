import 'package:flutter/material.dart';

import 'date_picker.dart';
import 'select.dart';

class FormSchedule extends StatefulWidget {
  const FormSchedule({super.key, required this.onInput});
  final void Function(String type, String date) onInput;

  @override
  State<FormSchedule> createState() => _FormScheduleState();
}

class _FormScheduleState extends State<FormSchedule> {
  final _type = TextEditingController();
  final _date = TextEditingController();

  @override
  void initState() {
    _type.addListener(_onChange);
    _date.addListener(_onChange);

    super.initState();
  }

  void _onChange() {
    widget.onInput(_type.text, _date.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      // margin: EdgeInsets.only(top: 10, bottom: 20),
      // padding: EdgeInsets.only(
      //   left: 20,
      //   right: 20,
      //   top: 20,
      //   // bottom: 10,
      // ),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withAlpha(20),
      //       blurRadius: 50,
      //       spreadRadius: 2,
      //     ),
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSelect(
            label: 'Schedule *',
            title: 'Schedule',
            placeholder: 'Select a schedule',
            controller: _type,
            onSelectedOption: (option) {
              _type.text = option.value;
              _onChange();
            },
            options: [
              FormSelectOption(
                value: 'Daily',
                text: 'Daily',
              ),
              FormSelectOption(
                value: 'Weekly',
                text: 'Weekly',
              ),
              FormSelectOption(
                value: 'Monthly',
                text: 'Monthly',
              ),
              FormSelectOption(
                value: 'Quarterly',
                text: 'Quarterly',
              ),
              FormSelectOption(
                value: 'SemiAnnually',
                text: 'Semi-Annually',
              ),
              FormSelectOption(
                value: 'Annually',
                text: 'Annually',
              ),
            ],
          ),
          FormDatePicker(
            label: 'Start Date *',
            controller: _date,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            minDate: DateTime.now().add(Duration(days: 1)),
            onSuccess: (date) {
              _date.text = date;
              _onChange();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _type.removeListener(_onChange);
    _type.dispose();

    _date.removeListener(_onChange);
    _date.dispose();

    super.dispose();
  }
}
