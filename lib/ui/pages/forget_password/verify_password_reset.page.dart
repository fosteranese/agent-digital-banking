import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/forgot_password/forgot_password.request.dart';
import 'package:my_sage_agent/data/models/forgot_password/forgot_password.response.dart';
import 'package:my_sage_agent/data/models/otp_verification.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/otp.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/forget_password/reset_password.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class VerifyPasswordResetPage extends StatefulWidget {
  const VerifyPasswordResetPage({super.key});
  static const routeName = '/forgot-password/verify';

  @override
  State<VerifyPasswordResetPage> createState() => _VerifyPasswordResetPageState();
}

class _VerifyPasswordResetPageState extends State<VerifyPasswordResetPage> {
  late final ForgotPasswordResponse _data;
  String _otp = '';
  late ForgotPasswordRequest _resendPayload;

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is ForgotPasswordInitiated) {
      _data = state.data;
      _resendPayload = state.resendPassword;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: _data.otpData?.title ?? '',
      subtitle: _data.otpData?.message ?? '',
      children: [
        Otp(
          length: _data.otpData!.length!,
          onCompleted: (otp) {
            _otp = otp;
            context.read<AuthBloc>().add(
              VerifyForgotPassword(
                OtpVerificationRequest(otpId: _data.otpData!.otpId, otpValue: otp),
              ),
            );
          },
          onResendShortCode: () {
            context.read<AuthBloc>().add(ReInitiateForgotPassword(_resendPayload));
          },
        ),
        const Spacer(),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgotPasswordReInitiated) {
              _data = state.data;
              _resendPayload = state.resendPassword;
              context.push(VerifyPasswordResetPage.routeName);
              return;
            }

            if (state is ReInitiateForgotPasswordError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }

            if (state is ForgotPasswordVerified) {
              context.push(ResetPasswordPage.routeName);
              return;
            }

            if (state is VerifyForgotPasswordError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is VerifyingForgotPassword || state is ReInitiatingForgotPassword,
              text: 'Verify',
              onPressed: () {
                context.read<AuthBloc>().add(
                  VerifyForgotPassword(
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
