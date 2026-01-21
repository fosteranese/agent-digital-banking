import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/face_detection_overlay.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/pages/picture_preview.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
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
  final _height = 300.0;
  final _width = 300.0;

  final _faceFound = ValueNotifier(false);
  bool isFront = true;
  final whichSideController = TextEditingController(text: 'front');

  Widget _overlay() {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(const Color(0xff1A1A1A).withAlpha(153), BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _faceFound,
          builder: (context, value, child) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: value ? Colors.green.shade700 : Colors.white,
                    width: value ? 4 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _overlay(),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: _height + 60),
              child: const Text(
                'Position your head in the frame',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: ThemeUtil.offWhite),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: ThemeUtil.flat,
                icon: const Icon(Icons.arrow_back),
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
