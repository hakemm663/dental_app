import 'package:flutter/material.dart';

class ColorsManager {
  // Brand
  static const Color mainBlue = Color(0xFF247CFF);
  static const Color lightBlue = Color(0xFFF4F8FF);
  static const Color darkBlue = Color(0xFF242424);

  // Greys
  static const Color gray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFC2C2C2);
  static const Color lighterGray = Color(0xFFEDEDED);
  static const Color moreLightGray = Color(0xFFFDFDFF);
  static const Color moreLighterGray = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Status palette — kept centralised so success/danger/warning never drift
  // across screens. `*Bg` is the tinted background used behind the icon.
  static const Color successGreen = Color(0xFF22C55E);
  static const Color successGreenBg = Color(0xFFE8F5E9);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color dangerRedBg = Color(0xFFFFEBEE);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color warningOrangeBg = Color(0xFFFFF3E0);
  static const Color notificationDot = Color(0xFFFF4D6D);
  static const Color ratingStar = Color(0xFFFFB800);
}
