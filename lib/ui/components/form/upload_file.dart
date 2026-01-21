import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:my_sage_agent/main.dart';
import 'package:my_sage_agent/ui/components/popover.dart';

class FormUploadFileControl extends StatefulWidget {
  const FormUploadFileControl({
    super.key,
    this.label,
    required this.caption,
    required this.controller,
  });

  final String? label;
  final String caption;
  final TextEditingController controller;

  @override
  State<FormUploadFileControl> createState() => _FormUploadFileControlState();
}

class _FormUploadFileControlState extends State<FormUploadFileControl> {
  Widget? _widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: MyApp.navigatorKey.currentContext!,
          isScrollControlled: true,
          builder: (context) {
            return PopOver(
              onClose: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select File to upload',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    SignatureOption(
                      icon: Icons.collections_outlined,
                      text: 'Select image from Gallery',
                      onPressed: () async {
                        Navigator.pop(context);

                        final result = await FilePicker.platform.pickFiles(
                          dialogTitle: widget.caption,
                          type: FileType.image,
                        );
                        if (result == null) {
                          return;
                        }

                        final file = File(result.files.single.path ?? '');
                        _widget = Image.file(file, height: 130);
                        setState(() {});

                        final bytes = await file.readAsBytes();
                        widget.controller.text = base64Encode(bytes);
                      },
                    ),
                    const SizedBox(height: 10),
                    SignatureOption(
                      icon: Icons.folder_outlined,
                      text: 'Select from Files',
                      onPressed: () async {
                        Navigator.pop(context);

                        FilePicker.platform
                            .pickFiles(dialogTitle: widget.caption, type: FileType.any)
                            .then((result) async {
                              if (result == null) {
                                // _messenger.errorAlert('File not selected');
                                return;
                              }

                              _widget = Icon(
                                Icons.description_outlined,
                                color: Theme.of(MyApp.navigatorKey.currentContext!).primaryColor,
                                size: 30,
                              );
                              setState(() {});

                              final file = File(result.files.single.path ?? '');
                              final bytes = await file.readAsBytes();
                              widget.controller.text = base64Encode(bytes);
                            });
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label?.isNotEmpty ?? false)
            Text(widget.label!, style: Theme.of(context).textTheme.titleSmall),
          if (widget.label?.isNotEmpty ?? false) const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: 150,
            decoration: BoxDecoration(
              // color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xff79747E), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _widget != null
                  ? [_widget!]
                  : const [
                      Icon(Icons.draw_outlined, color: Color(0xff79747E), size: 40),
                      SizedBox(height: 5),
                      Text(
                        'Tap to provide your signature',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignatureOption extends StatelessWidget {
  const SignatureOption({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  final String text;
  final void Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(20),
          side: const BorderSide(color: Color(0xffF1F1F1)),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 25),
            const SizedBox(width: 10),
            Text(
              text,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
