import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/utils/message.util.dart';
import 'package:my_sage_agent/utils/theme.util.dart';
import 'package:uuid/uuid.dart';

enum GhanaCardVerificationUploadStages { front, back }

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
                        'Scan Ghana Card',
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
                        builder: (context, value, child) {
                          return VerificationItemButton(
                            height: _height,
                            onPressed: () async {
                              await pickImageFromGallery(_cardFront);
                              if (_cardFront.value != null) {
                                _stage.value = .back;
                              }
                            },
                            title: 'Upload the front of Ghana Card',
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
                        builder: (context, value, child) {
                          return VerificationItemButton(
                            height: _height,
                            onPressed: () {
                              pickImageFromGallery(_cardBack);
                            },
                            title: 'Upload the back of Ghana Card',
                            errorTitle: 'Front Of Card Not Uploaded',
                            errorMessage:
                                'You must first upload the front of your ghana card to proceed with this.',
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
                          _cardFront.value!.readAsString(),
                          _cardBack.value!.readAsString(),
                        ]);

                        widget.onVerify(images.first, images.last, Uuid().v4());
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

  Future<void> pickImageFromGallery(ValueNotifier<XFile?> cardImage) async {
    final image = await _picker.pickImage(source: .gallery);
    if (image == null) {
      return;
    }

    cardImage.value = image;
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
    required this.height,
    required this.onPressed,
    required this.title,
    required this.errorTitle,
    required this.errorMessage,
    required this.stage,
    required this.currentStage,
  });

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

        child: Container(
          alignment: .center,
          height: height,
          decoration: BoxDecoration(color: _bgColor, borderRadius: .circular(8)),
          child: Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              SvgPicture.asset(
                'assets/img/upload.svg',
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
        ),
      ),
    );
  }
}
