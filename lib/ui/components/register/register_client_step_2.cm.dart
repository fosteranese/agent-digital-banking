import 'package:flutter/material.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/select.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RegisterClientStep2 extends StatelessWidget {
  const RegisterClientStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Residential Address', style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600)),

          const SizedBox(height: 30),

          FormInput(label: 'Address Line 1 *'),

          FormInput(label: 'Address Line 2'),

          FormSelect(
            label: 'Region *',
            title: 'Enter gender',
            options: [
              FormSelectOption(value: 'male', text: 'Male'),
              FormSelectOption(value: 'female', text: 'Female'),
            ],
          ),

          FormInput(label: 'Town / City'),
        ],
      ),
    );
  }
}
