import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_1.cm.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_2.cm.dart';
import 'package:my_sage_agent/ui/components/register/register_client_step_3.cm.dart';
import 'package:my_sage_agent/ui/components/step_indicator.cm.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum RegisterStep { personalInfo, residentialAddress, identityVerification }

class RegisterClientPage extends StatefulWidget {
  const RegisterClientPage({super.key});
  static const String routeName = '/register/step-1';

  @override
  State<RegisterClientPage> createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends State<RegisterClientPage> {
  final _stage = ValueNotifier(RegisterStep.personalInfo);
  final _pageController = PageController(initialPage: 0);

  void _onManual() {
    context.pop();
    _stage.value = RegisterStep.identityVerification;
    _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  final stageTitles = ['Personal Info', 'Residential Address', 'Identity Verification'];

  void _onStartGhanaCardVerification() async {
    await Permission.camera
        .onDeniedCallback(_onManual)
        .onGrantedCallback(() {
          // Navigator.push(
          //   MyApp.navigatorKey.currentContext!,
          //   MaterialPageRoute(
          //     builder: (context) => QrCodePage(
          //       title: title,
          //       operation: operation,
          //       subjectType: subjectType,
          //       onSuccess: (String qrCode) {
          //         Navigator.pop(context);
          //         onSuccess(qrCode);
          //       },
          //       onManual: () {
          //         // Navigator.pop(context);
          //         Navigator.pop(MyApp.navigatorKey.currentContext!);
          //         onManual();
          //       },
          //     ),
          //   ),
          // );
        })
        .onPermanentlyDeniedCallback(_onManual)
        .onRestrictedCallback(_onManual)
        .onLimitedCallback(_onManual)
        .onProvisionalCallback(_onManual)
        .request();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: CustomScrollView(
    //     primary: true,
    //     slivers: [
    //       SliverPersistentHeader(
    //         pinned: true,
    //         delegate: MyHeaderDelegate(
    //           maxHeight: 80,
    //           minHeight: 80,
    //           builder: (context, shrinkOffset, overlapsContent) {
    //             return Container(
    //               color: Colors.white,
    //               child: Container(
    //                 margin: const .symmetric(vertical: 20),
    //                 color: Color(0xffF1F4FB),
    //                 child: ValueListenableBuilder(
    //                   valueListenable: _stage,
    //                   builder: (context, stage, child) {
    //                     return ListView(
    //                       padding: const .only(left: 20),
    //                       scrollDirection: .horizontal,
    //                       children: [
    //                         for (var i = 0; i < stageTitles.length; i++)
    //                           StepIndicator(
    //                             index: i,
    //                             currentIndex: stage.index,
    //                             title: stageTitles[i],
    //                             onPressed: () {
    //                               _pageController.animateToPage(
    //                                 i,
    //                                 duration: Duration(milliseconds: 300),
    //                                 curve: Curves.easeIn,
    //                               );
    //                               _stage.value = RegisterStep.values[i];
    //                             },
    //                           ),
    //                       ],
    //                     );
    //                   },
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //       SliverFillRemaining(
    //         fillOverscroll: true,
    //         hasScrollBody: false,
    //         child: SizedBox(height: 200, child: Text('constraint.minHeight.toString()')),

    //         // LayoutBuilder(
    //         //   builder: (context, constraint) {
    //         //     return SizedBox(height: 200, child: Text(constraint.minHeight.toString()));
    //         //     // return SizedBox(
    //         //     //   height: constraint.maxHeight - 80,
    //         //     //   child: PageView(
    //         //     //     controller: _pageController,
    //         //     //     children: [RegisterClientStep1(), RegisterClientStep2(), RegisterClientStep3()],
    //         //     //   ),
    //         //     // );
    //         //   },
    //         // ),
    //       ),
    //     ],
    //   ),
    // );
    return MainLayout(
      showBackBtn: true,
      useSafeArea: false,
      title: 'Register Client',
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: MyHeaderDelegate(
            maxHeight: 80,
            minHeight: 80,
            builder: (context, shrinkOffset, overlapsContent) {
              return Container(
                color: Colors.white,
                child: Container(
                  margin: const .symmetric(vertical: 20),
                  color: Color(0xffF1F4FB),
                  child: ValueListenableBuilder(
                    valueListenable: _stage,
                    builder: (context, stage, child) {
                      return ListView(
                        padding: const .only(left: 20),
                        scrollDirection: .horizontal,
                        children: [
                          for (var i = 0; i < stageTitles.length; i++)
                            StepIndicator(
                              index: i,
                              currentIndex: stage.index,
                              title: stageTitles[i],
                              onPressed: () {
                                _pageController.animateToPage(
                                  i,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                                _stage.value = RegisterStep.values[i];
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),

        SliverFillRemaining(
          fillOverscroll: true,
          hasScrollBody: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            primary: false,
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _stage.value = RegisterStep.values[index];
              },
              children: [RegisterClientStep1(), RegisterClientStep2(), RegisterClientStep3()],
            ),
          ),
        ),
      ],
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _stage,
        builder: (context, value, child) {
          if (value == RegisterStep.identityVerification) {
            return SizedBox.shrink();
          }

          return SafeArea(
            top: false,
            bottom: true,
            child: Container(
              padding: .only(left: 20, right: 20, top: 20),
              child: FormButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: false,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return GhanaCardVerificationNotice(
                        onStartGhanaCardVerification: _onStartGhanaCardVerification,
                      );
                    },
                  );
                },
                text: 'Continue',
              ),
            ),
          );
        },
      ),
    );
  }
}

class GhanaCardVerificationNotice extends StatelessWidget {
  const GhanaCardVerificationNotice({super.key, required this.onStartGhanaCardVerification});
  final void Function() onStartGhanaCardVerification;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(View.of(context)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: ThemeUtil.offWhite),
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ThemeUtil.offWhite,
                foregroundColor: ThemeUtil.black,
              ),
              onPressed: () {},
              child: Text('Help'),
            ),
          ],
          actionsPadding: const .only(right: 10),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const .symmetric(horizontal: 20),
              child: Text(
                'Let\'s get your Identity Verified using you Ghana Card',
                style: PrimaryTextStyle(fontSize: 20, fontWeight: .w600, color: ThemeUtil.black),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const .symmetric(horizontal: 20),
              child: Text(
                'Kindly enable camera access to continue when prompted',
                style: PrimaryTextStyle(fontSize: 16, fontWeight: .w400, color: ThemeUtil.flat),
              ),
            ),
            const Spacer(),
            Image.asset('assets/img/ghana-card-1.png'),
            const Spacer(flex: 2),
          ],
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(
            padding: .only(left: 20, right: 20, top: 20),
            child: FormButton(onPressed: onStartGhanaCardVerification, text: 'Continue'),
          ),
        ),
      ),
    );
  }
}
