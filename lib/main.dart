import 'package:flutter/material.dart';
import 'package:ssma/features/home/home_page.dart';
import 'package:ssma/core/theme/app_theme.dart';

void main() {
  runApp(const KickPresetApp());
}

class KickPresetApp extends StatelessWidget {
  const KickPresetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kick Streamer Settings Manager',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
