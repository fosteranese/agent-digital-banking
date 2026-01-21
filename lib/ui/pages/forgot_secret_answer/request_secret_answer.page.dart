import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../components/form/button.dart';
import '../../components/form/phone_number.dart';
import '../../layouts/plain_with_header.layout.dart';

class RequestSecretAnswerPage extends StatefulWidget {
  const RequestSecretAnswerPage({super.key});
  static const routeName = '/forgot-secret-question';

  @override
  State<RequestSecretAnswerPage> createState() => _RequestSecretAnswerPageState();
}

class _RequestSecretAnswerPageState extends State<RequestSecretAnswerPage> {
  final _phoneNumberController = TextEditingController();
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return PlainWithHeaderLayout(
      title: 'Forgot Secret Answer',
      subtitle: 'Help me remember my secret answer',
      children: [
        const SizedBox(height: 30),
        FormPhoneInput(
          controller: _phoneNumberController,
          label: 'Phone number *',
          placeholder: 'Enter your phone number',
          onSelectedOption: (option, phoneNumber) {
            _phoneNumber = phoneNumber;
          },
        ),
        const Spacer(),
        const SizedBox(height: 20),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SecretAnswerRetrieved) {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                isDismissible: false,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              context.pop();
                              context.pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xffCEFFCE),
                          child: Icon(Icons.task_alt_outlined, color: Color(0xff067335)),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Phone Number Verified!',
                          textAlign: TextAlign.center,
                          style: PrimaryTextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: PrimaryTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: const Color(0xff4F4F4F),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FormButton(
                          onPressed: () {
                            context.pop();
                            context.pop();
                          },
                          text: 'Ok',
                        ),
                      ],
                    ),
                  );
                },
              );

              return;
            }

            if (state is RetrieveSecretAnswerError) {
              MessageUtil.displayErrorDialog(context, message: state.result.message);
              return;
            }
          },
          builder: (context, state) {
            return FormButton(
              loading: state is RetrievingSecretAnswer,
              text: 'Continue',
              onPressed: () {
                if (_phoneNumberController.text.isEmpty) {
                  MessageUtil.displayErrorDialog(context, message: "Phone number is required");
                  return;
                }
                if (_phoneNumber.isEmpty) {
                  MessageUtil.displayErrorDialog(
                    context,
                    message: "Phone number entered is invalid",
                  );
                  return;
                }

                context.read<AuthBloc>().add(RetrieveSecretAnswer(_phoneNumber));
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
