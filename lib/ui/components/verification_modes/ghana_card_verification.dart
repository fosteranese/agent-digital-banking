import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:my_sage_agent/data/models/verification.response.dart';
import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/ui/components/face_detection_overlay.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/outline_button.dart';
import 'package:my_sage_agent/ui/pages/picture_preview.page.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class GhanaCardVerification extends StatefulWidget {
  const GhanaCardVerification({super.key, required this.data, required this.onVerify, this.onSkip, this.onBack});

  final VerificationResponse data;
  final void Function(String picture, String code) onVerify;
  final void Function()? onSkip;
  final void Function()? onBack;

  @override
  State<GhanaCardVerification> createState() => _GhanaCardVerificationState();
}

class _GhanaCardVerificationState extends State<GhanaCardVerification> {
  String? _isPermissionStatus = 'RequestingPermission';

  late CameraController controller;
  late List<CameraDescription> _cameras = [];
  final _height = 300.0;
  final _width = 300.0;
  bool _isTorchOn = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

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
                decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(_width / 2)),
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
                  border: Border.all(color: value ? Colors.green.shade700 : Colors.white, width: value ? 4 : 1),
                  borderRadius: BorderRadius.circular(_width / 2.0),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _init() async {
    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }

      // await _initCamera();

      _isPermissionStatus = 'Granted';
      if (mounted) setState(() {});
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _isPermissionStatus = e.code;
            break;

          case 'CameraAccessDeniedWithoutPrompt':
            _isPermissionStatus = e.code;
            break;

          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  void _goToSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.settings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (_isPermissionStatus == 'RequestingPermission') {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/img/camera.svg'),
                  const SizedBox(height: 10),
                  const SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
                ],
              ),
            );
          }

          if (_isPermissionStatus == 'CameraAccessDeniedWithoutPrompt') {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SvgPicture.asset(
                  //   'assets/img/error.svg',
                  //   width: 150,
                  // ),
                  const SizedBox(height: 50),
                  Text(
                    'Permission Request',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You have previously denied the camera access request. Go to Settings to enable camera access.',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 50),
                  FormButton(height: 50, text: 'Settings', onPressed: _goToSettings),
                  const SizedBox(height: 10),
                  FormOutlineButton(
                    height: 50,
                    text: 'Back',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }

          if (_isPermissionStatus == 'CameraAccessDenied') {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SvgPicture.asset(
                  //   'assets/img/error.svg',
                  //   width: 150,
                  // ),
                  const SizedBox(height: 50),
                  Text(
                    'Permission Denied',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You have denied the camera access request. Go to Settings to enable camera access.',
                    textAlign: TextAlign.center,
                    style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 50),
                  FormButton(height: 50, text: 'Settings', onPressed: _goToSettings),
                  const SizedBox(height: 10),
                  FormOutlineButton(
                    height: 50,
                    text: 'Back',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              FaceDetectionOverlay(onInit: _onInit, whichSide: whichSideController, cameras: _cameras, camera: _currentCamera, frontCamera: _frontCamera, backCamera: _backCamera, faceDetectorOptions: FaceDetectorOptions(enableClassification: false, enableContours: false), overlay: _overlay(), resultCallback: _resultCallback),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: _height + 60),
                  child: const Text('Position your head in the frame', style: TextStyle(color: Colors.white)),
                ),
              ),
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
                  title: Text(
                    'Camera',
                    style: PrimaryTextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  centerTitle: true,
                ),
                bottomNavigationBar: SizedBox(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: IconButton(
                          onPressed: _toggleTorch,
                          icon: SizedBox(width: 48, height: 48, child: SvgPicture.asset('assets/img/flash.svg')),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!_faceFound.value) {
                                MessageUtil.displayErrorDialog(context, message: "Please position your head in the frame");
                                return;
                              }

                              controller.takePicture().then((image) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PicturePreviewPage(title: '', image: image, height: _height, width: _width, onSuccess: widget.onVerify),
                                  ),
                                );
                              });
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.white, width: 5),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Capture', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: IconButton(
                          onPressed: () {
                            isFront = !isFront;
                            // _initCamera();
                            whichSideController.text = isFront ? 'front' : 'back';
                            // setState(() {});
                          },
                          icon: SizedBox(width: 48, height: 48, child: SvgPicture.asset('assets/img/turn.svg')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _toggleTorch() async {
    if (!controller.value.isInitialized) return;

    try {
      if (!_isTorchOn) {
        // turn torch ON
        await controller.setFlashMode(FlashMode.torch);
        _isTorchOn = true;
      } else {
        // turn torch OFF
        await controller.setFlashMode(FlashMode.off);
        _isTorchOn = false;
      }
      setState(() {});
    } on CameraException catch (e) {
      logger.e('Failed to change flash mode: ${e.code} ${e.description}');
      // optionally show SnackBar to user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Flash not supported on this device')));
    }
  }

  void _onInit(CameraController camController) {
    controller = camController;
  }

  void _resultCallback(List result) {
    if (result.isNotEmpty) {
      for (final Face face in result) {
        final width = _width - 100;
        final height = _height - 100;

        final xPositionStart = (MediaQuery.of(context).size.width - width) / 2;
        final xPositionEnd = xPositionStart + width;
        final yPositionStart = (MediaQuery.of(context).size.height - height) / 2;
        final yPositionEnd = yPositionStart + height;

        if ((face.boundingBox.left > xPositionStart && face.boundingBox.left < xPositionEnd) && (face.boundingBox.top > yPositionStart && face.boundingBox.top < yPositionEnd)) {
          _faceFound.value = true;
        } else {
          _faceFound.value = false;
        }
      }
    } else {
      _faceFound.value = false;
    }
  }

  CameraDescription get _currentCamera {
    return isFront ? _frontCamera : _backCamera;
  }

  CameraDescription get _frontCamera {
    return _cameras[1];
  }

  CameraDescription get _backCamera {
    return _cameras[0];
  }

  @override
  void dispose() {
    controller.dispose();
    whichSideController.dispose();
    super.dispose();
  }
}
