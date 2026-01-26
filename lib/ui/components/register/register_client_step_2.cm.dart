import 'package:flutter/material.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/select.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RegisterClientStep2 extends StatelessWidget {
  const RegisterClientStep2({
    super.key,
    required this.address1,
    required this.address2,
    required this.region,
    required this.cityOrTown,
  });

  final TextEditingController address1;
  final TextEditingController address2;
  final TextEditingController region;
  final TextEditingController cityOrTown;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Residential Address', style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600)),

            const SizedBox(height: 30),

            FormInput(label: 'Address Line 1 *', controller: address1),

            FormInput(label: 'Address Line 2', controller: address2),

            FormSelect(
              label: 'Region *',
              title: 'Enter region',
              controller: region,
              options:
                  AppUtil.data.regions?.map((item) {
                    return FormSelectOption(value: item.key ?? '', text: item.value);
                  }).toList() ??
                  [],
            ),

            FormInput(label: 'Town / City', controller: cityOrTown),
          ],
        ),
      ),
    );
  }
}
