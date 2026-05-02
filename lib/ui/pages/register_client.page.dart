import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_3.cm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:string_validator/string_validator.dart';
import 'package:uuid/uuid.dart';

import 'package:my_sage_agent/blocs/registration/registration_bloc.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/register/ghana_card_verification_notice.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_1.cm.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_2.cm.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_4.cm.dart';
import 'package:my_sage_agent/ui/components/step_indicator.cm.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/verification_modes/ghana_card_verification.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';

enum RegisterStep { personalInfo, contactDetails, nextOfKin, identityVerification }

class RegisterClientPage extends StatefulWidget {
  const RegisterClientPage({super.key});
  static const String routeName = '/register/step-1';

  @override
  State<RegisterClientPage> createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends State<RegisterClientPage> {
  final _stage = ValueNotifier(RegisterStep.personalInfo);
  final _pageController = PageController(initialPage: 0);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final cardNumberController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final emergencyContactController = TextEditingController();

  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final regionController = TextEditingController();
  final cityOrTownController = TextEditingController();

  final transactionNotificationController = TextEditingController();
  final withdrawalOptionController = TextEditingController();

  final kinFullNameController = TextEditingController();
  final kinPhoneNumberController = TextEditingController();
  final kinEmailAddressController = TextEditingController();

  final _isCameraAvailable = ValueNotifier(true);

  void _onManual() {
    // context.pop();
    _isCameraAvailable.value = false;
    _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  final stageTitles = ['Personal Info', 'Contact Details', 'Next of KIN', 'Identity Verification'];

  void _onStartGhanaCardVerification(BuildContext mainContext) async {
    context.pop();
    await Permission.camera
        .onDeniedCallback(_onManual)
        .onGrantedCallback(() {
          mainContext.push(
            GhanaCardVerification.routeName,
            extra: GhanaCardVerification(
              mainContext: mainContext,
              onVerify: (picture, _) {
                mainContext.read<RegistrationBloc>().add(VerifyPicture(picture: picture));
              },
              onManualVerification: () {
                _pageController.animateToPage(
                  2,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          );
        })
        .onPermanentlyDeniedCallback(_onManual)
        .onRestrictedCallback(_onManual)
        .onLimitedCallback(_onManual)
        .onProvisionalCallback(_onManual)
        .request();
  }

  @override
  Widget build(BuildContext mainContext) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Builder(
        builder: (context) {
          return MainLayout(
            showBackBtn: true,
            useSafeArea: false,
            title: 'Register Client',
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: MyHeaderDelegate(
                  maxHeight: 80,
                  minHeight: 80,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return Container(
                      color: Colors.white,
                      child: Container(
                        margin: const .symmetric(vertical: 20),
                        color: Color(0xffF1F4FB),
                        child: ValueListenableBuilder(
                          valueListenable: _stage,
                          builder: (context, stage, child) {
                            return ListView(
                              padding: const .only(left: 20),
                              scrollDirection: .horizontal,
                              children: [
                                for (var i = 0; i < stageTitles.length; i++)
                                  StepIndicator(
                                    index: i,
                                    currentIndex: stage.index,
                                    title: stageTitles[i],
                                    onPressed: () {
                                      _pageController.animateToPage(
                                        i,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      _stage.value = RegisterStep.values[i];
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  primary: false,
                  body: BlocListener<RegistrationBloc, RegistrationState>(
                    listener: (_, state) => _registrationListener(context, state),
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        _stage.value = RegisterStep.values[index];
                      },
                      children: [
                        RegisterClientStep1(
                          emailAddress: emailAddressController,
                          firstName: firstNameController,
                          lastName: lastNameController,
                          gender: genderController,
                          phoneNumber: phoneNumberController,
                          cardNumber: cardNumberController,
                          maritalStatus: maritalStatusController,
                        ),
                        RegisterClientStep2(
                          address1: address1Controller,
                          address2: address2Controller,
                          region: regionController,
                          cityOrTown: cityOrTownController,
                          emergencyContact: emergencyContactController,
                          transactionNotification: transactionNotificationController,
                          withdrawalOption: withdrawalOptionController,
                        ),
                        RegisterClientStep3(
                          kinFullName: kinFullNameController,
                          kinPhoneNumber: kinPhoneNumberController,
                          kinEmailAddress: kinEmailAddressController,
                        ),
                        RegisterClientStep4(
                          isCameraAvailable: _isCameraAvailable,
                          onVerify: (cardFront, cardBack) {
                            context.read<RegistrationBloc>().add(
                              ManualVerification(
                                id: Uuid().v4(),
                                cardFront: cardFront,
                                cardBack: cardBack,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _stage,
              builder: (context, value, child) {
                if (value == RegisterStep.identityVerification) {
                  return SizedBox.shrink();
                }

                return SafeArea(
                  top: false,
                  bottom: true,
                  child: Container(
                    padding: .only(left: 20, right: 20, top: 20),
                    child: FormButton(
                      onPressed: () {
                        switch (_stage.value) {
                          case RegisterStep.personalInfo:
                            _savePersonalDetails(context);
                            return;

                          case RegisterStep.contactDetails:
                            _saveResidentialAddress(context);
                            return;

                          case RegisterStep.nextOfKin:
                            _saveNextOfKin(context);
                            return;

                          default:
                            return;
                        }
                      },
                      text: 'Continue',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _registrationListener(BuildContext mainContext, RegistrationState state) {
    if (state is SavingPersonalInfo ||
        state is SavingResidentialAddress ||
        state is SavingNextOfKinInfo ||
        state is VerifyingPicture ||
        state is VerifyingManually) {
      MessageUtil.displayLoading(mainContext);
      return;
    } else {
      MessageUtil.stopLoading(mainContext);
    }

    switch (state) {
      case PersonalInfoSaved _:
        _pageController.animateToPage(
          RegisterStep.contactDetails.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        return;

      case ResidentialAddressSaved _:
        _pageController.animateToPage(
          RegisterStep.nextOfKin.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        return;

      case NextOfKinInfoSaved _:
        _startVerification(mainContext);
        return;

      case PictureVerified state:
        _onVerified(state.response);
        return;

      case ManuallyVerified state:
        _onVerified(state.response);
        return;

      // case VerifyPictureError state:
      //   context.pop();
      //   _pageController.animateToPage(
      //     2,
      //     duration: Duration(milliseconds: 300),
      //     curve: Curves.easeIn,
      //   );
      //   _onVerifiedFailed(state.error);
      //   return;

      case SavePersonalInfoError state:
        _onVerifiedFailed(state.error);
        return;

      case SaveResidentialAddressError state:
        _onVerifiedFailed(state.error);
        return;

      case ManualVerificationError state:
        _onVerifiedFailed(state.error);
        return;

      case SaveNextOfKinInfoError state:
        _onVerifiedFailed(state.error);
        return;
    }
  }

  void _onVerified(Response response) {
    context.go(DashboardPage.routeName);
    Future.delayed(Duration(milliseconds: 100), () {
      MessageUtil.displaySuccessFullDialog(
        MyApp.navigatorKey.currentContext!,
        message: response.message,
        onOk: () {
          context.go(DashboardPage.routeName);
        },
      );
    });
  }

  void _onVerifiedFailed(Response error) {
    Future.delayed(Duration(milliseconds: 100), () {
      MessageUtil.displayErrorDialog(MyApp.navigatorKey.currentContext!, message: error.message);
    });
  }

  void _startVerification(BuildContext mainContext) {
    showModalBottomSheet(
      context: mainContext,
      useSafeArea: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return GhanaCardVerificationNotice(
          onStartGhanaCardVerification: () => _onStartGhanaCardVerification(mainContext),
        );
      },
    );
  }

  void _savePersonalDetails(BuildContext context) {
    final fullName = firstNameController.text.trim();
    if (fullName.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Full name is required.\nEnter full name to proceed.',
      );
      return;
    }

    final gender = genderController.text.trim();
    if (gender.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Gender is required.\nEnter gender to proceed.',
      );
      return;
    }

    final phoneNumber = phoneNumberController.text
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    if (phoneNumber.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Phone number is required.\nEnter phone number to proceed.',
      );
      return;
    } else if (!phoneNumber.isNumeric || (phoneNumber.length != 10 && phoneNumber.length != 12)) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message:
            'Invalid phone number.\nEnter a correct phone number to proceed.\nExample: 0244123654',
      );
      return;
    }

    final emailAddress = emailAddressController.text.trim();
    if (emailAddress.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Email Address is required.\nEnter email address to proceed.',
      );
      return;
    } else if (!emailAddress.isEmail) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Invalid Email Address.\nEnter a valid email address to proceed.',
      );
      return;
    }

    final cardNumber = cardNumberController.text.trim();
    if (cardNumber.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Ghana Card No. is required.\nEnter the ghana card number to proceed.',
      );
      return;
    }

    final maritalStatus = maritalStatusController.text.trim();
    if (maritalStatus.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Marital Status is required.\nEnter the marital status to proceed.',
      );
      return;
    }

    context.read<RegistrationBloc>().add(
      SavePersonalInfo(
        firstName: fullName,
        lastName: lastNameController.text,
        gender: gender,
        phoneNumber: phoneNumber,
        emailAddress: emailAddress,
        cardNumber: cardNumber,
        maritalStatus: maritalStatus,
      ),
    );
  }

  void _saveResidentialAddress(BuildContext context) {
    final address1 = address1Controller.text.trim();
    if (address1.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Address Line 1 is required.\nEnter Address Line 1 to proceed.',
      );
      return;
    }

    final region = regionController.text.trim();
    if (region.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Region is required.\nEnter region to proceed.',
      );
      return;
    }

    final cityOrTown = cityOrTownController.text.trim();
    if (cityOrTown.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Town/city is required.\nEnter the town or city to proceed.',
      );
      return;
    }

    final emergencyContact = emergencyContactController.text.trim();
    if (emergencyContact.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Emergency Contact is required.\nEnter the emergency contact to proceed.',
      );
      return;
    }

    final withdrawalOption = withdrawalOptionController.text.trim();
    if (withdrawalOption.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message:
            'Transaction Notification is required.\nEnter the transaction notification to proceed.',
      );
      return;
    }

    final transactionNotification = transactionNotificationController.text.trim();
    if (transactionNotification.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message:
            'Transaction Notification is required.\nEnter the transaction notification to proceed.',
      );
      return;
    }

    context.read<RegistrationBloc>().add(
      SaveResidentialAddress(
        address1: address1,
        address2: address2Controller.text,
        region: region,
        cityOrTown: cityOrTown,
        emergencyContact: emergencyContact,
        withdrawalOption: withdrawalOption,
        transactionNotification: transactionNotification,
      ),
    );
  }

  void _saveNextOfKin(BuildContext context) {
    final fullName = kinFullNameController.text.trim();
    if (fullName.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Next of KIN full name is required.\nEnter Next of KIN full name to proceed.',
      );
      return;
    }

    final phoneNumber = kinPhoneNumberController.text
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    if (phoneNumber.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Next of KIN Phone number is required.\nEnter phone number to proceed.',
      );
      return;
    } else if (!phoneNumber.isNumeric || (phoneNumber.length != 10 && phoneNumber.length != 12)) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message:
            'Invalid Next of KIN phone number.\nEnter a correct phone number to proceed.\nExample: 0244123654',
      );
      return;
    }

    final emailAddress = emailAddressController.text.trim();
    if (emailAddress.isEmpty) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Next of KIN Email Address is required.\nEnter email address to proceed.',
      );
      return;
    } else if (!emailAddress.isEmail) {
      MessageUtil.displayErrorDialog(
        context,
        title: 'Validation Failed',
        message: 'Invalid Next of KIN Email Address.\nEnter a valid email address to proceed.',
      );
      return;
    }

    context.read<RegistrationBloc>().add(
      SaveNextOfKinInfoEvent(
        fullName: kinFullNameController.text,
        phoneNumber: kinPhoneNumberController.text,
        emailAddress: kinEmailAddressController.text,
      ),
    );
  }
}
