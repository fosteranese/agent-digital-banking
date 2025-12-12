import 'package:flutter/material.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/components/password_strength_checker.dart';
import 'package:my_sage_agent/ui/layouts/plain.layout.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:my_sage_agent/ui/pages/signup/non_account_holder/setup_non_account_secret_qa.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/string.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SetupNonAccountPasswordPage extends StatefulWidget {
  const SetupNonAccountPasswordPage({super.key});
  static const routeName = '/signup/non-account-holder/setup-password';

  @override
  State<SetupNonAccountPasswordPage> createState() => _SetupNonAccountPasswordPageState();
}

class _SetupNonAccountPasswordPageState extends State<SetupNonAccountPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      onBackPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(SetupAccountPage.routeName));
      },
      title: 'Set Your Password',
      children: [
        const SizedBox(height: 30),
        Text(
          'Password must be at least 8 characters long and include uppercase, lowercase, numbers, and special characters.',
          style: PrimaryTextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: const Color(0xff54534A)),
        ),
        const SizedBox(height: 20),
        FormPasswordInput(label: 'Password', placeholder: 'Password', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black, controller: _passwordController),
        PasswordStrengthChecker(
          controller: _passwordController,
          validFunc: (status) {
            // _passwordStatus = status;
          },
        ),
        FormPasswordInput(label: 'Confirm Password', placeholder: 'Confirm Password', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black, controller: _confirmPasswordController),

        const Spacer(),
        const SizedBox(height: 20),
        FormButton(
          onPressed: () {
            if (_passwordController.text.isEmpty) {
              MessageUtil.displayErrorDialog(context, message: "Password is required");
              return;
            }

            if (!_passwordController.text.isPasswordComplex()) {
              MessageUtil.displayErrorDialog(context, message: "Password is not strong enough. It does not meet the password requirement");
              return;
            }

            if (_passwordController.text != _confirmPasswordController.text) {
              MessageUtil.displayErrorDialog(context, message: "Passwords do not match");
              return;
            }
            Navigator.pushNamed(context, SetupNonAccountSecretQAPage.routeName, arguments: _passwordController.text);
          },
          text: 'Proceed',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
