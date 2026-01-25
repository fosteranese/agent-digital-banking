import 'package:flutter/material.dart';

class ThemeUtil {
  static const String myriadPro = 'MyriadPro';
  static String fontMontrealDemiBold = 'MyriadPro';
  static String fontHelveticaNeue = 'MyriadPro';

  static TextStyle textStyle = TextStyle(fontFamily: myriadPro);

  // static const primaryColor = Color(0xffF9C500);
  static const primaryColor = Color(0xff007469);
  static const primaryColorList = Color(0xff919195);
  static const secondaryColor = Color(0xffF9C500);

  static const Color flat = Color(0xff54534A);
  static const Color black = Color(0xff010203);
  static const Color subtitleGrey = Color(0xff4F4F4F);
  static const Color headerBackground = Color(0xffF6F6F6);
  static const Color flora = Color(0xff919195);
  static const Color fade = Color(0xffD9DADB);
  static const Color highlight = Color(0xffF1F8FF);
  static const Color border = Color(0xffF0F0F0);
  static const Color inactiveBorder = Color(0xffE0E0E0);
  static const Color danger = Color(0xffE10303);
  static const Color offWhite = Color(0xffF1F1F1);
  static const Color grey = Color(0xff7D7D7D);
  static const Color success = Color(0xff007E13);
  static const Color pageColor = Color(0xffE5E5E5);
  static const Color inactivate = Color(0xffA9B6D5);
  static const Color inactiveState = Color(0xffFFF2D2);
  static const Color iconBg = Color(0xffF5F2EB);
}

class PrimaryTextStyle extends TextStyle {
  const PrimaryTextStyle({
    super.fontSize,
    super.fontWeight,
    super.fontStyle,
    super.color,
    super.letterSpacing,
    super.height,
    super.decoration,
    super.backgroundColor,
  }) : super(fontFamily: ThemeUtil.myriadPro);
}
