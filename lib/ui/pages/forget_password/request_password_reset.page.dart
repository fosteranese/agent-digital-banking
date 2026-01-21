import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/forgot_password/forgot_password.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/components/form/phone_number.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/forget_password/verify_password_reset.page.dart';
import 'package:my_sage_agent/ui/pages/forgot_secret_answer/request_secret_answer.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RequestPasswordResetPage extends StatefulWidget {
  const RequestPasswordResetPage({super.key});
  static const routeName = '/forgot-password/request-reset';

  @override
  State<RequestPasswordResetPage> createState() => _RequestPasswordResetPageState();
}

class _RequestPasswordResetPageState extends State<RequestPasswordResetPage> {
  final _phoneNumberController = TextEditingController();
  final _answerController = TextEditingController();
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Forgot Password',
      subtitle: 'Recover your forgotten password',
      children: [
        const SizedBox(height: 30),
        FormPhoneInput(
          controller: _phoneNumberController,
          label: 'Phone number *',
          placeholder: 'Enter phone number',
          onSelectedOption: (option, phoneNumber) {
            _phoneNumber = phoneNumber;
          },
        ),
        const SizedBox(height: 10),
        FormPasswordInput(
          label: 'Security Answer *',
          placeholder: 'Enter your security answer',
          controller: _answerController,
          info: Row(
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  context.push(RequestSecretAnswerPage.routeName);
                },
                child: Text(
                  'Forgot answer ?',
                  style: PrimaryTextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
        const Spacer(),
        const SizedBox(height: 5),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgotPasswordInitiated) {
              context.push(VerifyPasswordResetPage.routeName);
              return;
            }

            if (state is InitiateForgotPasswordError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is InitiatingForgotPassword,
              text: 'Continue',
              onPressed: () {
                if (_phoneNumberController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Phone number is required");
                  return;
                }
                if (_phoneNumber.isEmpty) {
                  MessageUtil.displayErrorDialog(
                    context,
                    message: "Phone number entered is invalid",
                  );
                  return;
                }

                if (_answerController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Security Answer is required");
                  return;
                }
                context.read<AuthBloc>().add(
                  InitiateForgotPassword(
                    ForgotPasswordRequest(
                      answer: _answerController.text,
                      phoneNumber: _phoneNumber,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}
