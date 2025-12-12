import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/login/initiate_login.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/forget_password/request_password_reset.page.dart';
import 'package:my_sage_agent/ui/pages/login/secret_answer_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/verify_id.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class NewDeviceLoginPage extends StatefulWidget {
  const NewDeviceLoginPage({super.key});
  static const routeName = '/login/new-device-login';

  @override
  State<NewDeviceLoginPage> createState() => _NewDeviceLoginPageState();
}

class _NewDeviceLoginPageState extends State<NewDeviceLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Sign in to your existing account',
      subtitleWidget: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'New to UMB SpeedApp? '),
            TextSpan(
              text: 'Sign up',
              style: PrimaryTextStyle(fontWeight: FontWeight.w700, color: ThemeUtil.secondaryColor),
            ),
          ],
          style: PrimaryTextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      onPressedSubtitle: () {
        context.replace(SetupAccountPage.routeName);
      },
      miniTitle: 'Login',
      children: [
        const SizedBox(height: 30),
        FormInput(controller: _usernameController, label: 'Phone number', keyboardType: TextInputType.number),
        const SizedBox(height: 10),
        FormPasswordInput(
          controller: _passwordController,
          label: 'Password',
          placeholder: 'Password',
          labelStyle: Theme.of(context).textTheme.labelMedium,
          visibilityColor: Colors.black,
          info: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                context.push(RequestPasswordResetPage.routeName);
              },
              child: Text(
                'Forgot password?',
                style: PrimaryTextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(height: 5),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is LoginInitiated) {
              context.push(SecretAnswerLoginPage.routeName);

              return;
            }

            if (state is VerifyId) {
              context.push(VerifyIdPage.routeName, extra: state.result.data);

              return;
            }

            if (state is InitiateLoginError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is InitiatingLogin,
              text: 'Sign In',
              onPressed: () {
                if (_usernameController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Username is required");
                  return;
                }

                if (_passwordController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Password is required");
                  return;
                }

                context.read<AuthBloc>().add(InitiateLogin(InitiateLoginRequest(phoneNumber: _usernameController.text, password: _passwordController.text)));
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
