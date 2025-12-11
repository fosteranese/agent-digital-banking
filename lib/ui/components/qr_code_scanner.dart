// import 'dart:async';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// import '../../logger.dart';
// import '../../main.dart';
// import '../../utils/messenger.util.dart';
// import 'form/outline_button.dart';

// class QrCodeScanner extends StatefulWidget {
//   const QrCodeScanner({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.onSuccess,
//   });
//   final String title;
//   final String icon;
//   final void Function(String qrCode) onSuccess;

//   @override
//   State<QrCodeScanner> createState() =>
//       _QrCodeScannerState();
// }

// class _QrCodeScannerState extends State<QrCodeScanner>
//     with WidgetsBindingObserver {
//   StreamSubscription<Object?>? _subscription;
//   final _isFlashOn = ValueNotifier<bool>(false);
//   final _messenger = Messenger();
//   late final _mobileScannerController =
//       MobileScannerController(
//         detectionSpeed: DetectionSpeed.noDuplicates,
//         formats: [BarcodeFormat.qrCode],
//         torchEnabled: _isFlashOn.value,
//       );

//   @override
//   void initState() {
//     super.initState();

//     // Start listening to lifecycle changes.
//     WidgetsBinding.instance.addObserver(this);

//     // Start listening to the barcode events.
//     _subscription = _mobileScannerController.barcodes
//         .listen(_onDetect);

//     // Finally, start the scanner itself.
//     unawaited(_mobileScannerController.start());
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);

//     switch (state) {
//       case AppLifecycleState.detached:
//       case AppLifecycleState.hidden:
//       case AppLifecycleState.paused:
//         return;
//       case AppLifecycleState.resumed:
//         // Restart the scanner when the app is resumed.
//         // Don't forget to resume listening to the barcode events.
//         _subscription = _mobileScannerController.barcodes
//             .listen(_onDetect);

