import 'package:flutter/material.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';
import 'package:agent_digital_banking/ui/components/form/otp.dart';
import 'package:agent_digital_banking/ui/layouts/plain_with_header.layout.dart';

import '../form/button.dart';

class OtpAuthenticator extends StatefulWidget {
  const OtpAuthenticator({super.key, required this.onSuccess, required this.end, required this.authMode, this.onResendShortCode});

  final void Function(String secretAnswer) onSuccess;
  final VoidCallback end;
  final Map<String, dynamic> authMode;
  final VoidCallback? onResendShortCode;

  @override
  State<OtpAuthenticator> createState() => _OtpAuthenticatorState();
}

class _OtpAuthenticatorState extends State<OtpAuthenticator> {
  late final Map<String, dynamic> _authModeData;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _authModeData = widget.authMode['data'] ?? {};
  }

  void _handleVerification() {
    if (_otp.isNotEmpty) {
      widget.onSuccess(_otp);
      widget.end();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the OTP before verifying')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = _authModeData['fieldCaption'] ?? 'Verify OTP';
    final String subtitle = _authModeData['description'] ?? 'Enter the OTP sent to your device';
    final int otpLength = _authModeData['fieldLength'] ?? 6;

    return PlainWithHeaderLayout(
      title: title,
      subtitleWidget: Text(subtitle, style: PrimaryTextStyle(color: Color(0xff4F4F4F), fontSize: 16)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormButton(text: 'Verify', onPressed: _handleVerification),
            const SizedBox(height: 15),
            FormButton(backgroundColor: Color(0xffF8F8F8), foregroundColor: Colors.black, text: 'Cancel', onPressed: widget.end),
          ],
        ),
      ),
      children: [
        // const SizedBox(height: 30),
        Otp(
          length: otpLength,
          onResendShortCode: widget.onResendShortCode,
          onCompleted: (otp) {
            setState(() => _otp = otp);
            widget.onSuccess(otp);
            widget.end();
          },
        ),
        const Spacer(),
      ],
    );
  }
}
