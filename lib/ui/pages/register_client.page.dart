import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/ui/components/register/ghana_card_verification_notice.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_sage_agent/blocs/registration/registration_bloc.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_1.cm.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_2.cm.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_3.cm.dart';
import 'package:my_sage_agent/ui/components/step_indicator.cm.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/components/verification_modes/ghana_card_verification.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:string_validator/string_validator.dart';

enum RegisterStep { personalInfo, residentialAddress, identityVerification }

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

  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final regionController = TextEditingController();
  final cityOrTownController = TextEditingController();

  final _isCameraAvailable = ValueNotifier(true);

  void _onManual() {
    context.pop();
    _isCameraAvailable.value = false;
    _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  final stageTitles = ['Personal Info', 'Residential Address', 'Identity Verification'];

  void _onStartGhanaCardVerification(BuildContext context) async {
    await Permission.camera
        .onDeniedCallback(_onManual)
        .onGrantedCallback(() {
          context.push(
            GhanaCardVerification.routeName,
            extra: GhanaCardVerification(
              onVerify: (picture, code) {
                context.read<RegistrationBloc>().add(VerifyPicture(picture: picture));
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
      child: MainLayout(
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
                listener: (_, state) => _registrationListener(mainContext, state),
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
                    ),
                    RegisterClientStep2(
                      address1: address1Controller,
                      address2: address2Controller,
                      region: regionController,
                      cityOrTown: cityOrTownController,
                    ),
                    RegisterClientStep3(isCameraAvailable: _isCameraAvailable),
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

                      case RegisterStep.residentialAddress:
                        _saveResidentialAddress(context);
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
      ),
    );
  }

  void _registrationListener(BuildContext mainContext, RegistrationState state) {
    if (state is SavingPersonalInfo ||
        state is SavingResidentialAddress ||
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
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        return;

      case ResidentialAddressSaved _:
        _startVerification(context);
        return;

      case PictureVerified state:
        context.go(DashboardPage.routeName);

        Future.delayed(Duration(milliseconds: 100), () {
          MessageUtil.displaySuccessFullDialog(
            MyApp.navigatorKey.currentContext!,
            message: state.response.message,
            onOk: () {
              context.go(DashboardPage.routeName);
            },
          );
        });

        return;

      case VerifyPictureError _:
        _pageController.animateToPage(
          2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        return;
    }
  }

  void _startVerification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return GhanaCardVerificationNotice(
          onStartGhanaCardVerification: () => _onStartGhanaCardVerification(context),
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

    context.read<RegistrationBloc>().add(
      SavePersonalInfo(
        firstName: fullName,
        lastName: lastNameController.text,
        gender: gender,
        phoneNumber: phoneNumber,
        emailAddress: emailAddress,
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

    context.read<RegistrationBloc>().add(
      SaveResidentialAddress(
        address1: address1Controller.text,
        address2: address2Controller.text,
        region: regionController.text,
        cityOrTown: cityOrTownController.text,
      ),
    );
  }
}