//         unawaited(_mobileScannerController.start());
//       case AppLifecycleState.inactive:
//         // Stop the scanner when the app is paused.
//         // Also stop the barcode events subscription.
//         unawaited(_subscription?.cancel());
//         _subscription = null;
//         unawaited(_mobileScannerController.stop());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MobileScanner(
//       // scanWindow: Rect.fromCenter(center: const Offset(1.0, 2.0), width: 200, height: 200),
//       controller: _mobileScannerController,
//       overlayBuilder: (context, constraint) => Stack(
//         children: [
//           ColorFiltered(
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.6),
//               BlendMode.srcOut,
//             ), // This one will create the magic
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.black,
//                     backgroundBlendMode: BlendMode.dstOut,
//                   ), // This one will handle background + difference out
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Container(
//                     height: 300,
//                     width: 300,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                         30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 400),
//               child: Text(
//                 'Focus on the QR Code to scan',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           const Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               width: 300,
//               height: 300,
//               child: CustomPaint(painter: BorderPainter()),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 400),
//               child: SizedBox(
//                 width: 300,
//                 child: Row(
//                   children: [
//                     OutlinedButton(
//                       onPressed: () async {
//                         _messenger.contentAlert(
//                           Column(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.start,
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'Where would you like to Select the QR Code image from ?',
//                                 style: TextStyle(
//                                   fontWeight:
//                                       FontWeight.w400,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               FormOutlineButton(
//                                 onPressed: () async {
//                                   Navigator.pop(context);

//                                   final result =
//                                       await FilePicker
//                                           .platform
//                                           .pickFiles(
//                                             dialogTitle:
//                                                 'QR Code Image',
//                                             type: FileType
//                                                 .image,
//                                           );
//                                   if (result == null) {
//                                     return;
//                                   }

//                                   final file = File(
//                                     result
//                                             .files
//                                             .single
//                                             .path ??
//                                         '',
//                                   );
//                                   _processQrCodeFile(file);
//                                 },
//                                 elevation: 0,
//                                 text: 'Select from Gallery',
//                               ),
//                               const SizedBox(height: 10),
//                               FormOutlineButton(
//                                 onPressed: () async {
//                                   Navigator.pop(context);

//                                   final result = await FilePicker
//                                       .platform
//                                       .pickFiles(
//                                         dialogTitle:
//                                             'QR Code Image',
//                                         allowedExtensions: [
//                                           'jpg',
//                                           'jpeg',
//                                           'png',
//                                           'svg',
//                                         ],
//                                         type:
//                                             FileType.custom,
//                                       );
//                                   if (result == null) {
//                                     // _messenger.errorAlert('File not selected');
//                                     return;
//                                   }

//                                   final file = File(
//                                     result
//                                             .files
//                                             .single
//                                             .path ??
//                                         '',
//                                   );
//                                   _processQrCodeFile(file);
//                                 },
//                                 text: 'Select from Files',
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       child: const Row(
//                         children: [
//                           Icon(
//                             Icons.perm_media_outlined,
//                             size: 15,
//                             color: Colors.white,
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             'Select from gallery',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     IconButton(
//                       onPressed: () async {
//                         await _mobileScannerController
//                             .toggleTorch();
//                         _isFlashOn.value =
//                             !_isFlashOn.value;
//                       },
//                       style: IconButton.styleFrom(
//                         side: const BorderSide(
//                           color: Colors.white,
//                           width: 1,
//                         ),
//                         padding: const EdgeInsets.all(10),
//                       ),
//                       icon: ValueListenableBuilder<bool>(
//                         valueListenable: _isFlashOn,
//                         builder: (context, value, child) {
//                           if (value) {
//                             return const Icon(
//                               Icons.flash_off_outlined,
//                             );
//                           }

//                           return const Icon(
//                             Icons.flash_on_outlined,
//                           );
//                         },
//                       ),
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 200,
//             child: AppBar(
//               toolbarHeight: 100,
//               backgroundColor: Colors.transparent,
//               leading: IconButton(
//                 color: Colors.white,
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.arrow_back),
//               ),
//               title: Text(
//                 widget.title,
//                 style: const TextStyle(color: Colors.white),
//               ),
//               // actions: [
//               //   CachedNetworkImage(
//               //     imageUrl: widget.icon,
//               //     imageBuilder: (context, imageProvider) => CircleAvatar(
//               //       backgroundImage: imageProvider,
//               //     ),
//               //     placeholder: (context, imageProvider) => const SizedBox(),
//               //     errorWidget: (context, imageProvider, error) => const SizedBox(),
//               //   )
//               // ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _onDetect(capture) {
//     _onPressed(capture.barcodes.first.rawValue ?? '');
//   }

//   _onPressed(String qrCode) {
//     logger.i('qrCode: $qrCode');
//     widget.onSuccess(qrCode);
//   }

//   _processQrCodeFile(File file) async {
//     final status = await _mobileScannerController
//         .analyzeImage(file.path);
//     if (status?.barcodes.isEmpty ?? true) {
//       _messenger.errorAlert(
//         'This is not a valid QR Code file image. Check again and make sure your QR Code is very clear.',
//       );
//     }
//   }

//   @override
//   void dispose() async {
//     // Stop listening to lifecycle changes.
//     WidgetsBinding.instance.removeObserver(this);
//     // Stop listening to the barcode events.
//     unawaited(_subscription?.cancel());
//     _subscription = null;
//     // Dispose the widget itself.
//     super.dispose();
//     // Finally, dispose of the controller.
//     await _mobileScannerController.dispose();
//   }
// }

// class BorderPainter extends CustomPainter {
//   const BorderPainter();

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawPaint(Paint()..color = Colors.transparent);

//     Paint paint = Paint()
//       ..color = Theme.of(
//         MyApp.navigatorKey.currentContext!,
//       ).primaryColor
//       ..strokeWidth = 4
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     const lineSize = 50.0;
//     const radius = 30.0;
//     const radiusAndLineSize = radius + lineSize;
//     final widthMinusRadiusLineSize =
//         size.width - radiusAndLineSize;
//     final widthMinusRadius = size.width - radius;
//     final heightMinusRadius = size.height - radius;

//     // corner 1
//     Path bezierPath = Path()
//       ..moveTo(radius, 0)
//       ..lineTo(radiusAndLineSize, 0)
//       ..moveTo(0, radius)
//       ..quadraticBezierTo(0, 0, radius, 0)
//       ..moveTo(0, radius)
//       ..lineTo(0, radiusAndLineSize);

//     // corner 2
//     bezierPath
//       ..moveTo(widthMinusRadiusLineSize, 0)
//       ..lineTo(widthMinusRadius, 0)
//       ..moveTo(widthMinusRadius, 0)
//       ..quadraticBezierTo(size.width, 0, size.width, radius)
//       ..moveTo(size.width, radius)
//       ..lineTo(size.width, radiusAndLineSize);

//     // corner 3
//     bezierPath
//       ..moveTo(0, size.height - radiusAndLineSize)
//       ..lineTo(0, heightMinusRadius)
//       ..moveTo(0, heightMinusRadius)
//       ..quadraticBezierTo(
//         0,
//         size.height,
//         radius,
//         size.height,
//       )
//       ..moveTo(radius, size.height)
//       ..lineTo(radiusAndLineSize, size.height);

//     // corner 4
//     bezierPath
//       ..moveTo(widthMinusRadiusLineSize, size.height)
//       ..lineTo(widthMinusRadius, size.height)
//       ..moveTo(widthMinusRadius, size.height)
//       ..quadraticBezierTo(
//         size.width,
//         size.height,
//         size.width,
//         heightMinusRadius,
//       )
//       ..moveTo(size.width, heightMinusRadius)
//       ..lineTo(size.width, heightMinusRadius - lineSize);

//     canvas.drawPath(bezierPath, paint);
//   }

//   @override
//   bool shouldRepaint(BorderPainter oldDelegate) => false;
// }
