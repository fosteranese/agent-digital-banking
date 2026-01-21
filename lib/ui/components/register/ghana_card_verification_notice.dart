import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class GhanaCardVerificationNotice extends StatelessWidget {
  const GhanaCardVerificationNotice({super.key, required this.onStartGhanaCardVerification});
  final void Function() onStartGhanaCardVerification;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(View.of(context)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: ThemeUtil.offWhite),
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ThemeUtil.offWhite,
                foregroundColor: ThemeUtil.black,
              ),
              onPressed: () {},
              child: Text('Help'),
            ),
          ],
          actionsPadding: const .only(right: 10),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const .symmetric(horizontal: 20),
              child: Text(
                'Let\'s get your Identity Verified using you Ghana Card',
                style: PrimaryTextStyle(fontSize: 20, fontWeight: .w600, color: ThemeUtil.black),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const .symmetric(horizontal: 20),
              child: Text(
                'Kindly enable camera access to continue when prompted',
                style: PrimaryTextStyle(fontSize: 16, fontWeight: .w400, color: ThemeUtil.flat),
              ),
            ),
            const Spacer(),
            Image.asset('assets/img/ghana-card-1.png'),
            const Spacer(flex: 2),
          ],
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(
            padding: .only(left: 20, right: 20, top: 20),
            child: FormButton(onPressed: onStartGhanaCardVerification, text: 'Continue'),
          ),
        ),
      ),
    );
  }
}
