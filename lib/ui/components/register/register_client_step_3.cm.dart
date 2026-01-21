import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_sage_agent/blocs/registration/registration_bloc.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/verification_modes/ghana_card_verification_upload.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RegisterClientStep3 extends StatelessWidget {
  const RegisterClientStep3({super.key, required this.isCameraAvailable});

  final ValueNotifier<bool> isCameraAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .center,
      color: ThemeUtil.offWhite,
      child: Column(
        mainAxisSize: .max,
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .end,
        children: [
          SizedBox(height: 30),
          Expanded(child: Image.asset('assets/img/ghana-card-1.png', fit: BoxFit.cover)),
          ValueListenableBuilder(
            valueListenable: isCameraAvailable,
            builder: (context, value, child) {
              return Container(
                alignment: .center,
                height: value ? 216 : 155,
                margin: const .only(left: 20, right: 20, bottom: 20),
                padding: .symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: .circular(12)),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: [
                    if (value)
                      Text(
                        'Scan the front and back of the client’s Ghana Card or upload a photo of the front and back',
                        textAlign: .center,
                        style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400),
                      )
                    else
                      Text(
                        'Upload a photo of the front and back of your client’s Ghana Card',
                        textAlign: .center,
                        style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400),
                      ),
                    const SizedBox(height: 20),
                    if (value)
                      FormButton(
                        onPressed: () {},
                        text: 'Scan Now',
                        svgIcon: 'assets/img/scan.svg',
                        buttonIconAlignment: .left,
                        iconSize: 24,
                      ),
                    if (value) const SizedBox(height: 10),
                    FormButton(
                      backgroundColor: ThemeUtil.black,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        context.push(
                          GhanaCardVerificationUpload.routeName,
                          extra: GhanaCardVerificationUpload(
                            onVerify: (cardFront, cardBack, code) {
                              context.read<RegistrationBloc>().add(
                                ManualVerification(
                                  id: code,
                                  cardFront: cardFront,
                                  cardBack: cardBack,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      text: 'Upload File',
                      svgIcon: 'assets/img/upload.svg',
                      buttonIconAlignment: .left,
                      iconSize: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
