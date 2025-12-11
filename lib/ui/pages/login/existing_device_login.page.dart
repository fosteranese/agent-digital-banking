import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/utils/theme.util.dart';
import 'package:agent_digital_banking/blocs/auth/auth_bloc.dart';
import 'package:agent_digital_banking/blocs/biometric/biometric_bloc.dart';
import 'package:agent_digital_banking/constants/status.const.dart';
import 'package:agent_digital_banking/data/models/unlock_screen.request.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/components/form/password_input.dart';
import 'package:agent_digital_banking/ui/pages/dashboard/dashboard.page.dart';
import 'package:agent_digital_banking/ui/pages/forget_password/request_password_reset.page.dart';
import 'package:agent_digital_banking/ui/pages/login/new_device_login.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/biometric.util.dart';
import 'package:agent_digital_banking/utils/help.util.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class ExistingDeviceLoginPage extends StatefulWidget {
  const ExistingDeviceLoginPage(this.autoShowBiometric, {super.key});

  static const routeName = '/login/existing-device-login';
  final bool autoShowBiometric;

  @override
  State<ExistingDeviceLoginPage> createState() => _ExistingDeviceLoginPageState();
}

class _ExistingDeviceLoginPageState extends State<ExistingDeviceLoginPage> {
  final _passwordController = TextEditingController();
  bool isBioLogin = false;

  @override
  void initState() {
    super.initState();
    final biometricBloc = context.read<BiometricBloc>();

    if (widget.autoShowBiometric && biometricBloc.isAutoLoginEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _unlockWithBiometric();
      });
    }
  }

  void _unlockWithBiometric() {
    BiometricUtil.authenticateWithBiometrics(() {
      isBioLogin = true;
      context.read<AuthBloc>().add(const UnLockScreen(UnLockScreenRequest(isPassword: false, password: '')));
    });
  }

  void _unlockWithPassword() {
    if (_passwordController.text.isEmpty) {
      MessageUtil.displayErrorDialog(context, message: "Password is required");
      return;
    }

    isBioLogin = false;
    context.read<AuthBloc>().add(UnLockScreen(UnLockScreenRequest(isPassword: true, password: _passwordController.text)));
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final biometricEnabled = context.read<BiometricBloc>().isLoginEnabled;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Image.asset(
          'assets/img/login.png',
          fit: BoxFit.cover,
          // height: 1000,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/img/login.png',
                fit: BoxFit.cover,
                // height: 1000,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withAlpha(163), Colors.transparent]),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.04),
                      _buildLogo(),
                      const Spacer(),
                      _buildWelcomeText(),
                      SizedBox(height: screenHeight * 0.03),
                      _buildPasswordField(biometricEnabled),
                      const Spacer(flex: 2),
                      _buildSignInButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                right: 0,
                child: InkWell(
                  onTap: () {
                    HelpUtil.show(onCancelled: () {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 90,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.help_outline, color: Colors.black),
                          SizedBox(width: 5),
                          Text(
                            'Help',
                            style: PrimaryTextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() => Image.asset('assets/img/logo.png', width: 130);

  Widget _buildWelcomeText() {
    final name = AppUtil.currentUser.user?.shortName ?? 'Boss';
    return Column(
      children: [
        Text(
          'Welcome $name',
          style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Text('Kindly enter your password', style: PrimaryTextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildPasswordField(bool biometricEnabled) {
    return FormPasswordInput(
      controller: _passwordController,
      placeholder: 'Password',
      color: const Color(0x8FB7B7B7),
      focusedColor: Colors.white,
      placeholderStyle: PrimaryTextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
      visibilityColor: Colors.white,
      visibilityFocusedColor: Colors.black,
      visibilityBorderColor: Colors.transparent,
      textInputAction: TextInputAction.done,
      info: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            if (biometricEnabled)
              InkWell(
                onTap: _unlockWithBiometric,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/img/face-id.svg'),
                    SizedBox(width: 10),
                    Text(
                      'Biometric Login',
                      style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            Spacer(),
            InkWell(
              onTap: () => context.push(RequestPasswordResetPage.routeName),
              child: Text(
                "Forgot password?",
                style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton() => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is UnLockingScreen && isBioLogin) {
        MessageUtil.displayLoading(context);
      } else if (state is ScreenUnLocked) {
        if (isBioLogin) {
          context.pop();
        }
        context.go(DashboardPage.routeName);
      } else if (state is UnlockScreenError) {
        if (isBioLogin) {
          context.pop();
        }
        MessageUtil.displayErrorDialog(
          context,
          message: state.result.message,
          onOkPressed: () {
            if (state.result.code == StatusCodeConstants.newLogin) {
              context.pushReplacement(NewDeviceLoginPage.routeName);
            }
          },
        );
      }
    },
    builder: (context, state) {
      return FormButton(loading: state is UnLockingScreen && !isBioLogin, backgroundColor: ThemeUtil.secondaryColor, foregroundColor: ThemeUtil.primaryColor, text: 'Sign in', onPressed: _unlockWithPassword);
    },
  );

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
