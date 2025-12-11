import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/response.modal.dart';
import '../../env/env.dart';
import '../../utils/theme.util.dart';
import '../components/form/button.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage(this.result, {super.key});
  static const String routeName = '/update';
  final Response result;

  @override
  UpdatePageState createState() => UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            'assets/img/update-background.svg',
            alignment: Alignment.topCenter,
            // fit: BoxFit.fitWidth,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  const SizedBox(height: 30),
                  Text(
                    'Update Required!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily:
                          ThemeUtil.fontMontrealDemiBold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.result.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily:
                          ThemeUtil.fontHelveticaNeue,
                      color: Color(0xff010203),
                    ),
                  ),
                  Spacer(),
                  FormButton(
                    text: 'Update Now',
                    onPressed: openAppInStore,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openAppInStore() async {
    String appStoreUrl = "";

    if (Platform.isAndroid) {
      // Play Store URL for Android
      appStoreUrl =
          'https://play.google.com/store/apps/details?id=${Env.appId}';
    } else if (Platform.isIOS) {
      // App Store URL for iOS
      appStoreUrl =
          'https://apps.apple.com/us/app/6504090330';
    }

    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl));
    } else {
      throw 'Could not open the app store.';
    }
  }
}