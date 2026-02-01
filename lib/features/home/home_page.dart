import 'package:flutter/material.dart';
import 'package:ssma/features/sidebar/sidebar.dart';
import 'package:ssma/features/presets/preset_grid.dart';
import 'package:ssma/features/webview/kick_webview_panel.dart';
import 'package:ssma/features/presets/widgets/streamer_profile_card.dart';
import 'package:ssma/pages/connect_account_page.dart';
import 'package:ssma/pages/dashboard_page.dart';
import 'package:ssma/pages/stream_settings_page.dart';

enum AppPage {
  dashboard,
  streamSettings,
  connectAccount,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppPage currentPage = AppPage.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          SideBar(
            onPageSelected: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),


          Expanded(
            child: _buildRightPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    switch (currentPage) {
      case AppPage.dashboard:
        return const DashboardPage();
      case AppPage.streamSettings:
        return const StreamSettingsPage();
      case AppPage.connectAccount:
        return const ConnectAccountPage();
    }
  }
}

