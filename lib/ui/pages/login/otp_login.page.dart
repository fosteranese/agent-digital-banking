import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/otp_verification.request.dart';
import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/otp.dart';
import 'package:my_sage_agent/ui/layouts/plain.layout.dart';
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
  String _otp = '';

  @override
  void initState() {
    _data = context.read<AuthBloc>().signIn!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      title: _data.otpData!.title ?? '',
      subtitle: _data.otpData!.message ?? '',
      children: [
        const SizedBox(height: 30),
        Otp(
          length: _data.otpData!.length ?? 6,
          onCompleted: (String otp) {
            _otp = otp;
            context.read<AuthBloc>().add(
              CompleteLogin(OtpVerificationRequest(otpId: _data.otpData!.otpId, otpValue: _otp)),
            );
          },
          onResendShortCode: () {
            context.read<AuthBloc>().add(ReInitiateLogin(id: Uuid().v4()));
          },
        ),
        const Spacer(),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CompletingLogin || state is ReInitiatingLogin) {
              MessageUtil.displayLoading(context);
              return;
            } else {
              MessageUtil.stopLoading(context);
            }

            if (state is ReLoginInitiated) {
              _data = state.requestId;
              Future.delayed(Duration(milliseconds: 100), () {
                MessageUtil.displaySuccessDialog(
                  context,
                  title: 'OTP Resent',
                  message: 'OTP has been resent again',
                );
              });
              return;
            }

            if (state is ReInitiateLoginError) {
              Future.delayed(Duration(milliseconds: 100), () {
                MessageUtil.displayErrorDialog(
                  context,
                  title: 'OTP Resent Failed',
                  message: state.result.message,
                );
              });
              return;
            }

            if (state is LoginCompleted) {
              Future.delayed(Duration(milliseconds: 100), () {
                context.go(DashboardPage.routeName);
              });
              return;
            }

            if (state is CompleteLoginError) {
              Future.delayed(Duration(milliseconds: 100), () {
                MessageUtil.displayErrorDialog(
                  context,
                  title: 'OTP Verification Failed',
                  message: state.result.message,
                  onOkPressed: () {
                    context.go(NewDeviceLoginPage.routeName);
                  },
                );
              });
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              text: 'Verify',
              onPressed: () {
                context.read<AuthBloc>().add(
                  CompleteLogin(
                    OtpVerificationRequest(otpId: _data.otpData!.otpId, otpValue: _otp),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
