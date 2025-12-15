import 'package:flutter/material.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/ui/components/form/input.dart';
import 'package:my_sage_agent/ui/components/form/select.dart';
import 'package:my_sage_agent/ui/components/step_indicator.cm.dart';
import 'package:my_sage_agent/ui/components/stick_heder.dart';
import 'package:my_sage_agent/ui/layouts/main.layout.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

enum RegisterStep {
  personalInfo,
  residentialAddress,
  identityVerification,

  // int get currentIndex {
  //   switch (this) {
  //     case RegisterStep.personalInfo:
  //       return 0;
  //     case RegisterStep.residentialAddress:
  //       return 1;
  //     case RegisterStep.identityVerification:
  //       return 2;
  //   }
  // }
}

class RegisterStep1Page extends StatefulWidget {
  const RegisterStep1Page({super.key});
  static const String routeName = '/register/step-1';

  @override
  State<RegisterStep1Page> createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends State<RegisterStep1Page> {
  final _stage = ValueNotifier(RegisterStep.personalInfo);
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showBackBtn: true,
      title: 'Register Client',
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: MyHeaderDelegate(
            maxHeight: 80,
            minHeight: 80,
            builder: (context, shrinkOffset, overlapsContent) {
              return Container(
                margin: const .symmetric(vertical: 20),
                color: Color(0xffF1F4FB),
                child: ValueListenableBuilder(
                  valueListenable: _stage,
                  builder: (context, stage, child) {
                    return ListView(
                      padding: const .only(left: 20),
                      scrollDirection: .horizontal,
                      children: [
                        StepIndicator(index: 0, currentIndex: stage.index, title: 'Personal Info'),
                        StepIndicator(
                          index: 1,
                          currentIndex: stage.index,
                          title: 'Residential Address',
                        ),
                        StepIndicator(
                          index: 2,
                          currentIndex: stage.index,
                          title: 'Identity Verification',
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const .symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Register New Client',
                  style: PrimaryTextStyle(fontSize: 24, fontWeight: .w600),
                ),
                Text(
                  'Complete the form below with the client’s details',
                  style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400, color: ThemeUtil.flat),
                ),
                const SizedBox(height: 30),

                FormInput(label: 'Full Name *', placeholder: 'Enter full name'),
                FormSelect(
                  label: 'Gender *',
                  title: 'Enter gender',
                  options: [
                    FormSelectOption(value: 'male', text: 'Male'),
                    FormSelectOption(value: 'female', text: 'Female'),
                  ],
                ),
                FormInput(label: 'Phone Number *', placeholder: 'Eg. 0244123654'),
                FormInput(label: 'Email Address *', placeholder: 'Enter email address'),
              ],
            ),
          ),
        ),
      ],
      bottomNavigationBar: Container(
        padding: .only(left: 20, right: 20, top: 20),
        child: FormButton(onPressed: () {}, text: 'Continue'),
      ),
    );
  }
}
