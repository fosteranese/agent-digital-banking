import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/login/complete_login.request.dart';
import 'package:my_sage_agent/data/models/otp_verification.request.dart';
import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/otp.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/login/new_device_login.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});
  static const routeName = '/login/verify';

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  late VerificationResponse _data;
  late VerifyLoginRequest _resendPayload;
  String _otp = '';
  String _question = '';

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is LoginVerified) {
      _data = state.data;
      _resendPayload = state.resendPayload;
    } else if (state is SecurityAnswerLoginSet) {
      _data = state.data;
      _resendPayload = VerifyLoginRequest(requestId: state.resendPayload['requestId'], securityAnswer: state.resendPayload['answer']);
      _question = state.resendPayload['question']!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: _data.otpData!.title ?? '',
      subtitle: _data.otpData!.message ?? '',
      children: [
        const SizedBox(height: 30),
        Otp(
          length: _data.otpData!.length ?? 6,
          onCompleted: (String otp) {
            _otp = otp;
            context.read<AuthBloc>().add(CompleteLogin(OtpVerificationRequest(otpId: _data.otpData!.otpId, otpValue: _otp)));
          },
          onResendShortCode: () {
            if (_question.isEmpty) {
              context.read<AuthBloc>().add(ReVerifyLogin(_resendPayload));
            } else {
              context.read<AuthBloc>().add(ReVerifyLogin(_resendPayload));
            }
          },
        ),
        const Spacer(),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginReVerified) {
              _data = state.data;
              _resendPayload = state.resendPayload;

              MessageUtil.displaySuccessDialog(context, message: 'Code resent');
              return;
            }

            if (state is ReVerifyLoginError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }

            if (state is SecurityAnswerLoginReset) {
              _data = state.data;
              _resendPayload = VerifyLoginRequest(requestId: state.resendPayload['requestId'], securityAnswer: state.resendPayload['answer']);
              _question = state.resendPayload['question']!;

              MessageUtil.displaySuccessDialog(context, message: 'Code resent');
              return;
            }

            if (state is ReVerifyLoginError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }

            if (state is LoginCompleted) {
              context.go(DashboardPage.routeName);
              return;
            }

            if (state is CompleteLoginError) {
              MessageUtil.displayErrorDialog(
                context,
                title: 'Login Failed',
                message: state.result.message,
                onOkPressed: () {
                  context.go(NewDeviceLoginPage.routeName);
                },
              );
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is CompletingLogin || state is ResettingSecurityAnswerLogin || state is ReVerifyingLogin,
              text: 'Verify',
              onPressed: () {
                context.read<AuthBloc>().add(CompleteLogin(OtpVerificationRequest(otpId: _data.otpData!.otpId, otpValue: _otp)));
              },
            );
          },
        ),
      ],
    );
  }
}
