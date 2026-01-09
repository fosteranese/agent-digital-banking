import 'package:flutter/material.dart';
import 'package:my_sage_agent/ui/components/form/button.dart';
import 'package:my_sage_agent/utils/theme.util.dart';

class RegisterClientStep3 extends StatelessWidget {
  const RegisterClientStep3({super.key});

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
          Container(
            alignment: .center,
            height: 216,
            margin: const .only(left: 20, right: 20, bottom: 20),
            padding: .symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: .circular(12)),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                Text(
                  'Scan the front and back of the client’s Ghana Card or upload a photo of the front and back',
                  textAlign: .center,
                  style: PrimaryTextStyle(fontSize: 14, fontWeight: .w400),
                ),
                const SizedBox(height: 20),
                FormButton(
                  onPressed: () {},
                  text: 'Scan Now',
                  svgIcon: 'assets/img/scan.svg',
                  buttonIconAlignment: .left,
                  iconSize: 24,
                ),
                const SizedBox(height: 10),
                FormButton(
                  backgroundColor: ThemeUtil.black,
                  foregroundColor: Colors.white,
                  onPressed: () {},
                  text: 'Upload File',
                  svgIcon: 'assets/img/upload.svg',
                  buttonIconAlignment: .left,
                  iconSize: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
