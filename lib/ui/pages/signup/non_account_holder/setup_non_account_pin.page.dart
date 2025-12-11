import 'package:flutter/material.dart';

import '../../../../env/env.dart';
import '../../../../utils/theme.util.dart';
import '../../../components/form/button.dart';
import '../../../components/form/pin_pad_single.dart';
import '../../../layouts/plain.layout.dart';
import 'confirm_non_account_pin.page.dart';

class SetupNonAccountPinPage extends StatefulWidget {
  const SetupNonAccountPinPage({
    super.key,
    required this.question,
    required this.answer,
    required this.password,
  });
  static const routeName = '/signup/non-account-holder/setup-pin';

  final String question;
  final String answer;
  final String password;

  @override
  State<SetupNonAccountPinPage> createState() => _SetupNonAccountPinPageState();
}

class _SetupNonAccountPinPageState extends State<SetupNonAccountPinPage> {
  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      title: 'Authorization PIN Setup',
      centerTitle: true,
      subtitle: 'This will be your PIN for all transactions on the app',
      centerSubtitle: true,
      children: [
        const SizedBox(height: 30),
        Center(
          child: Text(
            'Create PIN',
            style: TextStyle(
              fontFamily: ThemeUtil.fontHelveticaNeue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        PinPadSingle(
          pinLength: Env.pingLength,
          next: () {},
          previous: () {},
          onPinEntered: (value) {
            Navigator.pushNamed(
              context,
              ConfirmNonAccountPinPage.routeName,
              arguments: {
                'question': widget.question,
                'answer': widget.answer,
                'password': widget.password,
                'pin': value,
              },
            );
          },
          padding: const EdgeInsets.all(20),
        ),
        const Spacer(),
        FormButton(
          text: 'Proceed',
          onPressed: () {},
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}