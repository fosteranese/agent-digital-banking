import 'package:flutter/material.dart';

import 'package:my_sage_agent/constants/access_type.const.dart';
import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/ui/components/verification_modes/access_type_verification.dart';
import 'package:my_sage_agent/ui/components/verification_modes/ghana_card_verification.dart';

class Verification extends StatelessWidget {
  const Verification({super.key, required this.data, required this.onVerify, this.onSkip, this.onBack, required this.action});

  final VerificationResponse data;
  final void Function(String picture, String code) onVerify;
  final void Function()? onSkip;
  final void Function()? onBack;
  final String action;

  @override
  Widget build(BuildContext context) {
    if (data.accessType == AccessTypeConst.accessCode) {
      return AccessTypeVerification(
        data: VerificationResponse(ghCardUrl: data.ghCardUrl, registrationId: data.registrationId, imageBaseUrl: data.imageBaseUrl),
        onVerify: onVerify,
        onBack: onBack,
        action: action,
      );
    }

    return GhanaCardVerification(
      data: VerificationResponse(ghCardUrl: data.ghCardUrl, registrationId: data.registrationId, imageBaseUrl: data.imageBaseUrl),
      onVerify: onVerify,
      onBack: onBack,
    );
  }
}
