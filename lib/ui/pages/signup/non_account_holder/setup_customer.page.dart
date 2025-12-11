import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/blocs/setup/setup_bloc.dart';
import 'package:agent_digital_banking/data/models/account_opening_lovs.dart';
import 'package:agent_digital_banking/data/models/non_customer_sign_up/non_customer_sign_up.request.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/ghana_card_input.dart';
import 'package:agent_digital_banking/ui/components/form/input.dart';
import 'package:agent_digital_banking/ui/components/form/phone_number.dart';
import 'package:agent_digital_banking/ui/components/form/select.dart';
import 'package:agent_digital_banking/ui/layouts/plain_with_header.layout.dart';
import 'package:agent_digital_banking/ui/pages/signup/non_account_holder/non_account_ghana_card_verification.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/loader.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class SetupCustomerPage extends StatefulWidget {
  const SetupCustomerPage({super.key});
  static const routeName = '/signup/non-account-holder/setup-customer';

  @override
  State<SetupCustomerPage> createState() => _SetupCustomerPageState();
}

class _SetupCustomerPageState extends State<SetupCustomerPage> {
  final _loader = Loader();

  final _emailController = TextEditingController();
  final _ghanaCardController = TextEditingController();
  final _preferredBranchController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _residentialAddressController = TextEditingController();
  final _cityController = TextEditingController();
  String _phoneNumber = '';
  AccountOpeningLovs _lovs = AccountOpeningLovs();

  @override
  void initState() {
    context.read<SetupBloc>().add(const RetrieveAccountOpeningLOVs(routeName: SetupCustomerPage.routeName));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SubmittingNewCustomerDetails) {
          _loader.start('Loading');
          return;
        }

        if (state is NewCustomerDetailsSubmitted) {
          _loader.stop();

          Navigator.pushNamed(context, NonAccountIdVerificationPage.routeName, arguments: state.data);
          return;
        }

        if (state is SubmitNewCustomerDetailsError) {
          _loader.stop();

          Future.delayed(const Duration(seconds: 0), () {
            MessageUtil.displayErrorDialog(context, message: state.result.message);
          });
          return;
        }
      },
      child: BlocBuilder<SetupBloc, SetupState>(
        builder: (context, state) {
          if (state is AccountOpeningLOVsRetrieved) {
            _lovs = state.result.data!;
          }

          return PlainWithHeaderLayout(
            useCloseIcon: true,
            title: 'Open a UMB Account',
            subtitleWidget: RichText(
              text: TextSpan(
                children: [TextSpan(text: 'Complete the form below to open an account with us for a new banking experience')],
                style: PrimaryTextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            children: [
              FormPhoneInput(
                controller: _phoneNumberController,
                label: 'Phone number *',
                onSelectedOption: (option, phoneNumber) {
                  _phoneNumber = phoneNumber;
                },
              ),
              FormInput(label: 'Email Address *', controller: _emailController),
              GhanaCardInput(
                // label: 'Ghana Card Number',
                controller: _ghanaCardController,
                isRequired: true,
                // placeholder: 'GHA-7123456-9',
              ),
              FormSelect(
                controller: _preferredBranchController,
                label: 'Preferred Branch *',
                title: 'Choose Preferred Branch',
                options: _lovs.branches?.map((lov) => FormSelectOption(value: lov.value ?? '', text: lov.key, data: lov)).toList() ?? [],
                loading: state is RetrievingAccountOpeningLOVs,
              ),
              FormSelect(
                controller: _accountTypeController,
                label: 'Account Type *',
                title: 'Choose Account Type',
                options: _lovs.accountTypes?.map((lov) => FormSelectOption(value: lov.value ?? '', text: lov.key, data: lov)).toList() ?? [],
                loading: state is RetrievingAccountOpeningLOVs,
              ),
              const Spacer(),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text('By clicking on continue, you accept our ', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: Colors.black)),
                    InkWell(
                      onTap: () {
                        final url = Uri.parse(AppUtil.data.help?.termsUrl ?? '');
                        launchUrl(url);
                      },
                      child: Text('Terms of Use ', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, decoration: TextDecoration.underline)),
                    ),
                    Text('and ', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: Colors.black)),
                    InkWell(
                      onTap: () {
                        final url = Uri.parse(AppUtil.data.help?.privacyUrl ?? '');
                        launchUrl(url);
                      },
                      child: Text('Privacy Policy', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FormButton(
                onPressed: () {
                  if (_phoneNumberController.text.isEmpty) {
                    MessageUtil.displayErrorDialog(context, message: "Phone number is required");
                    return;
                  }
                  if (_phoneNumber.isEmpty) {
                    MessageUtil.displayErrorDialog(context, message: "Phone number entered is invalid");
                    return;
                  }

                  if (_emailController.text.trim().isEmpty) {
                    MessageUtil.displayErrorDialog(context, message: "Email Address is required");
                    return;
                  }
                  if (!isEmail(_emailController.text.trim())) {
                    MessageUtil.displayErrorDialog(context, message: "Email Address is invalid");
                    return;
                  }

                  if (_ghanaCardController.text.isEmpty) {
                    MessageUtil.displayErrorDialog(context, message: "Ghana Card Number is required");
                    return;
                  }

                  if (_preferredBranchController.text.isEmpty) {
                    MessageUtil.displayErrorDialog(context, message: "Preferred Branch is required");
                    return;
                  }
                  if (_accountTypeController.text.isEmpty) {
                    MessageUtil.displayErrorDialog(context, message: "Account Type is required");
                    return;
                  }

                  final payload = NonCustomerSignUpRequest(cardNumber: _ghanaCardController.text.trim(), phoneNumber: _phoneNumber, email: _emailController.text.trim(), accountType: _accountTypeController.text.trim(), branch: _preferredBranchController.text.trim(), residentialAddress: _residentialAddressController.text.trim(), city: _cityController.text.trim());
                  context.read<AuthBloc>().add(NewCustomerSignUp(payload));
                },
                text: 'Continue',
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _ghanaCardController.dispose();
    _preferredBranchController.dispose();
    _accountTypeController.dispose();
    _phoneNumberController.dispose();
    _residentialAddressController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
