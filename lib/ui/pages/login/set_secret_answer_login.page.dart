import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/data/models/login/verify_id_response.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/password_input.dart';
import 'package:agent_digital_banking/ui/components/form/secret_question.dart';
import 'package:agent_digital_banking/ui/components/form/select.dart';
import 'package:agent_digital_banking/ui/layouts/plain_with_header.layout.dart';
import 'package:agent_digital_banking/ui/pages/login/new_device_login.page.dart';
import 'package:agent_digital_banking/ui/pages/login/otp_login.page.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class SetSecretAnswerLoginPage extends StatefulWidget {
  const SetSecretAnswerLoginPage(this.data, {super.key});
  static const routeName = '/login/set-secret-answer';
  final VerifyIdResponse data;

  @override
  State<SetSecretAnswerLoginPage> createState() => _SetSecretAnswerLoginPageState();
}

class _SetSecretAnswerLoginPageState extends State<SetSecretAnswerLoginPage> {
  final _secretAnswerController = TextEditingController();
  final _questionController = TextEditingController();
  FormSelectOption? _selectedQuestion;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SettingSecurityAnswerLogin) {
          MessageUtil.displayLoading(context, message: 'Setting');
          return;
        }

        if (state is SecurityAnswerLoginSet) {
          context.pop();
          context.push(OtpLoginPage.routeName);
          return;
        }

        if (state is SetSecurityAnswerLoginError) {
          context.pop();
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }
      },
      child: PlainWithHeaderLayout(
        title: 'Set Your Secret Question & Answer',
        subtitle: 'Please choose a security question from the list and input your preferred answer. Please keep this information safe. This will be required for account recovery.',
        onBackPressed: () {
          context.go(NewDeviceLoginPage.routeName);
        },
        children: [
          const SizedBox(height: 30),
          SelectSecretQuestion(
            questionController: _questionController,
            onSelectedOption: (option) {
              _selectedQuestion = option;
            },
          ),
          FormPasswordInput(controller: _secretAnswerController, label: 'Security Answer', placeholder: 'Enter your security answer', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black),
          const Spacer(),
          FormButton(
            text: 'Continue',
            onPressed: () {
              if (_secretAnswerController.text.isEmpty) {
                MessageUtil.displayErrorDialog(context, message: "Security Answer is required");
                return;
              } else if (_selectedQuestion == null) {
                MessageUtil.displayErrorDialog(context, message: "Security Question is required");
                return;
              }

              context.read<AuthBloc>().add(SetSecurityAnswerLogin(registrationId: widget.data.registrationId ?? '', answer: _secretAnswerController.text, question: _selectedQuestion!.text ?? ''));
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _secretAnswerController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}
