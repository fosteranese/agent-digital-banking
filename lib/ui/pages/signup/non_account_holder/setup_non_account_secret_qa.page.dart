import 'package:flutter/material.dart';

import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/components/form/secret_question.dart';
import 'package:agent_digital_banking/ui/components/form/select.dart';
import 'package:agent_digital_banking/ui/layouts/plain.layout.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_customer.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_non_account_pin.page.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class SetupNonAccountSecretQAPage extends StatefulWidget {
  const SetupNonAccountSecretQAPage({super.key, required this.password});
  static const routeName = '/signup/non-account-holder/setup-secret-qa';
  final String password;

  @override
  State<SetupNonAccountSecretQAPage> createState() => _SetupNonAccountSecretQAPageState();
}

class _SetupNonAccountSecretQAPageState extends State<SetupNonAccountSecretQAPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  FormSelectOption? _selectedQuestion;

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      onBackPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(SetupCustomerPage.routeName));
      },
      title: 'Setup your security question and answer',
      subtitle: 'Guard your transactions: Customize your secret Q&A to ensure secure access and transactions.',
      children: [
        const SizedBox(height: 30),
        SelectSecretQuestion(
          questionController: _questionController,
          onSelectedOption: (option) {
            _selectedQuestion = option;
          },
        ),
        FormInput(label: 'Answer to the Question', controller: _answerController),
        const Spacer(),
        const SizedBox(height: 20),
        FormButton(
          onPressed: () {
            if (_selectedQuestion == null) {
              MessageUtil.displayErrorDialog(context, message: "Security Question is required");
              return;
            }

            if (_answerController.text.isEmpty) {
              MessageUtil.displayErrorDialog(context, message: "Answer to Question is required");
              return;
            }
            Navigator.pushNamed(context, SetupNonAccountPinPage.routeName, arguments: {"question": _selectedQuestion!.text!, "answer": _answerController.text, "password": widget.password});
          },
          text: 'Proceed',
        ),
      ],
    );
  }
}
