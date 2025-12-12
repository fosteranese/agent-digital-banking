import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account_secret_question_and_answer.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/string.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SetupAccountPasswordPage extends StatefulWidget {
  const SetupAccountPasswordPage({super.key});
  static const routeName = '/signup/account-holder/setup-password';

  @override
  State<SetupAccountPasswordPage> createState() => _SetupAccountPasswordPageState();
}

class _SetupAccountPasswordPageState extends State<SetupAccountPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isBioEnabled = false;

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      onBackPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(SetupAccountPage.routeName));
      },
      title: 'Create a Password',
      children: [
        FormPasswordInput(label: 'Password', placeholder: 'Password', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black, controller: _passwordController),
        FormPasswordInput(label: 'Confirm Password', placeholder: 'Confirm Password', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black, controller: _confirmPasswordController),
        // const SizedBox(height: 10),
        Center(
          child: Text(
            'Password must be at least 8 characters and include letters, numbers, and special characters (e.g. !\$@%).',
            textAlign: TextAlign.center,
            style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: const Color(0xff919195)),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(color: const Color(0xffF6F6F6), borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Container(
              height: 41,
              width: 41,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.fingerprint),
            ),
            title: Text(
              'Biometric Auth',
              style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
            ),
            subtitle: Text(
              'Use fingerprint or face ID for quick access',
              style: PrimaryTextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Color(0xff919195)),
            ),
            trailing: SizedBox(
              width: 45,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  trackOutlineWidth: WidgetStateProperty.resolveWith<double>((states) => 0),
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) => Color(0xffD9DADB)),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Color(0xffD9DADB),
                  value: _isBioEnabled,
                  onChanged: (value) {
                    _isBioEnabled = value;
                    setState(() {});
                  },
                  // activeColor: ThemeUtil.secondaryColor,
                ),
              ),
            ),
          ),
        ),
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

            context.push(SetupAccountSecretQuestionAndAnswerPage.routeName, extra: {'password': _passwordController.text, 'isLoginBioEnabled': _isBioEnabled});
          },
          text: 'Continue',
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
