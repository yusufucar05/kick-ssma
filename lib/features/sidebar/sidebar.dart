import 'package:flutter/material.dart';
import 'package:ssma/features/home/home_page.dart';

class SideBar extends StatelessWidget {
  final Function(AppPage) onPageSelected;

  const SideBar({super.key, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => onPageSelected(AppPage.streamSettings),
            child: const Text("Yayın Ayarları"),
          ),
          ElevatedButton(
            onPressed: () => onPageSelected(AppPage.dashboard),
            child: const Text("Düzenleme Kısmı"),
          ),
          ElevatedButton(
            onPressed: () => onPageSelected(AppPage.connectAccount),
            child: const Text("Hesabını Bağla"),
          ),
        ],
      ),
    );
  }
}
