import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/data/models/complete_signup.request.dart';
import 'package:agent_digital_banking/env/env.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/pin_pad_single.dart';
import 'package:agent_digital_banking/ui/layouts/plain.layout.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/login/existing_device_login.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_customer.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_non_account_pin.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_non_account_secret_qa.page.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class ConfirmNonAccountPinPage extends StatefulWidget {
  const ConfirmNonAccountPinPage({super.key, required this.question, required this.answer, required this.password, required this.pin});
  static const routeName = '/signup/non-account-holder/confirm-pin';
  final String question;
  final String answer;
  final String password;
  final String pin;

  @override
  State<ConfirmNonAccountPinPage> createState() => _ConfirmNonAccountPinPageState();
}

class _ConfirmNonAccountPinPageState extends State<ConfirmNonAccountPinPage> {
  final _loader = Loader();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
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
                Navigator.pushNamedAndRemoveUntil(context, ExistingDeviceLoginPage.routeName, ModalRoute.withName(SetupCustomerPage.routeName));
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
                Navigator.pushNamedAndRemoveUntil(context, SetupNonAccountPinPage.routeName, ModalRoute.withName(SetupNonAccountSecretQAPage.routeName), arguments: {"question": widget.question, "answer": widget.answer, "password": widget.password});
              },
            );
          });
          return;
        }
      },
      builder: (context, state) {
        return PlainLayout(
          title: 'Authorization PIN Setup',
          centerTitle: true,
          subtitle: 'This will be your PIN for all transactions on the app',
          centerSubtitle: true,
          onBackPressed: () {
            Navigator.popUntil(context, ModalRoute.withName(SetupCustomerPage.routeName));
          },
          children: [
            const SizedBox(height: 30),
            Center(
              child: Text('Confirm PIN', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            PinPadSingle(
              pinLength: Env.pingLength,
              next: () {},
              previous: () {},
              onPinEntered: (value) {
                if (value != widget.pin) {
                  MessageUtil.displayErrorDialog(context, message: "Pins do not match");
                  return;
                }
                context.read<AuthBloc>().add(CompleteSignUp(CompleteSignUpRequest(question: widget.question, answer: widget.answer, password: widget.password, pin: widget.pin)));
              },
              padding: const EdgeInsets.all(20),
            ),
            const Spacer(),
            FormButton(text: 'Proceed', onPressed: () {}),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
