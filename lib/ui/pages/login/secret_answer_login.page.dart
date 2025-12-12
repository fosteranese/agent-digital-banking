import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/login/complete_login.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/forgot_secret_answer/request_secret_answer.page.dart';
import 'package:my_sage_agent/ui/pages/login/otp_login.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class SecretAnswerLoginPage extends StatefulWidget {
  const SecretAnswerLoginPage({super.key});
  static const routeName = '/login/secret-answer';

  @override
  State<SecretAnswerLoginPage> createState() => _SecretAnswerLoginPageState();
}

class _SecretAnswerLoginPageState extends State<SecretAnswerLoginPage> {
  late String _requestId;
  final _secretAnswerController = TextEditingController();

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is LoginInitiated) {
      _requestId = state.requestId;
    } else if (state is ReLoginInitiated) {
      _requestId = state.requestId;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Enter your security answer',
      subtitle: 'Provide your security answer to proceed',
      children: [
        const SizedBox(height: 30),
        FormPasswordInput(
          controller: _secretAnswerController,
          label: 'Security Answer',
          placeholder: 'Enter your security answer',
          labelStyle: Theme.of(context).textTheme.labelMedium,
          visibilityColor: Colors.black,
          info: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                context.push(RequestSecretAnswerPage.routeName);
              },
              child: Text(
                'Forgot Answer ?',
                style: PrimaryTextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(height: 5),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginVerified) {
              context.push(OtpLoginPage.routeName);
              return;
            }

            if (state is VerifyLoginError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is VerifyingLogin,
              text: 'Continue',
              onPressed: () {
                if (_secretAnswerController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Security Answer is required");
                  return;
                }

                context.read<AuthBloc>().add(VerifyLogin(VerifyLoginRequest(requestId: _requestId, securityAnswer: _secretAnswerController.text)));
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _secretAnswerController.dispose();
    super.dispose();
  }
}
