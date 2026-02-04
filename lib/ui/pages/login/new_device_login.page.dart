import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/login/initiate_login.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/background.layout.dart';
import 'package:my_sage_agent/ui/pages/login/otp_login.page.dart';
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
    return BackgroundLayout(
      title: 'Sign in to your existing account',
      children: [
        const SizedBox(height: 30),
        Text(
          'Sign In',
          style: PrimaryTextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 30),
        FormInput(
          controller: _usernameController,
          label: 'Phone number',
          keyboardType: TextInputType.number,
          placeholder: 'Eg. 0244123654',
          color: Colors.white,
          labelStyle: GoogleFonts.mulish(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        FormPasswordInput(
          controller: _passwordController,
          label: 'Password',
          labelStyle: GoogleFonts.mulish(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          placeholder: 'Password',
          color: Colors.white,
          visibilityColor: Colors.black,
        ),
        const Spacer(),
        const SizedBox(height: 5),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is InitiatingLogin) {
              MessageUtil.displayLoading(context);
              return;
            }

            if (state is LoginInitiated) {
              MessageUtil.stopLoading(context);
              Future.delayed(Duration(milliseconds: 100), () {
                context.push(OtpLoginPage.routeName);
              });
              return;
            }

            if (state is InitiateLoginError) {
              MessageUtil.stopLoading(context);
              Future.delayed(Duration(milliseconds: 100), () {
                MessageUtil.displayErrorDialog(
                  context,
                  title: 'Login Failed',
                  message: state.result.message,
                );
              });
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              text: 'Sign In',
              onPressed: () {
                if (_usernameController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(
                    context,
                    title: 'Validation Failed',
                    message: "Username is required",
                  );
                  return;
                }

                if (_passwordController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(
                    context,
                    title: 'Validation Failed',
                    message: "Password is required",
                  );
                  return;
                }

                context.read<AuthBloc>().add(
                  InitiateLogin(
                    InitiateLoginRequest(
                      phoneNumber: _usernameController.text,
                      password: _passwordController.text,
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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
