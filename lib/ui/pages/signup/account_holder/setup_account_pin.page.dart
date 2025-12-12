import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/data/models/complete_signup.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account_secret_question_and_answer.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SetupAccountPinPage extends StatefulWidget {
  const SetupAccountPinPage({super.key, required this.password, required this.question, required this.answer, required this.isLoginBioEnabled});
  static const routeName = '/signup/account-holder/setup-pin';

  final String password;
  final String question;
  final String answer;
  final bool isLoginBioEnabled;

  @override
  State<SetupAccountPinPage> createState() => _SetupAccountPinPageState();
}

class _SetupAccountPinPageState extends State<SetupAccountPinPage> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _loader = Loader();
  late final String _requestId;
  var _isTransactBioEnabled = false;

  @override
  void initState() {
    _requestId = context.read<AuthBloc>().requestId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Create Authorisation PIN',
      subtitle: 'Your PIN is encrypted and stored securely. Never share your PIN with anyone.',
      children: [
        FormPasswordInput(label: 'PIN', placeholder: 'Enter 4-digit PIN', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black, controller: _pinController, isPin: true, isNew: true),
        FormPasswordInput(label: 'Confirm PIN', placeholder: 'Confirm your PIN', labelStyle: Theme.of(context).textTheme.labelMedium, visibilityColor: Colors.black, controller: _confirmPinController, isPin: true),
        const SizedBox(height: 10),
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
              'Use your biometric for quick transaction authorisation',
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
                  value: _isTransactBioEnabled,
                  onChanged: (value) {
                    _isTransactBioEnabled = value;
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
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CompletingSignUp) {
              // _loader.start('Setting you up');
              return;
            }

            if (state is SignUpCompleted) {
              // _loader.stop();

              if (widget.isLoginBioEnabled) {
                context.read<BiometricBloc>().add(BiometricLoginStatusChange(_pinController.text));
              }

              if (_isTransactBioEnabled) {
                context.read<BiometricBloc>().add(BiometricTransactionStatusChange(_pinController.text));
              }

              _loader.successWithOptions(
                title: 'Welcome to UMB Mobile Banking!',
                message: 'Your account has been successfully set up. You can now access all your banking services on the go.',
                onClose: () {
                  // Navigator.pushNamedAndRemoveUntil(
                  //   context,
                  //   IndexPage.routeName,
                  //   (route) => false,
                  // );
                  // context.go(
                  //   ExistingDeviceLoginPage.routeName,
                  // );
                  context.push(DashboardPage.routeName);
                },
              );

              return;
            }

            if (state is CompleteSignUpError) {
              // _loader.stop();

              Future.delayed(const Duration(seconds: 0), () {
                _loader.failedWithOptions(
                  title: 'Registration Failed',
                  message: state.result.message,
                  onClose: () {
                    Navigator.pushNamedAndRemoveUntil(context, SetupAccountPinPage.routeName, ModalRoute.withName(SetupAccountSecretQuestionAndAnswerPage.routeName), arguments: {'password': widget.password, 'question': widget.question, 'answer': widget.answer, 'isLoginBioEnabled': widget.isLoginBioEnabled});
                  },
                );
              });
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is CompletingSignUp,
              onPressed: () {
                if (_pinController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "PIN is required");
                  return;
                }

                if (_pinController.text != _confirmPinController.text) {
                  MessageUtil.displayErrorDialog(context, message: "PINs do not match");
                  return;
                }

                context.read<AuthBloc>().add(CompleteCustomerSignUp(CompleteSignUpRequest(registrationId: _requestId, password: widget.password, question: widget.question, answer: widget.answer, pin: _pinController.text, isLoginBioEnabled: widget.isLoginBioEnabled, isTransactBioEnabled: _isTransactBioEnabled)));
              },
              text: 'Save',
            );
          },
        ),
      ],
    );
  }
}
