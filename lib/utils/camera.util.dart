import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:agent_digital_banking/main.dart';
import 'package:agent_digital_banking/utils/message.util.dart';

class CameraUtil {
  static void showCamera({void Function()? begin, void Function()? after, required void Function(XFile imageFile) onSuccess}) async {
    try {
      if (begin != null) {
        begin();
      }

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        MessageUtil.displayErrorDialog(MyApp.navigatorKey.currentContext!, message: 'No camera found. Please allow permission to your camera');
        return;
      }

      // Navigator.push(
      //   MyApp.navigatorKey.currentContext!,
      //   settings: const RouteSettings(name: MyCamera.routeName),
      //   screen: MyCamera(
      //     cameras,
      //     onSuccess: onSuccess,
      //   ),
      //   withNavBar: true,
      //   pageTransitionAnimation: PageTransitionAnimation.scale,
      // );

      if (after != null) {
        after();
      }
    } catch (ex) {
      if (after != null) {
        after();
      }
    }
  }

  static String convertImageToBase64(XFile image) {
    final imageFile = File(image.path);
    List<int> imageBytes = imageFile.readAsBytesSync();
    var base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
