import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:my_sage_agent/logger.dart';
import 'package:my_sage_agent/ui/components/wizard.dart';
import 'package:my_sage_agent/utils/message.util.dart';

class MyCamera extends StatefulWidget {
  const MyCamera(this.cameras, {super.key, required this.onSuccess});
  final List<CameraDescription> cameras;
  final void Function(XFile image) onSuccess;
  static const routeName = 'utility/camera';

  @override
  State<MyCamera> createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> with WidgetsBindingObserver {
  late CameraController? controller;
  XFile? _image;
  bool _taking = false;
  late CameraLensDirection _cameraLensDirection;

  @override
  void initState() {
    super.initState();
    _initializedCamera(CameraLensDirection.front);
  }

  // #doc region AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: constraint.maxHeight - 180,
                width: double.maxFinite,
                child: (_image == null) ? CameraPreview(controller!) : Image.file(File(_image!.path), fit: BoxFit.fill),
              ),
              Container(
                height: 180,
                width: double.maxFinite,
                color: Colors.black,
                padding: const EdgeInsets.all(20),
                child: Wizard(
                  setup: (previous, next, goTo) => [
                    Row(
                      key: const ValueKey('take-picture'),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white)),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Builder(
                              builder: (context) {
                                if (_taking) {
                                  return const CircularProgressIndicator();
                                }

                                return Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(80),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(80),
                                    onTap: () async {
                                      try {
                                        _taking = true;
                                        _image = await controller!.takePicture();
                                        setState(() {
                                          _taking = false;
                                        });
                                        next();
                                      } catch (ex) {
                                        log(ex.toString());
                                      }
                                    },
                                    child: SvgPicture.asset('assets/img/capture-image.svg'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_cameraLensDirection == CameraLensDirection.back) {
                              _initializedCamera(CameraLensDirection.front);
                            } else {
                              _initializedCamera(CameraLensDirection.back);
                            }
                          },
                          icon: const Icon(Icons.flip_camera_android, size: 30, color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      key: const ValueKey('preview-picture'),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                              // widget.onClearImage();
                            });
                            previous();
                          },
                          child: Text('ReTake', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onSuccess(_image!);
                            Navigator.of(context).pop();
                          },
                          child: Text('Done', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _initializedCamera(CameraLensDirection cameraLensDirection) {
    _cameraLensDirection = cameraLensDirection;
    if (widget.cameras.isEmpty) {
      MessageUtil.displayErrorDialog(context, message: 'No camera found. Please allow permission to your camera');
      return;
    }

    final camera = widget.cameras.firstWhere((camera) => camera.lensDirection == cameraLensDirection, orElse: () => widget.cameras.first);

    controller = CameraController(camera, ResolutionPreset.high, imageFormatGroup: ImageFormatGroup.jpeg);
    controller!
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                logger.d('User denied camera access.');
                MessageUtil.displayErrorDialog(context, message: 'User denied camera access.');
                break;
              default:
                logger.d('Handle other errors.');
                MessageUtil.displayErrorDialog(context, message: 'Camera currently unavailable');
                break;
            }
          }
        });
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(cameraDescription, ResolutionPreset.medium, enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      // await Future.wait(<Future<Object?>>[
      //   // The exposure mode is currently not supported on the web.
      //   ...!kIsWeb
      //       ? <Future<Object?>>[
      //           cameraController.getMinExposureOffset().then(
      //               (double value) => _minAvailableExposureOffset = value),
      //           cameraController
      //               .getMaxExposureOffset()
      //               .then((double value) => _maxAvailableExposureOffset = value)
      //         ]
      //       : <Future<Object?>>[],
      //   cameraController
      //       .getMaxZoomLevel()
      //       .then((double value) => _maxAvailableZoom = value),
      //   cameraController
      //       .getMinZoomLevel()
      //       .then((double value) => _minAvailableZoom = value),
      // ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    // _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
