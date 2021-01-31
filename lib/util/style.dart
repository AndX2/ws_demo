import 'package:flutter/material.dart';

/// Цвета в приложении
class ColorRes {
  static const legendary = Color(0xFFFA922E);
  static const epic = Color(0xFF9D2AF5);
  static const unusual = Color(0xFF266FD5);
  static const regular = Color(0xFF1CEC83);

  static const backGradientBegin = Color(0xFF351113);
  static const backGradientCenter = Color(0xFF210b0c);
  static const backGradientEnd = Color(0xFF060E13);

  static const textRed = Colors.red;
  static const textBlue = Color(0xFF54DFE7);
  static const textWhite = Color(0xFFE4E3E4);
  static const textYellow = Color(0xFFFBC13B);

  static const btnBackRed = Color(0x40F44336);
  static const splashBlue = Color(0x6054DFE7);
  static const msgBackBlue = Color(0x6054DFE7);
  static const msgBackYellow = Color(0x40FBC13B);
}

/// Текстовые стили
class StyleRes {
  static const content16Blue = TextStyle(fontSize: 16.0, fontFamily: 'play', color: ColorRes.textBlue);
  static const content20Blue = TextStyle(fontSize: 20.0, fontFamily: 'play', color: ColorRes.textBlue);
  static const content24Blue = TextStyle(fontSize: 24.0, fontFamily: 'play', color: ColorRes.textBlue);
  static const content24Yellow = TextStyle(fontSize: 24.0, fontFamily: 'play', color: ColorRes.textYellow);
  static const content32Blue = TextStyle(fontSize: 32.0, fontFamily: 'play', color: ColorRes.textBlue);
  static const content40Blue = TextStyle(fontSize: 40.0, fontFamily: 'play', color: ColorRes.textBlue);
  static const content64Blue = TextStyle(fontSize: 64.0, fontFamily: 'play', color: ColorRes.textBlue);

  static const head24Red = TextStyle(fontSize: 24.0, fontFamily: 'zelek', color: ColorRes.textRed);

  static const head36Red = TextStyle(fontSize: 36.0, fontFamily: 'zelek', color: ColorRes.textRed);

  static const head64Red = TextStyle(fontSize: 64.0, fontFamily: 'zelek', color: ColorRes.textRed);
}
