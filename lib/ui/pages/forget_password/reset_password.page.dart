import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/forgot_password/reset_password.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/forget_password/request_password_reset.page.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/string.util.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  static const routeName = '/forgot-password/reset';

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late String _requestId;
  final _loader = Loader();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // bool _passwordStatus = false;

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is ForgotPasswordVerified) {
      _requestId = state.requestId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Create a Password',
      subtitle:
          'Password must be at least 8 characters and include letters, numbers, and special characters (e.g. !\$@%).',
      onBackPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(RequestPasswordResetPage.routeName));
      },
      children: [
        FormPasswordInput(
          label: 'Password',
          placeholder: 'Enter your new password',
          controller: _passwordController,
        ),
        FormPasswordInput(
          label: 'Confirm Password',
          placeholder: 'Confirm password',
          controller: _confirmPasswordController,
        ),
        const Spacer(),
        const SizedBox(height: 20),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetCompleted) {
              Future.delayed(const Duration(seconds: 0)).then((_) {
                _loader.successWithOptions(
                  title: 'Success',
                  message: state.message,
                  onClose: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              });
              return;
            }

            if (state is ResetPasswordError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }
          },

          builder: (context, state) {
            return FormButton(
              loading: state is ResettingPassword,
              text: 'Continue',
              onPressed: () {
                final password = _passwordController.text;
                if (_passwordController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Password is required");
                  return;
                }

                if (!password.isPasswordComplex()) {
                  MessageUtil.displayErrorDialog(
                    context,
                    message:
                        "Password is not strong enough. It does not meet the password requirement",
                  );
                  return;
                }

                if (password != _confirmPasswordController.text) {
                  MessageUtil.displayErrorDialog(context, message: "Passwords do not match");
                  return;
                }

                context.read<AuthBloc>().add(
                  ResetPassword(
                    ResetPasswordRequest(requestId: _requestId, password: _passwordController.text),
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
