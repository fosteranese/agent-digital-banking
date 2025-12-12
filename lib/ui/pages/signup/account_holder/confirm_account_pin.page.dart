import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/complete_signup.request.dart';
import 'package:my_sage_agent/env/env.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/pin_pad_single.dart';
import 'package:my_sage_agent/ui/layouts/plain.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/login/existing_device_login.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account_pin.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account_secret_question_and_answer.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class ConfirmAccountPinSetupPage extends StatefulWidget {
  const ConfirmAccountPinSetupPage({super.key, required this.password, required this.question, required this.answer, required this.pin});
  static const routeName = '/signup/account-holder/confirm-pin';

  final String password;
  final String question;
  final String answer;
  final String pin;

  @override
  State<ConfirmAccountPinSetupPage> createState() => _ConfirmAccountPinSetupPageState();
}

class _ConfirmAccountPinSetupPageState extends State<ConfirmAccountPinSetupPage> {
  late final String _requestId;
  final _pinLength = Env.pingLength;
  final _loader = Loader();

  @override
  void initState() {
    _requestId = context.read<AuthBloc>().requestId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CompletingSignUp) {
          _loader.start('Setting you up');
          return;
        }

        if (state is SignUpCompleted) {
          _loader.stop();
          Future.delayed(const Duration(seconds: 0)).then((_) {
            _loader.successWithOptions(
              title: 'You are all set',
              message: 'Preparing to log you in',
              onClose: () {
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   IndexPage.routeName,
                //   (route) => false,
                // );
                Navigator.pushNamedAndRemoveUntil(context, ExistingDeviceLoginPage.routeName, ModalRoute.withName(SetupAccountPage.routeName));
                context.push(DashboardPage.routeName);
              },
            );
          });

          return;
        }

        if (state is CompleteSignUpError) {
          _loader.stop();

          Future.delayed(const Duration(seconds: 0), () {
            _loader.failedWithOptions(
              title: 'Registration Failed',
              message: state.result.message,
              onClose: () {
                Navigator.pushNamedAndRemoveUntil(context, SetupAccountPinPage.routeName, ModalRoute.withName(SetupAccountSecretQuestionAndAnswerPage.routeName), arguments: {'password': widget.password, 'question': widget.question, 'answer': widget.answer});
              },
            );
          });
          return;
        }
      },
      child: PlainLayout(
        title: 'Authorization PIN Setup',
        centerTitle: true,
        subtitle: 'This will be your PIN for all transactions on the app',
        centerSubtitle: true,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text('Confirm PIN', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 10),
          PinPadSingle(
            pinLength: _pinLength,
            next: () {},
            previous: () {},
            onPinEntered: (value) {
              if (value != widget.pin) {
                MessageUtil.displayErrorDialog(context, message: "Pins do not match");
                return;
              }
              context.read<AuthBloc>().add(CompleteCustomerSignUp(CompleteSignUpRequest(registrationId: _requestId, password: widget.password, question: widget.question, answer: widget.answer, pin: widget.pin)));
            },
            padding: const EdgeInsets.all(20),
          ),
          const Spacer(),
          const Spacer(),
          FormButton(text: 'Confirm', onPressed: () {}),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
