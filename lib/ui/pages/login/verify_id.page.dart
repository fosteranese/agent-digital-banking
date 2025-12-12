import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/data/models/login/verify_id_response.dart';
import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/ui/components/verification_modes/verification.dart';
import 'package:my_sage_agent/ui/pages/login/secret_answer_login.page.dart';
import 'package:my_sage_agent/ui/pages/login/set_secret_answer_login.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class VerifyIdPage extends StatefulWidget {
  const VerifyIdPage({super.key});
  static const routeName = '/login/id-verification';

  @override
  State<VerifyIdPage> createState() => _VerifyIdPageState();
}

class _VerifyIdPageState extends State<VerifyIdPage> {
  late final VerifyIdResponse _data;
  String phoneNumber = '';
  String password = '';

  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    phoneNumber = context.read<AuthBloc>().phoneNumber;
    password = context.read<AuthBloc>().password;
    if (state is VerifyId) {
      _data = state.result.data!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is VerifyingGhanaCard) {
          MessageUtil.displayLoading(context, message: 'Verifying');
          return;
        }

        if (state is GhanaCardVerified) {
          if (_data.resetSecurityAnswer == '1') {
            context.push(SetSecretAnswerLoginPage.routeName, extra: _data);
          } else {
            context.pop();
            context.push(SecretAnswerLoginPage.routeName);
          }
          return;
        }

        if (state is VerifyGhanaCardError) {
          context.pop();

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
          });
          return;
        }

        if (state is ReLoginInitiated) {
          context.pop();
          context.push(SetSecretAnswerLoginPage.routeName);
          return;
        }

        if (state is ReInitiateLoginError) {
          context.pop();

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
          });
          return;
        }
      },
      child: Verification(
        action: 'SIGNIN',
        data: VerificationResponse(ghCardUrl: _data.ghCardUrl, registrationId: _data.registrationId, imageBaseUrl: _data.imageBaseUrl, accessType: _data.accessType),
        onVerify: (image, code) {
          context.read<AuthBloc>().add(SignInVerifyGhanaCard(registrationId: _data.registrationId ?? '', picture: image, code: code));
        },
        onBack: () {
          context.pop();
        },
      ),
    );
  }
}
