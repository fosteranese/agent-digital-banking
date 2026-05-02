import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    required this.emergencyContact,
    required this.withdrawalOption,
    required this.transactionNotification,
  });

  final TextEditingController address1;
  final TextEditingController address2;
  final TextEditingController region;
  final TextEditingController cityOrTown;
  final TextEditingController emergencyContact;
  final TextEditingController withdrawalOption;
  final TextEditingController transactionNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Details', style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600)),
            Text(
              'Complete the form below with the contact details',
              style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
            ),

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

            FormInput(
              label: 'Emergency Contact (Phone Number) *',
              placeholder: 'Eg. 0244123654',
              controller: emergencyContact,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: .phone,
            ),

            FormSelect(
              label: 'Withdrawal Option *',
              title: 'Select the withdrawal option',
              controller: withdrawalOption,
              options: [
                FormSelectOption(value: 'checkbook', text: 'CheckBook'),
                FormSelectOption(value: 'withdrawal-slip', text: 'Withdrawal Slip'),
                FormSelectOption(value: 'none', text: 'None'),
              ],
            ),

            FormSelect(
              label: 'Transaction Notification *',
              title: 'Choose notification option',
              controller: transactionNotification,
              options: [
                FormSelectOption(value: 'yes', text: 'Yes'),
                FormSelectOption(value: 'no', text: 'No'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
