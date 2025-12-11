import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/data/models/otp_verification.request.dart';
import 'package:agent_digital_banking/data/models/verify_ghana_card_response.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/otp_single.dart';
import 'package:agent_digital_banking/ui/layouts/plain.layout.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/setup_non_account_password.page.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class NonAccountVerificationPage extends StatefulWidget {
  const NonAccountVerificationPage({super.key});
  static const routeName = '/signup/non-account-holder/verify';

  @override
  State<NonAccountVerificationPage> createState() => _NonAccountVerificationPageState();
}

class _NonAccountVerificationPageState extends State<NonAccountVerificationPage> {
  final _loader = Loader();
  late VerifyGhanaCardResponse _data;
  late String _resendPayload;
  String _otp = '';

  @override
  void initState() {
    final bloc = context.read<AuthBloc>();
    final state = bloc.state;
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
          _loader.start('Resending');
          return;
        }

        if (state is GhanaCardReVerified) {
          _loader.stop();
          _resendPayload = state.resendPayload;

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displaySuccessDialog(context, message: 'Code resent');
          });
          return;
        }

        if (state is ReVerifyGhanaCardError) {
          _loader.stop();

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
          });
          return;
        }

        if (state is VerifyingOtp) {
          _loader.start('Verifying');
          return;
        }

        if (state is OtpVerified) {
          _loader.stop();
          Navigator.pushNamed(context, SetupNonAccountPasswordPage.routeName);
          return;
        }

        if (state is VerifyOtpError) {
          _loader.stop();

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
          });
          return;
        }
      },
      builder: (context, state) {
        return PlainLayout(
          children: [
            Text(
              _data.otpData?.title ?? '',
              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              _data.otpData?.message ?? '',
              style: const TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 30),
            OtpSingle(
              length: _data.otpData!.length ?? 6,
              onCompleted: (otp) {
                _otp = otp;
                context.read<AuthBloc>().add(
                  VerifyOtp(
                    payload: OtpVerificationRequest(otpId: _data.otpData?.otpId, otpValue: _otp),
                    isNewCustomer: true,
                  ),
                );
              },
              onResendShortCode: () {
                context.read<AuthBloc>().add(ReVerifyPicture(registrationId: _resendPayload, isNewCustomer: true));
              },
            ),
            const Spacer(),
            FormButton(
              onPressed: () {
                if (_otp.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Invalid OTP. Enter a valid OTP");
                  return;
                }
                context.read<AuthBloc>().add(
                  VerifyOtp(
                    payload: OtpVerificationRequest(otpId: _data.otpData?.otpId, otpValue: _otp),
                    isNewCustomer: true,
                  ),
                );
              },
              text: 'Verify',
            ),
          ],
        );
      },
    );
  }
}
