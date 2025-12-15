import 'package:flutter/material.dart';

class ThemeUtil {
  static const String myriadPro = 'MyriadPro';
  static String fontMontrealDemiBold = 'MyriadPro';
  static String fontHelveticaNeue = 'MyriadPro';

  static TextStyle textStyle = TextStyle(fontFamily: myriadPro);

  static const primaryColor = Color(0xff57B16B);
  static const primaryColor1 = Color(0xff0000B2);
  static const primaryColorList = Color(0xff919195);
  static const secondaryColor = Color(0xff57B16B);

  static const Color flat = Color(0xff54534A);
  static const Color black = Color(0xff010203);
  static const Color subtitleGrey = Color(0xff4F4F4F);
  static const Color headerBackground = Color(0xffF6F6F6);
  static const Color flora = Color(0xff919195);
  static const Color fade = Color(0xffD9DADB);
  static const Color highlight = Color(0xffF1F8FF);
  static const Color border = Color(0xffF0F0F0);
  static const Color danger = Color(0xffE10303);
  static const Color offWhite = Color(0xffF1F1F1);
  static const Color grey = Color(0xff7D7D7D);
  static const Color success = Color(0xff007E13);
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
