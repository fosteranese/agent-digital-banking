import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/setup/setup_bloc.dart';
import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/components/popover.dart';
import 'package:my_sage_agent/ui/layouts/plain_with_header.layout.dart';
import 'package:my_sage_agent/utils/loader.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class AccessTypeVerification extends StatefulWidget {
  const AccessTypeVerification({super.key, required this.data, required this.onVerify, this.onSkip, this.onBack, required this.action});

  final VerificationResponse data;
  final void Function(String picture, String code) onVerify;
  final void Function()? onSkip;
  final void Function()? onBack;
  final String action;

  @override
  State<AccessTypeVerification> createState() => _AccessTypeVerificationState();
}

class _AccessTypeVerificationState extends State<AccessTypeVerification> {
  final _loader = Loader();
  final _accessCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _uid = const Uuid().v8g();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SetupBloc, SetupState>(
        listener: (context, state) {
          if (state is RetrievingAccessCode) {
            _loader.start('Resetting');
            return;
          }

          if (state is AccessCodeRetrieved) {
            _loader.stop();
            MessageUtil.displaySuccessDialog(context, message: state.result.message);
            return;
          }

          if (state is RetrieveAccessCodeError) {
            _loader.stop();

            Future.delayed(const Duration(seconds: 0), () {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
            });
            return;
          }
        },
        child: PlainWithHeaderLayout(
          onBackPressed: () {
            Navigator.pop(context);
          },
          useCloseIcon: true,
          title: 'Access Code',
          subtitle: 'Enter the Access Code sent to your email address and phone number',
          children: [
            const SizedBox(height: 30),
            FormPasswordInput(
              controller: _accessCodeController,
              label: 'Access Code *',
              // placeholder: 'Password',
              keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
              labelStyle: Theme.of(context).textTheme.labelMedium,
              visibilityColor: Colors.black,
              info: InkWell(
                onTap: () {
                  _showFilter();
                },
                child: Text(
                  'Resend access code',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 20),
            FormButton(
              onPressed: () {
                if (_accessCodeController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: 'Access Code is required');
                  return;
                }

                widget.onVerify('', _accessCodeController.text);
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }

  void _showFilter() {
    _emailAddressController.text = '';
    _phoneNumberController.text = '';

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: MyApp.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) {
        return PopOver(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Request for Access Code',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: const Color(0xff010203)),
                ),
                const SizedBox(height: 5),
                Text(
                  'Please enter your email address and phone number linked to your account',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xff919195)),
                ),
                const SizedBox(height: 30),
                FormInput(label: 'Phone Number *', controller: _phoneNumberController, keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false)),
                FormInput(label: 'Email Address', controller: _emailAddressController),
                const SizedBox(height: 20),
                FormButton(
                  text: 'Send',
                  onPressed: () {
                    if (_phoneNumberController.text.trim().isEmpty) {
                      MessageUtil.displayErrorDialog(context, message: 'Phone number is required');
                      return;
                    } else if (_emailAddressController.text.trim().isNotEmpty && !isEmail(_emailAddressController.text.trim())) {
                      MessageUtil.displayErrorDialog(context, message: 'Email address is not valid');
                      return;
                    }

                    context.read<SetupBloc>().add(RetrieveAccessCode(routeName: _uid, registrationId: widget.data.registrationId ?? '', phoneNumber: _phoneNumberController.text.trim(), emailAddress: _emailAddressController.text.trim(), action: widget.action));
                    Navigator.pop(MyApp.navigatorKey.currentContext!);
                  },
                ),
                const SizedBox(height: 20),
                FormOutlineButton(
                  side: const BorderSide(color: Colors.transparent, width: 0, style: BorderStyle.none),
                  text: 'Cancel',
                  textStyle: const TextStyle(fontSize: 16, color: Color(0xff919195), fontWeight: FontWeight.bold),
                  onPressed: () {
                    _emailAddressController.text = '';
                    _phoneNumberController.text = '';

                    Navigator.pop(MyApp.navigatorKey.currentContext!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _accessCodeController.dispose();
    _phoneNumberController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }
}
