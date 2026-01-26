import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_sage_agent/ui/components/form/ghana_card_input.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/select.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RegisterClientStep1 extends StatelessWidget {
  const RegisterClientStep1({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phoneNumber,
    required this.emailAddress,
    required this.cardNumber,
  });
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController gender;
  final TextEditingController phoneNumber;
  final TextEditingController emailAddress;
  final TextEditingController cardNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Register New Client', style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600)),
            Text(
              'Complete the form below with the client’s details',
              style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
            ),
            const SizedBox(height: 30),

            FormInput(
              label: 'Full Name *',
              placeholder: 'Enter full name',
              controller: firstName,
              keyboardType: .name,
            ),
            FormSelect(
              controller: gender,
              label: 'Gender *',
              title: 'Enter gender',
              options: [
                FormSelectOption(value: 'male', text: 'Male'),
                FormSelectOption(value: 'female', text: 'Female'),
              ],
            ),
            FormInput(
              label: 'Phone Number *',
              placeholder: 'Eg. 0244123654',
              controller: phoneNumber,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: .phone,
            ),
            FormInput(
              label: 'Email Address *',
              placeholder: 'Enter email address',
              controller: emailAddress,
              keyboardType: .emailAddress,
            ),
            GhanaCardInput(controller: cardNumber, isRequired: true),
          ],
        ),
      ),
    );
  }
}
