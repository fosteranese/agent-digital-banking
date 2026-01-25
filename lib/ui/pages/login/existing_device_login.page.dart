import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_sage_agent/ui/layouts/background.layout.dart';

import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:my_sage_agent/blocs/auth/auth_bloc.dart';
import 'package:my_sage_agent/blocs/biometric/biometric_bloc.dart';
import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/models/unlock_screen.request.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/password_input.dart';
import 'package:my_sage_agent/ui/pages/dashboard/dashboard.page.dart';
import 'package:my_sage_agent/ui/pages/login/new_device_login.page.dart';
import 'package:my_sage_agent/utils/app.util.dart';
import 'package:my_sage_agent/utils/biometric.util.dart';
import 'package:my_sage_agent/utils/message.util.dart';

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
      context.read<AuthBloc>().add(
        const UnLockScreen(UnLockScreenRequest(isPassword: false, password: '')),
      );
    });
  }

  void _unlockWithPassword() {
    if (_passwordController.text.isEmpty) {
      MessageUtil.displayErrorDialog(context, message: "Password is required");
      return;
    }

    isBioLogin = false;
    context.read<AuthBloc>().add(
      UnLockScreen(UnLockScreenRequest(isPassword: true, password: _passwordController.text)),
    );
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final biometricEnabled = context.read<BiometricBloc>().isLoginEnabled;

    return BackgroundLayout(
      title: 'Sign in to your existing account',
      children: [
        const SizedBox(height: 30),
        _buildWelcomeText(),
        const SizedBox(height: 30),
        Spacer(),
        FormPasswordInput(
          controller: _passwordController,
          label: 'Password',
          labelStyle: GoogleFonts.mulish(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          placeholder: 'Password',
          color: Colors.white,
          visibilityColor: Colors.black,
        ),
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
        Spacer(flex: 3),
        _buildSignInButton(),
      ],
    );
  }

  Widget _buildWelcomeText() {
    final name = AppUtil.currentUser.user?.shortName ?? 'Boss';
    return Row(
      children: [
        SvgPicture.asset('assets/img/welcome-user.svg'),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Welcome back',
                style: PrimaryTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                name,
                style: PrimaryTextStyle(color: Colors.white, fontSize: 20, fontWeight: .bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is UnLockingScreen) {
        MessageUtil.displayLoading(context);
      } else {
        MessageUtil.stopLoading(context);
      }

      if (state is ScreenUnLocked) {
        context.go(DashboardPage.routeName);
        return;
      }

      if (state is UnlockScreenError) {
        MessageUtil.displayErrorDialog(
          context,
          message: state.result.message,
          onOkPressed: () {
            if (state.result.code == StatusCodeConstants.newLogin) {
              context.pushReplacement(NewDeviceLoginPage.routeName);
            }
          },
        );
        return;
      }
    },
    builder: (context, state) {
      return FormButton(
        backgroundColor: ThemeUtil.secondaryColor,
        foregroundColor: ThemeUtil.black,
        text: 'Log In',
        onPressed: _unlockWithPassword,
      );
    },
  );

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
