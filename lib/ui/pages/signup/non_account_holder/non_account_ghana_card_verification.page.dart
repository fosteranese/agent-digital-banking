import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../data/models/verification.response.dart';
import '../../../../utils/loader.util.dart';
import '../../../components/verification_modes/verification.dart';
import 'non_account_verification.page.dart';

class NonAccountIdVerificationPage extends StatefulWidget {
  const NonAccountIdVerificationPage({super.key});
  static const routeName = '/signup/non-account-holder/id-verification';

  @override
  State<NonAccountIdVerificationPage> createState() => _NonAccountIdVerificationPageState();
}

class _NonAccountIdVerificationPageState extends State<NonAccountIdVerificationPage> {
  late final VerificationResponse _data;
  final _loader = Loader();
  @override
  void initState() {
    _data = context.read<AuthBloc>().signUp!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyingGhanaCard) {
          _loader.start('Verifying');
          return;
        }

        if (state is GhanaCardVerified) {
          _loader.stop();
          Navigator.pushNamed(context, NonAccountVerificationPage.routeName);
          return;
        }

        if (state is VerifyGhanaCardError) {
          _loader.stop();

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
          });
          return;
        }
      },
      child: Verification(
        action: 'SIGNUP',
        data: VerificationResponse(ghCardUrl: _data.ghCardUrl, registrationId: _data.registrationId, imageBaseUrl: _data.imageBaseUrl, accessType: _data.accessType),
        onVerify: (image, code) {
          context.read<AuthBloc>().add(VerifyPicture(registrationId: _data.registrationId!, picture: image, code: code, isNewCustomer: true));
        },
        onBack: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
