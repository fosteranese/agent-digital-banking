import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CardDetectionOverlay extends StatefulWidget {
  const CardDetectionOverlay({
    super.key,
    required this.cameras,
    this.cameraDirection = CameraLensDirection.back,
    this.overlay,
    required this.faceDetectorOptions,
    required this.resultCallback,
    required this.camera,
    required this.frontCamera,
    required this.backCamera,
    required this.whichSide,
    required this.onInit,
  });

  final CameraLensDirection cameraDirection;
  final Widget? overlay;
  final List<CameraDescription> cameras;
  final FaceDetectorOptions faceDetectorOptions;
  final Function(List result) resultCallback;
  final CameraDescription camera;
  final CameraDescription frontCamera;
  final CameraDescription backCamera;
  final TextEditingController whichSide;
  final void Function(CameraController controller) onInit;

  @override
  State<CardDetectionOverlay> createState() => _CardDetectionOverlayState();
}

class _CardDetectionOverlayState extends State<CardDetectionOverlay> {
  CameraController? _camController;
  // late ObjectDetector _objectDetector;
  bool _canProcess = true;
  bool _isBusy = false;
  String whichSide = 'back';
  late var _camera = widget.camera;

  int _formatIndex = 0;
  InputImageFormat get _format {
    if (Platform.isIOS) return InputImageFormat.bgra8888;

    if (_formatIndex >= InputImageFormat.values.length) {
      _formatIndex = 0;
    }

    return InputImageFormat.values[_formatIndex];
  }

  void _initDetection() {}

  @override
  void initState() {
    widget.whichSide.addListener(() {
      if (widget.whichSide.text != whichSide) {
        whichSide = widget.whichSide.text;
        _initDetection();
        _startRecording();
      }
    });

    super.initState();
    _initDetection();
    _startRecording();
  }

  Future _startRecording() async {
    _camera = whichSide == 'front' ? widget.frontCamera : widget.backCamera;

    if (_camController != null) {
      // _stopRecording();
    }

    _camController = CameraController(_camera, ResolutionPreset.high, enableAudio: false);
    _camController?.initialize().then((_) {
      if (!mounted) return;

      _camController?.startImageStream(_imageProcess);
      setState(() {});
    });
    widget.onInit(_camController!);
  }

  Future _imageProcess(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation = InputImageRotationValue.fromRawValue(_camera.sensorOrientation);

    if (imageRotation == null) return;

    final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        bytesPerRow: image.planes.firstOrNull!.bytesPerRow,
        size: imageSize,
        format: _format,
        rotation: imageRotation,
      ),
    );

    _detectionProcess(inputImage);
  }

  Future _detectionProcess(InputImage inputImage) async {
    return;
    // try {
    //   if (!_canProcess) return;
    //   if (_isBusy) return;
    //   _isBusy = true;

    //   final faces = await _processCameraImage(inputImage);

    //   if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
    //     widget.resultCallback(faces);
    //   }
    //   _isBusy = false;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // } catch (ex) {
    //   ++_formatIndex;
    //   _isBusy = false;
    // }
  }

  // Future<List<DetectedObject>> _processCameraImage(InputImage inputImage) async {
  //   final objects = await _objectDetector.processImage(inputImage);
  //   return objects.where(_isCardLike).toList();
  // }

  /// Card detection logic
  // bool _isCardLike(DetectedObject object) {
  //   final rect = object.boundingBox;
  //   final aspectRatio = rect.width / rect.height;

  //   // Typical card ratios ≈ 1.4 – 1.7
  //   return aspectRatio > 1.3 && aspectRatio < 1.8 && rect.width > 150 && rect.height > 90;
  // }

  Widget _viewRender() {
    if (_camController?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _camController!.value.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(child: CameraPreview(_camController!)),
          ),
          widget.overlay != null ? widget.overlay! : const Text(''),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _viewRender());
  }

  Future _stopRecording() async {
    await _camController?.stopImageStream();
    await _camController?.dispose();
    // _camController = null;
  }

  @override
  void dispose() {
    _stopRecording();
    _canProcess = false;
    // _objectDetector.close();
    super.dispose();
  }
}
