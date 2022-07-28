import 'dart:ui';

import 'package:flutter/material.dart';

class LColors {
  static const primary = Color(0xFF518581);
  static const primary87 = Color(0xFF6E9996);
  static const primary54 = Color(0xFF8BAEAB);
  static const primary45 = Color(0xFFA8C2C0);
  static const primary38 = Color(0xFFC5D6D5);
  static const primary26 = Color(0xFFDCE7E6);

  static const secondary = Color(0xFFFFB23F);
  static const secondary87 = Color(0xFFFFBF5F);
  static const secondary54 = Color(0xFFFFCC7F);
  static const secondary45 = Color(0xFFFFD89F);
  static const secondary38 = Color(0xFFFFE5BF);
  static const secondary26 = Color(0xFFFFF0D9);

  static const title = Color(0xFF151411);
  static const title87 = Color(0xFF3C3B39);
  static const title54 = Color(0xFF636260);
  static const title45 = Color(0xFF8A8988);
  static const title38 = Color(0xFFB1B1B0);
  static const title26 = Color(0xFFD0D0CF);

  static const paragraph = Color(0xFFAFADB5);
  static const paragraph87 = Color(0xFFBCBBC1);
  static const paragraph54 = Color(0xFFCAC8CE);
  static const paragraph45 = Color(0xFFD7D6DA);
  static const paragraph38 = Color(0xFFE4E4E6);
  static const paragraph26 = Color(0xFFEFEFF0);

  static const placeholder = Color(0xFFF9F9F9);
  static const placeholder87 = Color(0xFFFAFAFA);
  static const placeholder54 = Color(0xFFFBFBFB);
  static const placeholder45 = Color(0xFFFCFCFC);
  static const placeholder38 = Color(0xFFFDFDFD);
  static const placeholder26 = Color(0xFFFEFEFE);

  static const screen = Color(0xFFFFFFFF);
  static const screenSecondary = Color(0xFFF3F3F3);
}

class LText {
  static const headingHeight = 1.3;
  static const paragraphHeight = 1.8;
  static const labelHeight = 1.8;

  Color? _color;
  double? _fontSize;
  FontStyle? _fontStyle;
  FontWeight? _fontWeight;
  double? _height;
  double? _letterSpacing;
  String? _fontFamily;

  TextStyle get done => TextStyle(
        color: _color,
        fontSize: _fontSize,
        fontStyle: _fontStyle,
        fontWeight: _fontWeight,
        height: _height,
        fontFamily: _fontFamily,
        letterSpacing: _letterSpacing,
      );

  LText color(Color? color) => this.._color = color;

  LText fontSize(double? fontSize) => this.._fontSize = fontSize;

  LText fontStyle(FontStyle? fontStyle) => this.._fontStyle = fontStyle;

  LText fontWeight(FontWeight? fontWeight) => this.._fontWeight = fontWeight;

  LText height(double? height) => this.._height = height;

  LText letterSpacing(double? letterSpacing) =>
      this.._letterSpacing = letterSpacing;

  LText fontFamily(String? fontFamily) => this.._fontFamily = fontFamily;

  LText();

  factory LText._h() => LText()
      .color(LColors.title)
      .fontWeight(FontWeight.bold)
      .height(headingHeight);

  factory LText.h1() => LText._h().fontSize(64);

  factory LText.h2() => LText._h().fontSize(44);

  factory LText.h3plus() => LText._h().fontSize(26);

  factory LText.h3() => LText._h().fontSize(24);

  factory LText.h4() => LText._h().fontSize(20);

  factory LText.h5() => LText._h().fontSize(18);

  factory LText.h6() => LText._h().fontSize(16);

  factory LText.h6plus() => LText._h().fontSize(14);

  factory LText._p() => LText()
      .color(LColors.paragraph)
      .fontWeight(FontWeight.w500)
      .height(paragraphHeight);

  factory LText.p1() => LText._p().fontSize(18);

  factory LText.p2() => LText._p().fontSize(16);

  factory LText.p3() => LText._p().fontSize(14);

  factory LText.p4() => LText._p().fontSize(12);

  factory LText._l() => LText()
      .color(LColors.paragraph)
      .fontWeight(FontWeight.bold)
      .height(labelHeight);

  factory LText.l1() => LText._l().fontSize(18);

  factory LText.l2() => LText._l().fontSize(16);

  factory LText.l3() => LText._l().fontSize(14);
}
