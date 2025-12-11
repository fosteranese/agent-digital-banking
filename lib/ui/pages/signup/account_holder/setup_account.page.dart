import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/data/models/customer_sign_up/customer_sign_up.request.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/ghana_card_input.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/layouts/plain_with_header.layout.dart';
import 'package:agent_digital_banking/ui/pages/login/new_device_login.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/ghana_card_verification.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class SetupAccountPage extends StatefulWidget {
  const SetupAccountPage({super.key});

  @override
  State<SetupAccountPage> createState() => _SetupAccountPageState();
  static const routeName = '/signup/account-holder/setup-account';
}

class _SetupAccountPageState extends State<SetupAccountPage> {
  final _accountNumberController = TextEditingController();
  final _ghanaCardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CustomerDetailsSubmitted) {
          context.push(GhanaCardVerificationPage.routeName);
          return;
        }

        if (state is SubmitCustomerDetailsError) {
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }
      },
      builder: (context, state) {
        return PlainWithHeaderLayout(
          useCloseIcon: true,
          title: 'Let’s get you on board',
          subtitleWidget: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'I already have an account? '),
                TextSpan(
                  text: 'Sign In',
                  style: PrimaryTextStyle(fontWeight: FontWeight.w700, color: ThemeUtil.secondaryColor),
                ),
              ],
              style: PrimaryTextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
          onPressedSubtitle: () {
            context.go(NewDeviceLoginPage.routeName);
          },
          children: [
            // const SizedBox(height: 30),
            FormInput(label: 'Account Number *', controller: _accountNumberController, keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false)),
            GhanaCardInput(
              controller: _ghanaCardNumberController,
              // placeholder: 'GHA-7123456-9',
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                final url = Uri.parse(AppUtil.data.help?.linkGhCard ?? '');
                launchUrl(url);
              },
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'Don\'t have your Ghana Card linked? '),
                      TextSpan(
                        text: 'Link it Here',
                        style: PrimaryTextStyle(color: ThemeUtil.secondaryColor, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                    style: PrimaryTextStyle(color: Colors.black, fontSize: 14),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text('By clicking on continue, you accept our ', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: Colors.black)),
                  InkWell(
                    onTap: () {
                      final url = Uri.parse(AppUtil.data.help?.termsUrl ?? '');
                      launchUrl(url);
                    },
                    child: Text('Terms of Use ', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, decoration: TextDecoration.underline)),
                  ),
                  Text('and ', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: Colors.black)),
                  InkWell(
                    onTap: () {
                      final url = Uri.parse(AppUtil.data.help?.privacyUrl ?? '');
                      launchUrl(url);
                    },
                    child: Text('Privacy Policy', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FormButton(
              loading: state is SubmittingCustomerDetails,
              onPressed: () {
                if (_accountNumberController.text.trim().isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: 'Account Number is required');
                  return;
                }
                if (_ghanaCardNumberController.text.trim().isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: 'Ghana Card Number is required');
                  return;
                }

                context.read<AuthBloc>().add(CustomerSignUp(CustomerSignUpRequest(accountNumber: _accountNumberController.text, ghanaCardNumber: _ghanaCardNumberController.text)));
              },
              text: 'Continue',
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _ghanaCardNumberController.dispose();
    super.dispose();
  }
}
