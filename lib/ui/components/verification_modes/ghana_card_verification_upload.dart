import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class GhanaCardVerificationUpload extends StatefulWidget {
  const GhanaCardVerificationUpload({super.key, required this.onVerify, this.onSkip, this.onBack});
  static const routeName = '/ghana-card-verification-upload';

  final void Function(String cardFront, String cardBack, String code) onVerify;
  final void Function()? onSkip;
  final void Function()? onBack;

  @override
  State<GhanaCardVerificationUpload> createState() => _GhanaCardVerificationUploadState();
}

class _GhanaCardVerificationUploadState extends State<GhanaCardVerificationUpload> {
  final _height = 207.0;

  bool isFront = true;
  final whichSideController = TextEditingController(text: 'front');

  Widget _overlay() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/verification-bg.jpg'),
          alignment: .center,
          fit: .cover,
        ),
      ),
      child: BackdropFilter(
        filter: .blur(sigmaX: 18.4, sigmaY: 18.4),
        child: Container(color: const Color(0x30FFFFFF)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _overlay(),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
                icon: const Icon(Icons.close),
              ),
            ),
            body: Container(
              margin: .symmetric(horizontal: 20),
              width: double.maxFinite,
              height: double.maxFinite,
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  const Spacer(),
                  Text(
                    'Scan Ghana Card',
                    textAlign: .center,
                    style: PrimaryTextStyle(color: Colors.white, fontSize: 16, fontWeight: .w600),
                  ),
                  const SizedBox(height: 20),

                  VerificationItemButton(height: _height),
                  const SizedBox(height: 20),
                  VerificationItemButton(height: _height),
                  const Spacer(flex: 3),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: .only(left: 20, right: 20, top: 20),
                child: FormButton(onPressed: () {}, text: 'Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    whichSideController.dispose();
    super.dispose();
  }
}

class VerificationItemButton extends StatelessWidget {
  const VerificationItemButton({super.key, required double height}) : _height = height;

  final double _height;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeCap: StrokeCap.round,
        dashPattern: [5, 5],
        strokeWidth: 1,
        color: Colors.white,
        padding: .zero,
        borderPadding: .zero,
        radius: const Radius.circular(8),
      ),

      child: Container(
        alignment: .center,
        height: _height,
        decoration: BoxDecoration(color: const Color(0x26FFFFFF), borderRadius: .circular(8)),
        child: Row(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            SvgPicture.asset('assets/img/upload.svg'),
            const SizedBox(width: 10),
            Text(
              'Upload the front of Ghana Card',
              textAlign: .center,
              style: PrimaryTextStyle(color: Colors.white, fontSize: 16, fontWeight: .w400),
            ),
          ],
        ),
      ),
    );
  }
}
