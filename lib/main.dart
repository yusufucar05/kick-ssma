import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:ssma/features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 950),
    minimumSize: Size(970, 920),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,

    titleBarStyle: TitleBarStyle.normal,
    title: "SSMA - Kick Stream Settings Manager",
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SSMA',
      home: HomePage(),
    );
  }
}
