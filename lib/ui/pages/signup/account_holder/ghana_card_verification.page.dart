import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/data/models/verification.response.dart';
import 'package:agent_digital_banking/ui/components/verification_modes/verification.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/otp_account_verification.page.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class GhanaCardVerificationPage extends StatefulWidget {
  const GhanaCardVerificationPage({super.key});
  static const routeName = '/signup/account-holder/id-verification';

  @override
  State<GhanaCardVerificationPage> createState() => _GhanaCardVerificationPageState();
}

class _GhanaCardVerificationPageState extends State<GhanaCardVerificationPage> {
  late final VerificationResponse _data;

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is CustomerDetailsSubmitted) {
      _data = state.data;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyingGhanaCard) {
          MessageUtil.displayLoading(context);
          return;
        }

        if (state is GhanaCardVerified) {
          context.pop();
          context.push(OtpAccountVerificationPage.routeName);
          return;
        }

        if (state is VerifyGhanaCardError) {
          context.pop();
          MessageUtil.displayErrorDialog(context, message: state.result.message);
          return;
        }
      },
      child: Verification(
        action: 'SIGNUP',
        data: VerificationResponse(ghCardUrl: _data.ghCardUrl, registrationId: _data.registrationId, imageBaseUrl: _data.imageBaseUrl, accessType: _data.accessType),
        onVerify: (image, code) {
          context.read<AuthBloc>().add(VerifyPicture(registrationId: _data.registrationId!, picture: image, code: code));
        },
        onBack: () {
          context.pop();
        },
      ),
    );
  }
}
