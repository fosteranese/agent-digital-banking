import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/components/form/secret_question.dart';
import 'package:agent_digital_banking/ui/components/form/select.dart';
import 'package:agent_digital_banking/ui/layouts/plain_with_header.layout.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/setup_account_pin.page.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class SetupAccountSecretQuestionAndAnswerPage extends StatefulWidget {
  const SetupAccountSecretQuestionAndAnswerPage({super.key, required this.password, required this.isLoginBioEnabled});
  static const routeName = '/signup/account-holder/setup-secret-question-and-answer';
  final String password;
  final bool isLoginBioEnabled;

  @override
  State<SetupAccountSecretQuestionAndAnswerPage> createState() => _SetupAccountSecretQuestionAndAnswerPageState();
}

class _SetupAccountSecretQuestionAndAnswerPageState extends State<SetupAccountSecretQuestionAndAnswerPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  FormSelectOption? _selectedQuestion;

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Security Question and Answer',
      subtitle: 'Guard your transactions: Customize your secret Q&A to ensure secure access and transactions.',
      children: [
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

            context.push(SetupAccountPinPage.routeName, extra: {'password': widget.password, 'question': _selectedQuestion?.text!, 'answer': _answerController.text, 'isLoginBioEnabled': widget.isLoginBioEnabled});
          },
          text: 'Continue',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();

    super.dispose();
  }
}
