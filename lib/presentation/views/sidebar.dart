import 'package:flutter/material.dart';
import 'package:ssma/core/constants/app_strings.dart';
import 'package:ssma/core/theme/app_colors.dart';
import 'package:ssma/features/sidebar/user_card.dart';
import 'package:ssma/presentation/viewmodels/home_view_model.dart';

class Sidebar extends StatefulWidget {
  final HomeViewModel viewModel; 
  final Function(int) onThemeChanged;
  final Function(int) onPageChanged;

  const Sidebar({
    super.key,
    required this.viewModel, 
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
          UserCard(
            viewModel: widget.viewModel,
          ), 
          const SizedBox(height: 40),

          _sidebarButton(AppStrings.menuSettings, Icons.settings,
            onTap: () => widget.onPageChanged(0),
          ),
          _sidebarButton(AppStrings.menuBackup, Icons.backup_outlined,
            onTap: () => widget.onPageChanged(1),
          ),

          _sidebarButton(AppStrings.menuTrash, Icons.delete_outline_rounded,
              onTap: () => widget.onPageChanged(2)),

          _sidebarButton(AppStrings.menuLinks, Icons.add_link,
            onTap: () => null,
          ),

          AnimatedBuilder(
            animation: widget.viewModel,
            builder: (context, child) {
              if (widget.viewModel.isConnected) {
                return _sidebarButton(
                  AppStrings.menuLogout,
                  Icons.logout_rounded,
                  onTap: () => widget.viewModel.logout(),
                );
              }
              return _sidebarButton(
                widget.viewModel.isConnecting
                    ? AppStrings.menuConnecting
                    : AppStrings.menuConnect,
                widget.viewModel.isConnecting
                    ? Icons.sync_rounded
                    : Icons.link_rounded,
                onTap: widget.viewModel.isConnecting
                    ? () {}
                    : () => widget.viewModel.connectToKick(),
              );
            },
          ),

          
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.redAccent, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "UYARI!",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Etiket ve +18 özellikleri şu an Kick API tarafından desteklenmiyor. Sorun Kick ekibine iletildi.",
                  style: TextStyle(
                    color: Colors.redAccent.withOpacity(0.8),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          

          const Spacer(),

          _sidebarButton(
            AppColors.themeMode == 1 ? AppStrings.menuLightMode : AppStrings.menuDarkMode,
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
