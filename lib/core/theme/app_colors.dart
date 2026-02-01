import 'package:flutter/material.dart';

class AppColors {
  static int themeMode = 1;

  static const Color kickGreen = Color(0xFF00E701);

  static Color get bg =>
      themeMode == 1 ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F5);
  static Color get surface =>
      themeMode == 1 ? const Color(0xFF1A1A1A) : Colors.white;
  static Color get text => themeMode == 1 ? Colors.white : Colors.black87;
  static Color get border => themeMode == 1 ? Colors.white10 : Colors.black12;
  static Color get sidebarBg =>
      themeMode == 1 ? const Color(0xFF151515) : Colors.white;
}
