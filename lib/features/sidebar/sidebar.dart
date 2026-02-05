import 'package:flutter/material.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/features/sidebar/user_card.dart';
import 'package:ssma/features/webview/kick_webview_service.dart';

class Sidebar extends StatefulWidget {
  final Function(int) onThemeChanged;
  final Function(int) onPageChanged;
  const Sidebar({
    super.key,
    required this.onThemeChanged,
    required this.onPageChanged,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.sidebarBg,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          UserCard(),
          const SizedBox(height: 40),
          _sidebarButton(
            "Yayın Ayarlarım",
            Icons.settings,
            onTap: () => widget.onPageChanged(0),
          ),_sidebarButton(
            "Yedekleme Sistemi",
            Icons.backup_outlined,
            onTap: () => widget.onPageChanged(1),
          ),
          _sidebarButton("Bağlantı Adreslerim", Icons.add_link, onTap: () => null),

          _sidebarButton(
            "Hesabını Bağla",
            Icons.link,
            onTap: () => null,
          ),
          const Spacer(),

          _sidebarButton(
            AppColors.themeMode == 1 ? "Aydınlık Mod" : "Karanlık Mod",
            AppColors.themeMode == 1 ? Icons.light_mode : Icons.dark_mode,
            onTap: () {
              AppColors.themeMode = AppColors.themeMode == 1 ? 0 : 1;
              widget.onThemeChanged(AppColors.themeMode);
            },
          ),
        ],
      ),
    );
  }

  Widget _sidebarButton(
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.kickGreen),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
