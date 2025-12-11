import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;

import 'package:agent_digital_banking/utils/theme.util.dart';
import 'package:agent_digital_banking/ui/components/form/button.dart';
import 'package:agent_digital_banking/ui/layouts/plain.layout.dart';

class PicturePreviewPage extends StatefulWidget {
  const PicturePreviewPage({super.key, required this.title, required this.image, required this.onSuccess, this.height = 300, this.width = 300});
  static const routeName = '/picture-preview';

  final String title;
  final XFile image;
  final double height;
  final double width;
  final void Function(String base64Image, String code) onSuccess;

  @override
  State<PicturePreviewPage> createState() => _PicturePreviewPageState();
}

class _PicturePreviewPageState extends State<PicturePreviewPage> {
  late final xPositionStart = (MediaQuery.of(context).size.width - widget.width) ~/ 2;
  late final yPositionStart = (MediaQuery.of(context).size.height - widget.height) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        var bytes = await widget.image.readAsBytes();
        final image = img.decodeImage(bytes);
        final width = (widget.width + 200) ~/ 1;
        final height = (widget.height + 200) ~/ 1;
        final xPositionStart = (image!.width - width) ~/ 2;
        final yPositionStart = (image.height - height) ~/ 2;

        final croppedImage = img.copyCrop(image, x: xPositionStart, y: yPositionStart, width: width, height: height);

        bytes = img.encodeJpg(croppedImage, quality: 100);

        return bytes;
      }(),
      builder: (context, snapshot) {
        return PlainLayout(
          miniTitle: widget.title,
          children: [
            // const Spacer(),
            Align(
              alignment: Alignment.topCenter,
              child: Builder(
                builder: (context) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      child: Image.memory(snapshot.data!, height: widget.height, width: widget.width),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: widget.width,
                child: Text(
                  'Is this photo a good representation of your face?',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.camera, color: ThemeUtil.secondaryColor, size: 20),
                    const SizedBox(width: 5),
                    Text('Retake  Picture', style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FormButton(
              onPressed: () {
                final image = base64Encode(snapshot.data!);
                widget.onSuccess(image, '');
                context.pop();
              },
              text: 'Verify photo',
            ),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
