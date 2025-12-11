import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:agent_digital_banking/blocs/app/app_bloc.dart';
import 'package:agent_digital_banking/constants/status.const.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/pages/login/new_device_login.page.dart';
import 'package:agent_digital_banking/ui/pages/signup/account_holder/setup_account.page.dart';
import 'package:agent_digital_banking/utils/app.util.dart';
import 'package:agent_digital_banking/utils/help.util.dart';
import 'package:agent_digital_banking/utils/theme.util.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  static const String routeName = '/welcome';

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        switch (AppUtil.deviceStatus.status) {
          case StatusConstants.pending:
            return const Scaffold(
              body: Center(child: SizedBox(height: 100, width: 100, child: CircularProgressIndicator())),
            );

          case StatusConstants.error:
          case StatusConstants.failed:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SvgPicture.asset(
                      //   'assets/img/error.svg',
                      //   width: 150,
                      // ),
                      Text(AppUtil.deviceStatus.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
              ),
            );
        }

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Image.asset('assets/img/intro-4.png', fit: BoxFit.cover),
              SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset('assets/img/logo.png', width: 130),
                      const Spacer(),
                      const SizedBox(height: 30),

                      Text(
                        'Welcome',
                        style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 34),
                      ),
                      Text(
                        'Let’s Get you Started',
                        style: PrimaryTextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      FormButton(
                        backgroundColor: ThemeUtil.secondaryColor,
                        foregroundColor: ThemeUtil.primaryColor,
                        onPressed: () {
                          context.push(NewDeviceLoginPage.routeName);
                        },
                        text: 'Existing Customer Log In',
                      ),
                      const SizedBox(height: 10),
                      FormButton(
                        backgroundColor: Colors.white,
                        foregroundColor: ThemeUtil.primaryColor,
                        onPressed: () {
                          context.push(SetupAccountPage.routeName);
                        },
                        text: 'I am New to UMB SpeedApp',
                      ),
                      SizedBox(height: 40),
                      // const SizedBox(height: 10),
                      // SizedBox(
                      //   width: double.maxFinite,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       context.push(
                      //         SetupCustomerPage.routeName,
                      //       );
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment:
                      //           MainAxisAlignment.center,
                      //       crossAxisAlignment:
                      //           CrossAxisAlignment.center,
                      //       children: [
                      //         Icon(
                      //           Icons
                      //               .account_balance_wallet_outlined,
                      //           color: Colors.white,
                      //         ),
                      //         const SizedBox(width: 5),
                      //         const Text(
                      //           'Open An Account',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight:
                      //                 FontWeight.w700,
                      //             fontSize: 16,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
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
        );
      },
    );
  }
}
