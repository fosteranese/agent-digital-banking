import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;

import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/layouts/plain.layout.dart';

class PicturePreviewPage extends StatefulWidget {
  const PicturePreviewPage({
    super.key,
    required this.title,
    required this.image,
    required this.onSuccess,
    this.height = 300,
    this.width = 300,
  });
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
    final padding = 15.0;
    return FutureBuilder(
      future: () async {
        var bytes = await widget.image.readAsBytes();
        final image = img.decodeImage(bytes);
        final width = (widget.width + 200) ~/ 1;
        final height = (widget.height + 200) ~/ 1;
        final xPositionStart = (image!.width - width) ~/ 2;
        final yPositionStart = (image.height - height) ~/ 2;

        final croppedImage = img.copyCrop(
          image,
          x: xPositionStart,
          y: yPositionStart,
          width: width,
          height: height,
        );

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
                    return Container(
                      padding: .all(padding),
                      height: widget.height,
                      width: widget.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff2BBC03), width: 1),
                        borderRadius: BorderRadius.circular(widget.height / 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.height / 2),
                        child: Image.memory(
                          snapshot.data!,
                          height: widget.height - padding,
                          width: widget.width - padding,
                        ),
                      ),
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
                  'Make sure your picture is clear to read with no blur or reflections of light',
                  textAlign: TextAlign.center,
                  style: PrimaryTextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            const Spacer(),
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
                    Icon(Icons.camera, color: ThemeUtil.flat, size: 24),
                    const SizedBox(width: 5),
                    Text(
                      'Retake',
                      style: PrimaryTextStyle(
                        fontSize: 16,
                        fontWeight: .w400,
                        color: ThemeUtil.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            FormButton(
              onPressed: () {
                final image = base64Encode(snapshot.data!);
                widget.onSuccess(image, '');
                context.pop();
              },
              text: 'Submit',
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
