import 'package:flutter/material.dart';

class ThemeUtil {
  static const String myriadPro = 'MyriadPro';
  static String fontMontrealDemiBold = 'MyriadPro';
  static String fontHelveticaNeue = 'MyriadPro';

  static TextStyle textStyle = TextStyle(
    fontFamily: myriadPro,
  );

  static const primaryColor = Color(0xff010101);
  static const primaryColorList = Color(0xff919195);
  static const secondaryColor = Color(0xffF4B223);
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
