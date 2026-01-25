import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/verification_modes/scan_ghana_card_verification.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum GhanaCardVerificationUploadStages { front, back }

enum UploadTypes { scan, file }

class GhanaCardVerificationUpload extends StatefulWidget {
  const GhanaCardVerificationUpload({super.key, required this.onVerify, required this.uploadTypes});
  static const routeName = '/ghana-card-verification-upload';

  final void Function(String cardFront, String cardBack) onVerify;
  final UploadTypes uploadTypes;

  @override
  State<GhanaCardVerificationUpload> createState() => _GhanaCardVerificationUploadState();
}

class _GhanaCardVerificationUploadState extends State<GhanaCardVerificationUpload> {
  final _height = 207.0;
  final _stage = ValueNotifier<GhanaCardVerificationUploadStages>(.front);
  final _picker = ImagePicker();
  final _cardFront = ValueNotifier<XFile?>(null);
  final _cardBack = ValueNotifier<XFile?>(null);

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

  String get _title {
    if (widget.uploadTypes == .file) {
      return 'Upload Ghana Card';
    }

    return 'Scan Ghana Card';
  }

  String get _cardFrontTitle {
    if (widget.uploadTypes == .file) {
      return 'Upload the front of Ghana Card';
    }

    return 'Scan the front of Ghana Card';
  }

  String get _cardBackTitle {
    if (widget.uploadTypes == .file) {
      return 'Upload the back of Ghana Card';
    }

    return 'Scan the back of Ghana Card';
  }

  String get _icon {
    if (widget.uploadTypes == .file) {
      return 'assets/img/upload.svg';
    }

    return 'assets/img/scan.svg';
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
              child: ValueListenableBuilder(
                valueListenable: _stage,
                builder: (context, stage, child) {
                  return Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      const Spacer(),
                      Text(
                        _title,
                        textAlign: .center,
                        style: PrimaryTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: .w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      ValueListenableBuilder(
                        valueListenable: _cardFront,
                        builder: (context, image, child) {
                          return VerificationItemButton(
                            image: image,
                            icon: _icon,
                            height: _height,
                            onPressed: () async {
                              await _invokeUploadMethod(context, _cardFront, () {
                                if (_cardFront.value != null) {
                                  _stage.value = .back;
                                }
                              });
                            },
                            title: _cardFrontTitle,
                            errorTitle: '',
                            errorMessage: '',
                            stage: GhanaCardVerificationUploadStages.front,
                            currentStage: stage,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: _cardBack,
                        builder: (context, image, child) {
                          return VerificationItemButton(
                            image: image,
                            icon: _icon,
                            height: _height,
                            onPressed: () {
                              _invokeUploadMethod(context, _cardBack, () {});
                            },
                            title: _cardBackTitle,
                            errorTitle: 'Front Of Card Not Selected',
                            errorMessage:
                                'You must first select the front of your ghana card to proceed with this.',
                            stage: GhanaCardVerificationUploadStages.back,
                            currentStage: stage,
                          );
                        },
                      ),
                      const Spacer(flex: 3),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: .only(left: 20, right: 20, top: 20),
                child: ValueListenableBuilder(
                  valueListenable: _cardBack,
                  builder: (context, cardBack, child) {
                    return FormButton(
                      disabled: cardBack == null,
                      onPressed: () async {
                        if (cardBack == null) {
                          MessageUtil.displayErrorDialog(
                            context,
                            title: 'All Images Required',
                            message:
                                'Please ensure both the front and card of the Ghana Card are provided',
                          );
                          return;
                        }

                        final images = await Future.wait([
                          _cardFront.value!.readAsBytes(),
                          _cardBack.value!.readAsBytes(),
                        ]);

                        final imageFirst = base64Encode(images.first);
                        final imageLast = base64Encode(images.last);

                        widget.onVerify(imageFirst, imageLast);
                      },
                      text: 'Submit',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _invokeUploadMethod(
    BuildContext context,
    ValueNotifier<XFile?> cardSide,
    void Function() onSuccess,
  ) async {
    switch (widget.uploadTypes) {
      case .file:
        await pickImageFromGallery(cardSide, onSuccess);
        break;
      case .scan:
        context.push(
          ScanGhanaCardVerification.routeName,
          extra: ScanGhanaCardVerification(
            onVerify: (image) {
              cardSide.value = image;
              onSuccess();
            },
          ),
        );
        break;
    }
  }

  Future<void> pickImageFromGallery(
    ValueNotifier<XFile?> cardImage,
    void Function() onSuccess,
  ) async {
    final image = await _picker.pickImage(source: .gallery);
    if (image == null) {
      return;
    }

    cardImage.value = image;
    onSuccess();
  }

  @override
  void dispose() {
    _stage.dispose();
    _cardFront.dispose();
    _cardBack.dispose();
    super.dispose();
  }
}

class VerificationItemButton extends StatelessWidget {
  const VerificationItemButton({
    super.key,
    required this.image,
    required this.icon,
    required this.height,
    required this.onPressed,
    required this.title,
    required this.errorTitle,
    required this.errorMessage,
    required this.stage,
    required this.currentStage,
  });

  final XFile? image;
  final String icon;
  final double height;
  final String title;
  final String errorTitle;
  final String errorMessage;
  final void Function() onPressed;
  final GhanaCardVerificationUploadStages stage;
  final GhanaCardVerificationUploadStages currentStage;

  bool get _canOperate {
    return currentStage.index >= stage.index;
  }

  Color get _bgColor {
    return _canOperate ? const Color(0x26FFFFFF) : const Color(0x26FFFFFF);
  }

  Color get _activityColor {
    return _canOperate ? Colors.white : ThemeUtil.flora;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: _canOperate,
      onTap: () {
        if (!_canOperate) {
          MessageUtil.displayErrorDialog(context, title: errorTitle, message: errorMessage);
          return;
        }

        return onPressed();
      },
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          strokeCap: StrokeCap.round,
          dashPattern: [5, 5],
          strokeWidth: 1,
          color: _activityColor,
          padding: .zero,
          borderPadding: .zero,
          radius: const Radius.circular(8),
        ),

        child: Builder(
          builder: (context) {
            final invokeButton = Container(
              alignment: .center,
              height: height,
              decoration: BoxDecoration(color: _bgColor, borderRadius: .circular(8)),
              child: Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  SvgPicture.asset(
                    icon,
                    colorFilter: ColorFilter.mode(_activityColor, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    textAlign: .center,
                    style: PrimaryTextStyle(color: _activityColor, fontSize: 16, fontWeight: .w400),
                  ),
                ],
              ),
            );

            if (image != null) {
              return FutureBuilder(
                future: image!.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return invokeButton;
                  }
                  return ClipRRect(
                    borderRadius: .circular(8),
                    child: Image.memory(
                      snapshot.requireData,
                      alignment: .center,
                      height: height,
                      width: double.maxFinite,
                      fit: .cover,
                    ),
                  );
                },
              );
            }

            return invokeButton;
          },
        ),
      ),
    );
  }
}
