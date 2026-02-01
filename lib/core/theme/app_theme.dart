import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
    );
  }
}
