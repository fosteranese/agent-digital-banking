import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/otp_verification.request.dart';
import 'package:my_sage_agent/data/models/verify_ghana_card_response.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/otp.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:my_sage_agent/ui/pages/signup/account_holder/setup_account_password.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class OtpAccountVerificationPage extends StatefulWidget {
  const OtpAccountVerificationPage({super.key});
  static const routeName = '/signup/account-holder/otp';

  @override
  State<OtpAccountVerificationPage> createState() => _OtpAccountVerificationPageState();
}

class _OtpAccountVerificationPageState extends State<OtpAccountVerificationPage> {
  late VerifyGhanaCardResponse _data;
  late String _resendPayload;
  String _otp = '';

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is GhanaCardVerified) {
      _data = state.data;
      _resendPayload = state.resendPayload;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ReVerifyingGhanaCard) {
          MessageUtil.displayLoading(context);
          return;
        }

        if (state is GhanaCardReVerified) {
          context.pop();
          _resendPayload = state.resendPayload;

          MessageUtil.displaySuccessDialog(context, message: 'Code resent');
          return;
        }

        if (state is ReVerifyGhanaCardError) {
          context.pop();
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }

        if (state is VerifyingOtp) {
          // MessageUtil.displayLoading(
          //   context,
          //   message: 'Verifying',
          // );
          return;
        }

        if (state is OtpVerified) {
          // context.pop();
          context.push(SetupAccountPasswordPage.routeName);
          return;
        }

        if (state is VerifyOtpError) {
          // context.pop();
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }
      },
      builder: (context, state) => PlainWithHeaderLayout(
        onBackPressed: () {
          Navigator.popUntil(context, ModalRoute.withName(SetupAccountPage.routeName));
        },
        title: _data.otpData!.title ?? '',
        subtitle: _data.otpData!.message ?? '',
        children: [
          Otp(
            length: _data.otpData!.length ?? 6,
            onCompleted: (otp) {
              _otp = otp;
              context.read<AuthBloc>().add(
                VerifyOtp(
                  payload: OtpVerificationRequest(otpId: _data.otpData?.otpId, otpValue: _otp),
                  isNewCustomer: false,
                ),
              );
            },
            onResendShortCode: () {
              context.read<AuthBloc>().add(ReVerifyPicture(registrationId: _resendPayload));
            },
          ),
          const Spacer(),
          FormButton(
            loading: state is VerifyingOtp,
            text: 'Verify',
            onPressed: () {
              context.read<AuthBloc>().add(
                VerifyOtp(
                  payload: OtpVerificationRequest(otpId: _data.otpData?.otpId, otpValue: _otp),
                  isNewCustomer: false,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
