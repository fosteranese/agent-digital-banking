import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const routeName = '/test';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FBF8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('assets/img/splash-logo.gif', repeat: ImageRepeat.noRepeat),
          const Spacer(),
          LinearProgressIndicator(
            backgroundColor: const Color(0xff919195),
            borderRadius: BorderRadius.zero,
            color: Theme.of(context).primaryColor,
            minHeight: 10,
          ),
        ],
      ),
    );
  }
}
